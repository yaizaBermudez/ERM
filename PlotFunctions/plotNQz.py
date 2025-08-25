import numpy as np
import matplotlib.pyplot as plt

def plot_nqz(ax, alpha, nqz, mm=None, std=None, z=None, onstd=True):
    """Replicates MATLAB's plotNQz function in Python.

    Parameters
    ----------
    ax : matplotlib.axes.Axes
        Axis on which to draw.
    alpha : array_like
        Sampling parameter values.
    nqz : ndarray
        Matrix with columns representing each quantity to plot.
    mm : ndarray, optional
        Unused placeholder to mirror MATLAB signature.
    std : ndarray, optional
        Standard deviation for each curve. Should match nqz's shape.
    z : sequence, optional
        Unused placeholder to mirror MATLAB signature.
    onstd : bool, default True
        Whether to display the standard deviation bands.
    """
    col = ['r', 'b', 'm', 'g']
    lin = ['-', '--', '-.', ':']
    nqz = np.asarray(nqz)
    n = nqz.shape[1]
    if std is None:
        std = np.zeros_like(nqz)
    else:
        std = np.asarray(std)
    ymin = np.min(nqz)
    ymax = np.max(nqz)
    for i in range(n):
        if onstd:
            ax.fill_between(alpha, nqz[:, i] - std[:, i], nqz[:, i] + std[:, i],
                             color=col[i], edgecolor='white', alpha=0.2)
        ax.plot(alpha, nqz[:, i], color=col[i], linestyle=lin[i], linewidth=2)
    ax.set_ylim([ymin, ymax])
    labels = ['Type-I ERM-RER', 'Type-II ERM-RER', 'Shannon-Jensen', 'Hellinger'][:n]
    ax.legend(labels, loc='best', fontsize=12)
    ax.grid(True)
    ax.set_xlabel(r'$Q(\{L_{\mathbf{z}}(\boldsymbol{\theta})<0.5\})$', fontsize=12)
    return ax.figure.get_size_inches()
