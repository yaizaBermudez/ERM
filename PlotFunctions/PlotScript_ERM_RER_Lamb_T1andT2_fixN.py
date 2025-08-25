import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt
from plot_utils import plot_erm_sen_t1_vs_t2, plot_emp_risk_t1_vs_t2


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
    data = sio.loadmat('PropLambda_v2.mat')
    lamb = np.squeeze(data.get('lamb'))
    n = 100
    z_idx = 1  # MATLAB z=2 -> index 1

    GpT1_all, GpT2_all = [], []
    RzT1e_all, RzT2e_all = [], []
    RzT1t_all, RzT2t_all = [], []

    for i in range(n):
        Rz0T1 = np.asarray(data['Rz0T1_all'].ravel()[i])
        Rz1T1 = np.asarray(data['Rz1T1_all'].ravel()[i])
        Rz2T1 = np.asarray(data['Rz2T1_all'].ravel()[i])
        Rz0T2 = np.asarray(data['Rz0T2_all'].ravel()[i])
        Rz1T2 = np.asarray(data['Rz1T2_all'].ravel()[i])
        Rz2T2 = np.asarray(data['Rz2T2_all'].ravel()[i])

        GpT1_all.append(np.column_stack((
            Rz0T1[:, 1] - Rz0T1[:, 0],
            Rz1T1[:, 1] - Rz1T1[:, 0],
            Rz2T1[:, 1] - Rz2T1[:, 0],
        )))
        GpT2_all.append(np.column_stack((
            Rz0T2[:, 1] - Rz0T2[:, 0],
            Rz1T2[:, 1] - Rz1T2[:, 0],
            Rz2T2[:, 1] - Rz2T2[:, 0],
        )))

        RzT1e_all.append(np.column_stack((Rz0T1[:, 0], Rz1T1[:, 0], Rz2T1[:, 0])))
        RzT2e_all.append(np.column_stack((Rz0T2[:, 0], Rz1T2[:, 0], Rz2T2[:, 0])))
        RzT1t_all.append(np.column_stack((Rz0T1[:, 1], Rz1T1[:, 1], Rz2T1[:, 1])))
        RzT2t_all.append(np.column_stack((Rz0T2[:, 1], Rz1T2[:, 1], Rz2T2[:, 1])))

    GpT1 = np.stack(GpT1_all, axis=2)
    GpT2 = np.stack(GpT2_all, axis=2)
    RzT1e = np.stack(RzT1e_all, axis=2)
    RzT2e = np.stack(RzT2e_all, axis=2)
    RzT1t = np.stack(RzT1t_all, axis=2)
    RzT2t = np.stack(RzT2t_all, axis=2)

    GpT1_m, GpT1_mx, GpT1_mn, GpT1_s = _stats(GpT1, z_idx)
    GpT2_m, GpT2_mx, GpT2_mn, GpT2_s = _stats(GpT2, z_idx)
    RzT1e_m, RzT1e_mx, RzT1e_mn, RzT1e_s = _stats(RzT1e, z_idx)
    RzT2e_m, RzT2e_mx, RzT2e_mn, RzT2e_s = _stats(RzT2e, z_idx)
    RzT1t_m, RzT1t_mx, RzT1t_mn, RzT1t_s = _stats(RzT1t, z_idx)
    RzT2t_m, RzT2t_mx, RzT2t_mn, RzT2t_s = _stats(RzT2t, z_idx)

    # Generalization gaps provided in MAT file
    RzT1g = np.stack(data['RzT1g_all'].ravel()[:n], axis=2)
    RzT2g = np.stack(data['RzT2g_all'].ravel()[:n], axis=2)
    RzT1g_m, RzT1g_mx, RzT1g_mn, RzT1g_s = _stats(RzT1g, z_idx)
    RzT2g_m, RzT2g_mx, RzT2g_mn, RzT2g_s = _stats(RzT2g, z_idx)

    fig15, ax15 = plt.subplots()
    plot_erm_sen_t1_vs_t2(ax15, lamb,
                          np.column_stack((GpT1_m, GpT2_m)),
                          np.column_stack((GpT1_s, GpT2_s)),
                          ['1', '2'])

    fig16, ax16 = plt.subplots()
    plot_emp_risk_t1_vs_t2(ax16, lamb,
                           np.column_stack((RzT1g_m, RzT2g_m)),
                           np.column_stack((RzT1g_s, RzT2g_s)),
                           ['1', '2'])

    fig17, ax17 = plt.subplots()
    plot_emp_risk_t1_vs_t2(ax17, lamb,
                           np.column_stack((RzT1e_m, RzT2e_m)),
                           np.column_stack((RzT1e_s, RzT2e_s)),
                           ['1', '1'])

    fid = '_UniQ'
    if True:
        fig15.savefig(f'NumPlot19RT1vsT2SensMean{fid}.png', dpi=300)
        fig16.savefig(f'NumPlot19RT1vsT2GenGapMean{fid}.png', dpi=300)
        fig17.savefig(f'NumPlot19RT1vsT2Training{fid}.png', dpi=300)


if __name__ == '__main__':
    main()
