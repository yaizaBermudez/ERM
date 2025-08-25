import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
from plot_utils import plot_erm_sen_t1_vs_t2, plot_emp_risk_t1_vs_t2
from plotNQz import plot_nqz


def _stats(arr, z_idx):
    arr = np.asarray(arr)
    slice_arr = arr[:, z_idx, :]
    return (
        slice_arr.mean(axis=2),
        slice_arr.max(axis=2),
        slice_arr.min(axis=2),
        slice_arr.std(axis=2),
    )


def main():
    data = sio.loadmat('PropQ_v1_all.mat')
    lamb = np.squeeze(data.get('alpha'))
    n = 100
    z_idx = 1
    plot_std = False

    gp_all = [[] for _ in range(4)]
    rze_all = [[] for _ in range(4)]
    rzt_all = [[] for _ in range(4)]

    for i in range(n):
        for t in range(1,5):
            Rz0 = np.asarray(data[f'Rz0T{t}_all'].ravel()[i])
            Rz1 = np.asarray(data[f'Rz1T{t}_all'].ravel()[i])
            Rz2 = np.asarray(data[f'Rz2T{t}_all'].ravel()[i])
            gp_all[t-1].append(np.column_stack((
                Rz0[:,1]-Rz0[:,0],
                Rz1[:,1]-Rz1[:,0],
                Rz2[:,1]-Rz2[:,0],
            )))
            rze_all[t-1].append(np.column_stack((Rz0[:,0], Rz1[:,0], Rz2[:,0])))
            rzt_all[t-1].append(np.column_stack((Rz0[:,1], Rz1[:,1], Rz2[:,1])))

    gp = [np.stack(lst, axis=2) for lst in gp_all]
    rze = [np.stack(lst, axis=2) for lst in rze_all]
    rzt = [np.stack(lst, axis=2) for lst in rzt_all]

    gp_stats = [_stats(g, z_idx) for g in gp]
    rze_stats = [_stats(r, z_idx) for r in rze]
    rzt_stats = [_stats(r, z_idx) for r in rzt]

    rg = [np.stack(data[f'RzT{t}g_all'].ravel()[:n], axis=2) for t in range(1,5)]
    rg_stats = [_stats(g, z_idx) for g in rg]

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
        np.column_stack([s[0] for s in rg_stats]),
        np.column_stack([s[3] for s in rg_stats]),
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

    # Normalization function plot
    bt1z1 = np.squeeze(data.get('bt1z1'))
    bt2z1 = np.squeeze(data.get('bt2z1'))
    bt3z1 = np.squeeze(data.get('bt3z1'))
    bt4z1 = np.squeeze(data.get('bt4z1'))
    fig18, ax18 = plt.subplots()
    plot_nqz(
        ax18,
        lamb,
        np.column_stack([bt1z1, bt2z1, bt3z1, bt4z1]),
        std=np.zeros((len(lamb), 4)),
        onstd=plot_std,
    )

    fid = '_Lambda1'
    if True:
        fig15.savefig(f'RfSensMean{fid}.png', dpi=300)
        fig16.savefig(f'RfGenGapMean{fid}.png', dpi=300)
        fig17.savefig(f'RfTraining{fid}.png', dpi=300)
        fig18.savefig(f'NormFunction{fid}.png', dpi=300)


if __name__ == '__main__':
    main()
