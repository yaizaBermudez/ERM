import numpy as np

def elup(x):
    """Derivative of the ELU activation."""
    x = np.asarray(x)
    return np.where(x >= 0, 1.0, 0.2 * np.exp(x))
