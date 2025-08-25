import numpy as np
import scipy.io as sio
from elu import elu

def digit_test():
    test = np.loadtxt('mnist_test.csv', delimiter=',')
    labels = test[:, 0].astype(int)
    images = test[:, 1:785] / 255.0
    images = images.T
    model = sio.loadmat('model5.mat')
    w4, w3, w2 = model['w34'], model['w23'], model['w12']
    b4, b3, b2 = model['b34'], model['b23'], model['b12']
    success = 0
    n = images.shape[1]
    for i in range(n):
        out2 = elu(w2 @ images[:, i:i+1] + b2)
        out3 = elu(w3 @ out2 + b3)
        out = elu(w4 @ out3 + b4)
        num = np.argmax(out)
        if labels[i] == num:
            success += 1
    print('Accuracy:', success / n * 100, '%')

if __name__ == '__main__':
    digit_test()
