"""
hw01_p02.py

Numerical differentiation of f(x) = ln(x^2 + 1) at x = 1.3
using forward difference and central difference methods.

Step sizes:
    h = 0.01
    h = 0.001

The script prints:
- numerical derivative approximations
- absolute errors compared to the exact derivative

At least 6 digits after the decimal are shown, per assignment requirements.
"""

import numpy as np


def f(x):
    """
    Function definition:
        f(x) = ln(x^2 + 1)
    """
    return np.log(x**2 + 1.0)


def exact_derivative(x):
    """
    Exact derivative of f(x) = ln(x^2 + 1):

        f'(x) = (2x) / (x^2 + 1)
    """
    return (2.0 * x) / (x**2 + 1.0)


def forward_difference(f, x, h):
    """
    Forward difference approximation:

        f'(x) ≈ [f(x + h) - f(x)] / h
    """
    return (f(x + h) - f(x)) / h


def central_difference(f, x, h):
    """
    Central difference approximation:

        f'(x) ≈ [f(x + h) - f(x - h)] / (2h)
    """
    return (f(x + h) - f(x - h)) / (2.0 * h)


def solve():
    """
    Computes numerical derivatives and errors for the specified h values.

    Returns:
        dict containing exact derivative, approximations, and errors
    """
    x = 1.3
    h_values = [0.01, 0.001]

    exact = exact_derivative(x)

    results = {
        "x": x,
        "exact_derivative": exact,
        "approximations": {}
    }

    for h in h_values:
        fd = forward_difference(f, x, h)
        cd = central_difference(f, x, h)

        results["approximations"][h] = {
            "forward": fd,
            "central": cd,
            "forward_error": abs(fd - exact),
            "central_error": abs(cd - exact),
        }

    return results


def make_figure(results, save_path=None):
    """
    No figures are required for this problem.
    This function is included to satisfy repository conventions.
    """
    return None


def main(save=True):
    """
    Main execution:
    - calls solve()
    - prints numerical results with at least 6 decimal places
    """
    results = solve()

    x = results["x"]
    exact = results["exact_derivative"]

    print(f"x = {x:.6f}")
    print(f"Exact derivative = {exact:.6f}\n")

    for h, data in results["approximations"].items():
        print(f"h = {h}")
        print(f"  Forward Difference  = {data['forward']:.6f}")
        print(f"  Forward Error       = {data['forward_error']:.6e}")
        print(f"  Central Difference  = {data['central']:.6f}")
        print(f"  Central Error       = {data['central_error']:.6e}")
        print()


if __name__ == "__main__":
    main(save=True)
