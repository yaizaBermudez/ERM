import numpy as np

def shuffle(A, y):
    """Shuffle columns of A and corresponding labels y."""
    cols = A.shape[1]
    P = np.random.permutation(cols)
    return A[:, P], y[:, P]
