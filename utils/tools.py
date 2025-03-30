import os
import re

import numpy as np
import torch
import matplotlib.pyplot as plt
import pandas as pd
import math

plt.switch_backend('agg')


def adjust_learning_rate(optimizer, epoch, args, scheduler=None, printout=True):
    # lr = args.learning_rate * (0.2 ** (epoch // 2))
    if args.lradj == 'type1':
        lr_adjust = {epoch: args.learning_rate * (0.5 ** ((epoch - 1) // 1))}
    elif args.lradj == 'type2':
        lr_adjust = {
            2: 5e-5, 4: 1e-5, 6: 5e-6, 8: 1e-6,
            10: 5e-7, 15: 1e-7, 20: 5e-8
        }
    elif args.lradj == "cosine":
        lr_adjust = {epoch: args.learning_rate /2 * (1 + math.cos(epoch / args.train_epochs * math.pi))}
    elif args.lradj == "type3":
        lr_adjust = {epoch: args.learning_rate if epoch < 3 else args.learning_rate * (0.9 ** ((epoch - 3) // 1))}
    elif args.lradj == 'TST':
        lr_adjust = {epoch: scheduler.get_last_lr()[0]}
    if epoch in lr_adjust.keys():
        lr = lr_adjust[epoch]
        for param_group in optimizer.param_groups:
            param_group['lr'] = lr
        if printout:
            print('Updating learning rate to {}'.format(lr))


class AverageMeter(object):
    """Computes and stores the average and current value"""
    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count

    
class EarlyStopping:
    def __init__(self, patience=7, verbose=False, delta=0):
        self.patience = patience
        self.verbose = verbose
        self.counter = 0
        self.best_score = None
        self.early_stop = False
        self.val_loss_min = np.inf
        self.delta = delta

    def __call__(self, val_loss, model, path):
        score = -val_loss
        if self.best_score is None:
            self.best_score = score
            self.save_checkpoint(val_loss, model, path)
        elif score < self.best_score + self.delta:
            self.counter += 1
            print(f'EarlyStopping counter: {self.counter} out of {self.patience}')
            if self.counter >= self.patience:
                self.early_stop = True
        else:
            self.best_score = score
            self.save_checkpoint(val_loss, model, path)
            self.counter = 0

    def save_checkpoint(self, val_loss, model, path):
        if self.verbose:
            print(f'Validation loss decreased ({self.val_loss_min:.6f} --> {val_loss:.6f}).  Saving model ...')
        torch.save(model.state_dict(), path + '/' + 'checkpoint.pth')
        self.val_loss_min = val_loss


class dotdict(dict):
    """dot.notation access to dictionary attributes"""
    __getattr__ = dict.get
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__


class StandardScaler():
    def __init__(self, mean, std):
        self.mean = mean
        self.std = std

    def transform(self, data):
        return (data - self.mean) / self.std

    def inverse_transform(self, data):
        return (data * self.std) + self.mean


def visual(true, preds=None, name='./pic/test.pdf'):
    """
    Results visualization
    """
    plt.figure()
    plt.plot(true, label='GroundTruth', linewidth=2, color='#F8CA7F')
    if preds is not None:
        plt.plot(preds, label='Prediction', linewidth=2, color='#63B1EE')
    plt.legend()
    plt.savefig(name, bbox_inches='tight')

def visual_timester(true, preds=None, timester=None, bonster=None, name='./pic/test.pdf'):
    """
    Results visualization
    """
    name = name.rsplit('.', 1)

    plt.figure()
    if timester is not None:
        plt.plot(timester, label='TimeSter', linewidth=2, color='#76DA91')
    plt.plot(true, label='GroundTruth', linewidth=2, color='#F8CA7F')
    plt.legend()
    plt.savefig(name[0]+'_timester.'+name[1], bbox_inches='tight')
    y_limits = plt.ylim()
    plt.clf()

    plt.figure()
    if bonster is not None:
        plt.plot(bonster, label='BonSter', linewidth=2, color='#D79FDC')
    plt.plot(true, label='GroundTruth', linewidth=2, color='#F8CA7F')
    plt.ylim(y_limits)
    plt.legend()
    plt.savefig(name[0]+'_bonster.'+name[1], bbox_inches='tight')
    plt.clf()

    plt.figure()
    if preds is not None:
        plt.plot(preds, label='Prediction', linewidth=2, color='#63B1EE')
    plt.plot(true, label='GroundTruth', linewidth=2, color='#F8CA7F')
    plt.ylim(y_limits)
    plt.legend()
    plt.savefig(name[0]+'_pred.'+name[1], bbox_inches='tight')
    plt.clf()

def adjustment(gt, pred):
    anomaly_state = False
    for i in range(len(gt)):
        if gt[i] == 1 and pred[i] == 1 and not anomaly_state:
            anomaly_state = True
            for j in range(i, 0, -1):
                if gt[j] == 0:
                    break
                else:
                    if pred[j] == 0:
                        pred[j] = 1
            for j in range(i, len(gt)):
                if gt[j] == 0:
                    break
                else:
                    if pred[j] == 0:
                        pred[j] = 1
        elif gt[i] == 0:
            anomaly_state = False
        if anomaly_state:
            pred[i] = 1
    return gt, pred


def cal_accuracy(y_pred, y_true):
    return np.mean(y_pred == y_true)

def extract_time_feature_type(strings):
    result = []
    for s in strings:
        match = re.findall(r'[A-Z]', s)
        if len(match) >= 3:
            result.append(match[0] + match[2])
        elif len(match) >= 1:
            result.append(match[0])
        else:
            result.append('') 
    return ''.join(result)