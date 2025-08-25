import numpy as np

def findbetaf(Lz, Integral, lambd, dP, name, n=10):
    """Find beta such that the integral of dP equals one."""
    supp = Integral == 0
    minlz = np.min(np.where(supp, np.inf, Lz))
    lgm = 0.0
    ibeta = 0.0
    if name == 'Type1':
        raise ValueError('No need for findbeta for Type1')
    elif name == 'Type2':
        if minlz == 0:
            minlz = -1e-8
        r = np.floor(np.log10(np.abs(minlz)))
        res = r - 2
        mnbeta = -minlz
        mxbeta = lambd
    elif name == 'JSerm':
        b = -minlz + lambd * np.log(0.5)
        r = np.floor(np.log10(np.abs(b)))
        bv = np.arange(b - 10**(r-1), b + 10**(r-1) + 10**(r-6), 10**(r-6))
        idx = np.argmax(dP(minlz, lambd, bv))
        res = r - 4
        mnbeta = bv[idx]
        mxbeta = lambd
    elif name == 'Hell':
        r = np.floor(np.log10(np.abs(-minlz - lambd)))
        res = r - 4
        mnbeta = -minlz - lambd
        mxbeta = lambd
    else:
        raise ValueError('Unknown name')

    val = np.sum(dP(Lz, lambd, mnbeta + 10**res) * Integral)
    while np.isnan(val) or val <= 1 or val == np.inf:
        mxbeta = mnbeta + 10**res
        val = np.sum(dP(Lz, lambd, mnbeta + 10**(res-1)) * Integral)
        if val == np.inf:
            res += 0.6
        elif res < -1000:
            mnbeta = mnbeta / 10
        else:
            res -= 1
        if res == -np.inf:
            raise RuntimeError('Error finding beta')
    val = np.sum(dP(Lz, lambd, mxbeta) * Integral)
    while val > 1:
        mxbeta = mnbeta + 10**r
        val = np.sum(dP(Lz, lambd, mxbeta) * Integral)
        if mxbeta > 1000:
            raise RuntimeError('Error finding beta')

    iter_count = 1
    lgm = np.linspace(mnbeta, mxbeta, n)
    tt = np.zeros_like(lgm)
    for _ in range(1000000):
        for i in range(len(lgm)):
            tt[i] = np.sum(dP(Lz, lambd, lgm[i]) * Integral)
        idx = np.argmin(np.abs(tt - 1))
        if idx == 0 and tt[0] < 1 or idx == n-1 and tt[-1] > 1:
            raise RuntimeError('Error finding beta')
        if idx == 0:
            idx = 1
        elif idx == n-1:
            idx = n-2
        mxbeta = lgm[idx+1]
        mnbeta = lgm[idx-1]
        ibeta = tt[idx]
        if abs(1 - ibeta) <= 1e-5:
            break
        lgm = np.linspace(mnbeta, mxbeta, n)
    beta = lgm[idx]
    check = np.min(dP(Lz, lambd, beta) * (~supp))
    if iter_count > 1000000 or check < 0:
        raise RuntimeError('Error finding beta loop')
    return beta
