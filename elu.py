import numpy as np

def elu(x):
    """Exponential linear unit activation.

    Parameters
    ----------
    x : array_like
        Input array.

    Returns
    -------
    ndarray
        Elementwise ELU activation where negative values are scaled by 0.2.
    """
    x = np.asarray(x)
    return np.where(x >= 0, x, 0.2 * (np.exp(x) - 1))
