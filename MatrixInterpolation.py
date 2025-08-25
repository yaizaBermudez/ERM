import numpy as np
import scipy.io as sio

def matrix_interpolation():
    """Interpolate between four models via convex combinations."""
    m1 = sio.loadmat('model2.mat')
    m2 = sio.loadmat('model3.mat')
    m3 = sio.loadmat('model4.mat')
    m4 = sio.loadmat('model5.mat')

    res = 10
    tolerance = 1e-10
    inter = np.linspace(0, 1, res)
    A, B, C, D = np.meshgrid(inter, inter, inter, inter, indexing='ij')
    cone = np.column_stack([A.ravel(), B.ravel(), C.ravel(), D.ravel()])
    Cx = cone[np.abs(cone.sum(axis=1) - 1) < tolerance]

    Cell_m = []
    for coeffs in Cx:
        c1, c2, c3, c4 = coeffs
        Cell_m.append([
            c1*m1['w12'] + c2*m2['w12'] + c3*m3['w12'] + c4*m4['w12'],
            c1*m1['b12'] + c2*m2['b12'] + c3*m3['b12'] + c4*m4['b12'],
            c1*m1['w23'] + c2*m2['w23'] + c3*m3['w23'] + c4*m4['w23'],
            c1*m1['b23'] + c2*m2['b23'] + c3*m3['b23'] + c4*m4['b23'],
            c1*m1['w34'] + c2*m2['w34'] + c3*m3['w34'] + c4*m4['w34'],
            c1*m1['b34'] + c2*m2['b34'] + c3*m3['b34'] + c4*m4['b34'],
        ])
    return Cell_m, Cx
