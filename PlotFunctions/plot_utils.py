import numpy as np
import matplotlib.pyplot as plt

COLORS = ['r', 'b', 'm', 'g']
LINES = ['-', '--', '-.', ':']


def plot_erm_sen_t1_vs_t2(ax, lamb, R, std, labels, loglog=True, onstd=True):
    R = np.asarray(R)
    std = np.asarray(std)
    n = R.shape[1]
    for i in range(n):
        if onstd:
            ax.fill_between(lamb, R[:, i] - std[:, i], R[:, i] + std[:, i],
                         color=COLORS[i], edgecolor='white', alpha=0.2)
        ax.plot(lamb, R[:, i], color=COLORS[i], linestyle=LINES[i], linewidth=2)
    if loglog:
        ax.set_xscale('log')
        ax.set_yscale('log')
    ymin = np.min(R - std)
    ymax = np.max(R + std)
    ax.set_ylim([ymin, ymax])
    ax.legend(labels, loc='best', fontsize=13)
    ax.grid(True)
    ax.set_xlabel(r'Parameter ($\lambda$)')
    return ax.figure.get_size_inches()


def plot_emp_risk_t1_vs_t2(ax, lamb, R, std, labels, loglog=True, onstd=True):
    R = np.asarray(R)
    std = np.asarray(std)
    n = R.shape[1]
    for i in range(n):
        if onstd:
            ax.fill_between(lamb, R[:, i] - std[:, i], R[:, i] + std[:, i],
                         color=COLORS[i], edgecolor='white', alpha=0.2)
        ax.plot(lamb, R[:, i], color=COLORS[i], linestyle=LINES[i], linewidth=2)
    if loglog:
        ax.set_xscale('log')
        ax.set_yscale('log')
    ymin = np.min(R - std)
    ymax = np.max(R + std)
    ax.set_ylim([ymin, ymax])
    ax.legend(labels, loc='best', fontsize=13)
    ax.grid(True)
    ax.set_xlabel(r'Parameter ($\lambda$)')
    return ax.figure.get_size_inches()
