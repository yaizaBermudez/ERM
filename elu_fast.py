import numpy as np

def elu_fast(x):
    """Vectorised exponential linear unit activation."""
    x = np.asarray(x)
    result = np.zeros_like(x)
    mask = x >= 0
    result[mask] = x[mask]
    result[~mask] = 0.2 * (np.exp(x[~mask]) - 1)
    return result
