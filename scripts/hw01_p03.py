"""
hw01_p03.py

Solve the IVP:
    x^3 y' + 20 x^2 y = x,    x ∈ [2, 10],    y(2) = 0

Rewrite to standard form:
    y' = f(x, y) = 1/x^2 - 20 y / x

Methods:
- Forward (explicit) Euler
- Backward (implicit) Euler

Runs (step sizes):
    h = 0.01, 0.001, 0.0001

Exact solution (given in the prompt):
    y(x) = 1/(19 x) - 524288/(19 x^20)

Figures saved to figures/ (dpi=200):
- hw01_p03_solution_<...>.png        (exact + all numerical runs)
- hw01_p03_error_forward_<...>.png   (Forward Euler errors for all h)
- hw01_p03_error_backward_<...>.png  (Backward Euler errors for all h)
- hw01_p03_error_compare_h...png     (Forward vs Backward error for each h)

Printing:
- y(10) approximations and max absolute error for each method/h
- Values printed with >= 6 digits after the decimal (and errors in scientific notation)
"""

from __future__ import annotations

import os
from typing import Dict, Any, List, Tuple

import numpy as np
import matplotlib.pyplot as plt


# ----------------------------
# Problem definition
# ----------------------------

def f(x: float, y: float) -> float:
    """
    RHS of the ODE after rearrangement:

        x^3 y' + 20 x^2 y = x
        => y' = (x - 20 x^2 y) / x^3 = 1/x^2 - 20 y / x
    """
    return 1.0 / (x * x) - 20.0 * y / x


def y_exact(x: np.ndarray) -> np.ndarray:
    """
    Exact solution (given):

        y(x) = 1/(19 x) - 524288/(19 x^20)
    """
    return 1.0 / (19.0 * x) - 524288.0 / (19.0 * (x ** 20))


# ----------------------------
# Numerical methods
# ----------------------------

def forward_euler(x0: float, x1: float, y0: float, h: float) -> Tuple[np.ndarray, np.ndarray]:
    """
    Forward (explicit) Euler on uniform grid.

    Recurrence:
        x_{n+1} = x_n + h
        y_{n+1} = y_n + h * f(x_n, y_n)
    """
    # Number of steps; ensure we end at x1 exactly by construction (here it divides evenly).
    n_steps = int(round((x1 - x0) / h))
    x = x0 + h * np.arange(n_steps + 1, dtype=float)
    y = np.empty_like(x)
    y[0] = y0

    # March forward
    for n in range(n_steps):
        y[n + 1] = y[n] + h * f(x[n], y[n])

    return x, y


def backward_euler(x0: float, x1: float, y0: float, h: float) -> Tuple[np.ndarray, np.ndarray]:
    """
    Backward (implicit) Euler on uniform grid.

    Implicit step:
        y_{n+1} = y_n + h * f(x_{n+1}, y_{n+1})

    Here f(x, y) = 1/x^2 - 20 y / x is linear in y, so we can solve *exactly*
    for y_{n+1} without using a root solver:

        y_{n+1} = y_n + h*(1/x_{n+1}^2 - 20*y_{n+1}/x_{n+1})
        y_{n+1} + (20h/x_{n+1}) y_{n+1} = y_n + h/x_{n+1}^2
        y_{n+1} = (y_n + h/x_{n+1}^2) / (1 + 20h/x_{n+1})
    """
    n_steps = int(round((x1 - x0) / h))
    x = x0 + h * np.arange(n_steps + 1, dtype=float)
    y = np.empty_like(x)
    y[0] = y0

    for n in range(n_steps):
        x_next = x[n + 1]
        numerator = y[n] + h * (1.0 / (x_next * x_next))
        denom = 1.0 + (20.0 * h / x_next)
        y[n + 1] = numerator / denom

    return x, y


# ----------------------------
# Required repository interface
# ----------------------------

def solve(
    x0: float = 2.0,
    x1: float = 10.0,
    y0: float = 0.0,
    hs: List[float] | None = None
) -> Dict[str, Any]:
    """
    Run Forward Euler and Backward Euler for each required h, compute exact solution and errors.

    Returns a dict with:
        results["exact"][h]   -> exact y on that grid
        results["FE"][h]      -> forward euler y
        results["BE"][h]      -> backward euler y
        results["err_FE"][h]  -> |FE - exact|
        results["err_BE"][h]  -> |BE - exact|
        results["x"][h]       -> grid for that h
    """
    if hs is None:
        hs = [0.01, 0.001, 0.0001]

    out: Dict[str, Any] = {
        "x0": x0,
        "x1": x1,
        "y0": y0,
        "hs": list(hs),
        "x": {},
        "exact": {},
        "FE": {},
        "BE": {},
        "err_FE": {},
        "err_BE": {},
    }

    for h in hs:
        # Compute numerical solutions
        x_fe, y_fe = forward_euler(x0, x1, y0, h)
        x_be, y_be = backward_euler(x0, x1, y0, h)

        # Sanity check: grids should match for same (x0,x1,h)
        if not np.allclose(x_fe, x_be):
            raise RuntimeError(f"Grid mismatch between FE and BE for h={h}")

        x = x_fe
        yex = y_exact(x)

        out["x"][h] = x
        out["exact"][h] = yex
        out["FE"][h] = y_fe
        out["BE"][h] = y_be
        out["err_FE"][h] = np.abs(y_fe - yex)
        out["err_BE"][h] = np.abs(y_be - yex)

    return out


def make_figure(results: Dict[str, Any], save_path: str | None = None):
    """
    Create the main "solution comparison" figure:
        exact + Forward Euler (all h) + Backward Euler (all h)

    If save_path is provided, save the figure there (dpi=200).

    Returns the matplotlib Figure.
    """
    hs = results["hs"]

    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)

    # Plot exact and numerical runs. (Exact differs slightly per grid; that's fine.)
    # We'll plot exact for the finest grid so it looks smooth.
    h_fine = min(hs)
    x_fine = results["x"][h_fine]
    ax.plot(x_fine, results["exact"][h_fine], label="Exact")

    for h in hs:
        x = results["x"][h]
        ax.plot(x, results["FE"][h], linestyle="--", label=f"Forward Euler, h={h:g}")
        ax.plot(x, results["BE"][h], linestyle=":", label=f"Backward Euler, h={h:g}")

    ax.set_xlabel("x")
    ax.set_ylabel("y(x)")
    ax.set_title("IVP Solution: Exact vs Forward/Backward Euler (all h)")
    ax.legend()
    ax.grid(True, alpha=0.3)

    fig.tight_layout()

    if save_path is not None:
        fig.savefig(save_path, dpi=200, bbox_inches="tight")

    return fig


# ----------------------------
# Additional figures required by prompt (errors)
# ----------------------------

def _make_error_figures(results: Dict[str, Any]) -> List[Tuple[plt.Figure, str]]:
    """
    Build the error comparison figures required by the prompt:

    i) each method with different h  (2 figures: FE errors, BE errors)
    ii) different method with same h (3 figures: for each h, FE vs BE error)

    Returns a list of (figure, filename_suffix) to be saved by main().
    """
    hs = results["hs"]
    figs: List[Tuple[plt.Figure, str]] = []

    # (i) Forward Euler errors for all h
    fig1 = plt.figure()
    ax1 = fig1.add_subplot(1, 1, 1)
    for h in hs:
        x = results["x"][h]
        ax1.plot(x, results["err_FE"][h], label=f"h={h:g}")
    ax1.set_xlabel("x")
    ax1.set_ylabel("absolute error |y_num - y_exact|")
    ax1.set_title("Forward Euler: Absolute Error vs x (all h)")
    ax1.legend()
    ax1.grid(True, alpha=0.3)
    fig1.tight_layout()
    figs.append((fig1, "error_forward_all_h"))

    # (i) Backward Euler errors for all h
    fig2 = plt.figure()
    ax2 = fig2.add_subplot(1, 1, 1)
    for h in hs:
        x = results["x"][h]
        ax2.plot(x, results["err_BE"][h], label=f"h={h:g}")
    ax2.set_xlabel("x")
    ax2.set_ylabel("absolute error |y_num - y_exact|")
    ax2.set_title("Backward Euler: Absolute Error vs x (all h)")
    ax2.legend()
    ax2.grid(True, alpha=0.3)
    fig2.tight_layout()
    figs.append((fig2, "error_backward_all_h"))

    # (ii) Compare methods with same h: FE error vs BE error for each h
    for h in hs:
        fig = plt.figure()
        ax = fig.add_subplot(1, 1, 1)
        x = results["x"][h]
        ax.plot(x, results["err_FE"][h], label="Forward Euler error")
        ax.plot(x, results["err_BE"][h], label="Backward Euler error")
        ax.set_xlabel("x")
        ax.set_ylabel("absolute error |y_num - y_exact|")
        ax.set_title(f"Error Comparison (Forward vs Backward Euler), h={h:g}")
        ax.legend()
        ax.grid(True, alpha=0.3)
        fig.tight_layout()
        # Filename-safe h tag
        h_tag = f"{h:.4f}".rstrip("0").rstrip(".").replace(".", "p")
        figs.append((fig, f"error_compare_h{h_tag}"))

    return figs


def main(save: bool = True):
    """
    Runs the computation, prints summary outputs, and saves required figures.

    Figures are saved to:
        figures/hw01_p03_<short_desc>.png
    """
    results = solve()

    # ----------------------------
    # Print required numeric outputs (course-grade summary)
    # ----------------------------
    x1 = results["x1"]
    print(f"IVP on x ∈ [{results['x0']:.6f}, {results['x1']:.6f}], y({results['x0']:.6f}) = {results['y0']:.6f}")
    print("Exact solution: y(x) = 1/(19x) - 524288/(19x^20)")
    print()

    # Print y(10) and max error for each method/h
    for h in results["hs"]:
        x = results["x"][h]
        # last grid point is x1 by construction
        yex_last = results["exact"][h][-1]
        yfe_last = results["FE"][h][-1]
        ybe_last = results["BE"][h][-1]

        max_err_fe = float(np.max(results["err_FE"][h]))
        max_err_be = float(np.max(results["err_BE"][h]))

        print(f"h = {h:g}")
        print(f"  x_end = {x[-1]:.6f} (target {x1:.6f})")
        print(f"  y_exact(x_end) = {yex_last:.6f}")
        print(f"  Forward Euler:  y(x_end) = {yfe_last:.6f},   max|error| = {max_err_fe:.6e}")
        print(f"  Backward Euler: y(x_end) = {ybe_last:.6f},   max|error| = {max_err_be:.6e}")
        print()

    # ----------------------------
    # Figures
    # ----------------------------
    if save:
        os.makedirs("figures", exist_ok=True)

    # Main solution figure
    solution_path = os.path.join("figures", "hw01_p03_solution_exact_FE_BE.png")
    fig = make_figure(results, save_path=solution_path if save else None)

    # Error figures
    error_figs = _make_error_figures(results)
    for ef, suffix in error_figs:
        out_path = os.path.join("figures", f"hw01_p03_{suffix}.png")
        if save:
            ef.savefig(out_path, dpi=200, bbox_inches="tight")

    # If running interactively, you might want to show plots.
    # For homework scripts, we typically just save; comment-in if desired:
    # plt.show()

    # Close figures to avoid memory growth if scripts are run repeatedly
    plt.close("all")


if __name__ == "__main__":
    main(save=True)
