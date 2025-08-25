import numpy as np
import matplotlib.pyplot as plt

def plot_nqz(ax, lamb, nqz, mm=None, std=None, z=None, onstd=True, ymax=None):
    """Log-scale variant of plot_nqz."""
    col = [
        [33/255, 19/255, 89/255],
        [164/255, 142/255, 246/255],
        [100/255, 16/255, 244/255],
        [196/255, 187/255, 250/255],
    ]
    lin = ['-', '--', '-.', ':']
    nqz = np.asarray(nqz)
    n = nqz.shape[1]
    if std is None:
        std = np.zeros_like(nqz)
    else:
        std = np.asarray(std)
    ymin = np.min(nqz)
    if ymax is None:
        ymax = np.max(nqz)
    for i in range(n):
        if onstd:
            ax.fill_between(lamb, nqz[:, i] - std[:, i], nqz[:, i] + std[:, i],
                             color=col[i], edgecolor='white', alpha=0.2)
        ax.plot(lamb, nqz[:, i], color=col[i], linestyle=lin[i], linewidth=3)
    ax.set_xscale('log')
    ax.set_ylim([ymin, ymax])
    labels = ['Type-I ERM-RER', 'Type-II ERM-RER', 'Shannon-Jensen', 'Hellinger'][:n]
    ax.legend(labels, loc='best', fontsize=12)
    ax.set_xlabel(r'Parameter ($\lambda$)')
    return ax.figure.get_size_inches()
