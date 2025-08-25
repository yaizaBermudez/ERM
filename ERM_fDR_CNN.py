import os
import sys
import numpy as np
import scipy.io as sio
import pandas as pd
import matplotlib.pyplot as plt
from elu_fast import elu_fast

# Add PlotFunctions to the path so we can reuse the repository's
# plotting helpers rather than defining our own Matplotlib code.
sys.path.append(os.path.join(os.path.dirname(__file__), "PlotFunctions"))
from plot_utils import plot_erm_sen_t1_vs_t2, plot_emp_risk_t1_vs_t2
from plotNQzlog import plot_nqz

def formatdata(data):
    n_samples = data.shape[0]
    labels = data[:n_samples, 0].astype(int)
    y = np.zeros((10, n_samples))
    y[labels, np.arange(n_samples)] = 1
    x = data[:n_samples, 1:785] / 255.0
    return x, y

def empiricalrisk(model, x, y):
    x = x.T
    w2, b2, w3, b3, w4, b4 = model
    out2 = elu_fast(w2 @ x + b2)
    out3 = elu_fast(w3 @ out2 + b3)
    out = elu_fast(w4 @ out3 + b4)
    pred = np.argmax(out, axis=0)
    loss = np.sum(pred != y)
    return loss / x.shape[1]

def cnvxmodels(m1, m2, m3, m4, Cx):
    return [
        Cx[0]*m1[0] + Cx[1]*m2[0] + Cx[2]*m3[0] + Cx[3]*m4[0],
        Cx[0]*m1[1] + Cx[1]*m2[1] + Cx[2]*m3[1] + Cx[3]*m4[1],
        Cx[0]*m1[2] + Cx[1]*m2[2] + Cx[2]*m3[2] + Cx[3]*m4[2],
        Cx[0]*m1[3] + Cx[1]*m2[3] + Cx[2]*m3[3] + Cx[3]*m4[3],
        Cx[0]*m1[4] + Cx[1]*m2[4] + Cx[2]*m3[4] + Cx[3]*m4[4],
        Cx[0]*m1[5] + Cx[1]*m2[5] + Cx[2]*m3[5] + Cx[3]*m4[5],
    ]

def main():
    batch = 1
    n_sampl = 100
    per = 2/3
    perts = 2/3

    data_tr = np.loadtxt('mnist_train.csv', delimiter=',')
    data_ts = np.loadtxt('mnist_test.csv', delimiter=',')
    Xtr, _ = formatdata(data_tr)
    Xts, _ = formatdata(data_ts)
    Ytr = data_tr[:, 0].astype(int)
    Yts = data_ts[:, 0].astype(int)

    n_samples = Xtr.shape[0]
    n_smap_ts = Xts.shape[0]

    m1 = sio.loadmat('Models/model2.mat')
    m2 = sio.loadmat('Models/model3.mat')
    m3 = sio.loadmat('Models/model4.mat')
    m4 = sio.loadmat('Models/model5.mat')
    Cx = sio.loadmat('Models/convex_short_220.mat')['Cx']

    M1 = [m1['w12'], m1['b12'], m1['w23'], m1['b23'], m1['w34'], m1['b34']]
    M2 = [m2['w12'], m2['b12'], m2['w23'], m2['b23'], m2['w34'], m2['b34']]
    M3 = [m3['w12'], m3['b12'], m3['w23'], m3['b23'], m3['w34'], m3['b34']]
    M4 = [m4['w12'], m4['b12'], m4['w23'], m4['b23'], m4['w34'], m4['b34']]

    k = Cx.shape[0]
    rng = np.random.default_rng(1)
    indx = rng.choice(n_samples, size=round(n_samples*per), replace=False)
    indxts = rng.choice(n_smap_ts, size=round(n_smap_ts*perts), replace=False)
    Z1x = Xtr[indx]
    Z1y = Ytr[indx]
    Z2x = Xts[indxts]
    Z2y = Yts[indxts]

    Lz1 = np.zeros(k)
    Lz2 = np.zeros(k)
    for i in range(k):
        m = cnvxmodels(M1, M2, M3, M4, Cx[i])
        Lz1[i] = empiricalrisk(m, Z1x, Z1y)
        Lz2[i] = empiricalrisk(m, Z2x, Z2y)

    Qpdf = np.ones(k) / k
    dQ = Qpdf

    lamb = np.logspace(-3, 2, n_sampl)
    bt1z1 = np.zeros(n_sampl)
    Rz1p1z1 = np.zeros(n_sampl)
    Rz2p1z1 = np.zeros(n_sampl)

    Lz1dQ = Lz1 * dQ
    Lz2dQ = Lz2 * dQ

    for i in range(n_sampl):
        lambda_ = lamb[i]
        P1_z1 = np.exp(-Lz1 / lambda_) * dQ
        P1_z1 = P1_z1 / np.sum(P1_z1)
        bt1z1[i] = -lambda_ + lambda_ * np.log(np.sum(np.exp(-Lz1 / lambda_) * dQ))
        Rz1p1z1[i] = np.sum(Lz1dQ * P1_z1)
        Rz2p1z1[i] = np.sum(Lz2dQ * P1_z1)

    GpT1 = np.abs(Rz2p1z1 - Rz1p1z1)
    RzT1 = np.column_stack([Rz1p1z1, Rz2p1z1])
    results = {"GpT1": GpT1, "RzT1": RzT1, "NQzT1": bt1z1, "lamb": lamb}

    # Save results to CSV
    df = pd.DataFrame(
        {
            "lamb": lamb,
            "GpT1": GpT1,
            "Rz1p1z1": RzT1[:, 0],
            "Rz2p1z1": RzT1[:, 1],
            "NQzT1": bt1z1,
        }
    )
    df.to_csv("ERM_fDR_CNN_results.csv", index=False)

    # Plot results using helper functions from PlotFunctions
    fig1, ax1 = plt.subplots()
    plot_erm_sen_t1_vs_t2(ax1, lamb, GpT1[:, None], np.zeros_like(GpT1)[:, None],
                          labels=["Type-I ERM-RER"], loglog=False, onstd=False)
    ax1.set_xscale("log")

    fig2, ax2 = plt.subplots()
    plot_emp_risk_t1_vs_t2(ax2, lamb, RzT1, np.zeros_like(RzT1),
                           labels=["Train", "Test"], loglog=False, onstd=False)
    ax2.set_xscale("log")

    fig3, ax3 = plt.subplots()
    plot_nqz(ax3, lamb, bt1z1[:, None], onstd=False)

    plt.show()

    return results

if __name__ == '__main__':
    main()
