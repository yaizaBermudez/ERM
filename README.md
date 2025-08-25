# ERM Python Port

This repository contains Python translations of the core MATLAB scripts used for empirical risk minimization on the MNIST dataset. The code provides training, testing and evaluation utilities that mirror the original MATLAB workflow.

## Requirements
- Python 3.12+
- [NumPy](https://numpy.org/)
- [SciPy](https://scipy.org/)

Install the Python dependencies with:
```bash
pip install numpy scipy
```

## Available Scripts
| File | Purpose |
| --- | --- |
| `digit_train.py` | Train a simple convolution-free network on MNIST and save parameters to `model5.mat`. |
| `digit_test.py`  | Evaluate a trained model on the test split and report accuracy. |
| `ERM_fDR_CNN.py` | Compute empirical risks for convex combinations of pre-trained models. |
| `MatrixInterpolation.py` | Interpolate between model weight matrices. |
| `findbetaf.py` | Search for the beta parameter that minimizes risk. |
| `elu.py`, `elu_fast.py`, `elup.py` | Variants of the ELU activation function. |
| `shuffle.py` | Utility to shuffle paired datasets. |

## Data
The repository provides the MNIST dataset in CSV form:
- `mnist_train.csv`
- `mnist_test.csv`

If these files are missing, you can download compatible versions from sources such as [Kaggle](https://www.kaggle.com/oddrationale/mnist-in-csv) and place them in the repository root.

Pre-trained models used by `ERM_fDR_CNN.py` are stored in the `Models/` directory.

## Usage
Train a model:
```bash
python digit_train.py
```

Test a saved model:
```bash
python digit_test.py
```

Run the ERM evaluation:
```bash
python ERM_fDR_CNN.py
```

The ERM script requires the training and test CSV files as well as the `.mat` model files present in `Models/`.

## License
See `license.txt` for licensing information.
