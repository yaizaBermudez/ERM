import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
from plot_utils import plot_erm_sen_t1_vs_t2, plot_emp_risk_t1_vs_t2
from plotNQzlog import plot_nqz as plot_nqz_log


def _stats_matrix(mat):
    return mat.mean(axis=1), mat.max(axis=1), mat.min(axis=1), mat.std(axis=1)


def _stats(arr):
    return arr.mean(axis=2), arr.max(axis=2), arr.min(axis=2), arr.std(axis=2)


def main():
    data = sio.loadmat('Proj_2025-May-22_16-39_MNIST.mat')
    n = np.count_nonzero([x is not None for x in data['RzT1_all'].ravel()])
    lamb = np.squeeze(data.get('lamb'))
    plot_std = True

    gp = []
    for t in range(1,5):
        arr = np.concatenate([np.asarray(data[f'GpT{t}_all'].ravel()[i])
                               for i in range(n)], axis=1)
        gp.append(arr)

    gp_stats = [_stats_matrix(g) for g in gp]

    rz_t = []
    rz_e = []
    for t in range(1,5):
        arr = np.stack(data[f'RzT{t}_all'].ravel()[:n], axis=2)
        rz_e.append(arr[:,0,:])
        rz_t.append(arr[:,1,:])

    rzt_stats = [_stats(r) for r in rz_t]
    rze_stats = [_stats(r) for r in rz_e]

    nqz = []
    for t in range(1,5):
        arr = np.concatenate([np.asarray(data[f'NQzT{t}_all'].ravel()[i])
                               for i in range(n)], axis=1)
        if t in (1,3,4):
            arr = -arr
        nqz.append(arr)
    nqz_stats = [_stats_matrix(a) for a in nqz]

    labels = ['Type-I ERM-RER', 'Type-II ERM-RER', 'Shannon-Jensen', 'Hellinger']

    fig15, ax15 = plt.subplots()
    plot_erm_sen_t1_vs_t2(
        ax15,
        lamb,
        np.column_stack([s[0] for s in gp_stats]),
        np.column_stack([s[3] for s in gp_stats]),
        labels,
        onstd=plot_std,
    )

    fig16, ax16 = plt.subplots()
    plot_emp_risk_t1_vs_t2(
        ax16,
        lamb,
        np.column_stack([s[0] for s in rzt_stats]),
        np.column_stack([s[3] for s in rzt_stats]),
        labels,
        onstd=plot_std,
    )

    fig17, ax17 = plt.subplots()
    plot_emp_risk_t1_vs_t2(
        ax17,
        lamb,
        np.column_stack([s[0] for s in rze_stats]),
        np.column_stack([s[3] for s in rze_stats]),
        labels,
        onstd=plot_std,
    )

    fig18, ax18 = plt.subplots()
    plot_nqz_log(
        ax18,
        lamb,
        np.column_stack([s[0] for s in nqz_stats]),
        std=np.column_stack([s[3] for s in nqz_stats]),
        onstd=plot_std,
        ymax=2,
    )

    fid = '_UniQ'
    if False:
        fig15.savefig(f'RfSensMean{fid}.png', dpi=300)
        fig16.savefig(f'RfGenGapMean{fid}.png', dpi=300)
        fig17.savefig(f'RfTraining{fid}.png', dpi=300)
        fig18.savefig(f'NormFunction{fid}.png', dpi=300)


if __name__ == '__main__':
    main()
