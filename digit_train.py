import numpy as np
import scipy.io as sio
from elu import elu
from elup import elup
from shuffle import shuffle

def digit_train():
    data = np.loadtxt('mnist_train.csv', delimiter=',')
    n_samples = 5000
    labels = data[:n_samples, 0].astype(int)
    y = np.zeros((10, n_samples))
    y[labels, np.arange(n_samples)] = 1
    images = data[:n_samples, 1:] / 255.0
    images = images.T

    hn1 = 80
    hn2 = 60
    epochs = 5
    m = 10

    w12 = np.random.randn(hn1, 784) * np.sqrt(2 / 784)
    w23 = np.random.randn(hn2, hn1) * np.sqrt(2 / hn1)
    w34 = np.random.randn(10, hn2) * np.sqrt(2 / hn2)
    b12 = np.random.randn(hn1, 1)
    b23 = np.random.randn(hn2, 1)
    b34 = np.random.randn(10, 1)
    eta = 0.0158

    for k in range(epochs):
        batches = 0
        for _ in range(n_samples // m):
            errortot4 = np.zeros((10, 1))
            errortot3 = np.zeros((hn2, 1))
            errortot2 = np.zeros((hn1, 1))
            grad4 = np.zeros((10, hn2))
            grad3 = np.zeros((hn2, hn1))
            grad2 = np.zeros((hn1, 784))

            for i in range(batches, batches + m):
                a1 = images[:, i:i+1]
                z2 = w12 @ a1 + b12
                a2 = elu(z2)
                z3 = w23 @ a2 + b23
                a3 = elu(z3)
                z4 = w34 @ a3 + b34
                a4 = elu(z4)

                error4 = (a4 - y[:, i:i+1]) * elup(z4)
                error3 = (w34.T @ error4) * elup(z3)
                error2 = (w23.T @ error3) * elup(z2)

                errortot4 += error4
                errortot3 += error3
                errortot2 += error2
                grad4 += error4 @ a3.T
                grad3 += error3 @ a2.T
                grad2 += error2 @ a1.T

            w34 -= eta / m * grad4
            w23 -= eta / m * grad3
            w12 -= eta / m * grad2
            b34 -= eta / m * errortot4
            b23 -= eta / m * errortot3
            b12 -= eta / m * errortot2
            batches += m
        print('Epochs:', k + 1)
        images, y = shuffle(images, y)

    print('Training done!')
    sio.savemat('model5.mat', {'w12': w12, 'w23': w23, 'w34': w34, 'b12': b12, 'b23': b23, 'b34': b34})

if __name__ == '__main__':
    digit_train()
