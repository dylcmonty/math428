# Spring 2026 3450:428/528-001 Applied Numerical Methods II
> 3 credits Instructor: Dr. *Lingxing Yao Office CAS 256 E-mail lyao@uakron.edu*
> Prerequisites: MATH 335 and MATH 427 with grades of C- or better or permission.
> Numerical methods in the solution of ordinary and partial differential equations.
> Numerical differentiation, Runge-Kutta methods, and iterative methods for ODEs, finite differences for PDEs. (Formerly 3450:428)

- Section 01: 12:15 -1:30PM, TTh Meeting CAS 138 
- Office Hours (tentative) TTh1:35PM-2:30PM, W10:00AM-10:50AM. If you cannot make the posted office hours, you are encouraged to make appointments with me at other time with email requests. 

## Learning Outcomes: students are expected to be able to 
• Understand some important basic numerical methods, and know how to implement these methods with programming language like MATLAB 
• Understand finite difference method and error analysis 
• Construct numerical solutions to ODE problems, and understand the stability issues in the numerical methods 
• Numerically solve PDE problems, including basic elliptic, parabolic, and hyperbolic PDEs ## Topics to be covered 
  1. Numerical Differentiation (1-2 week(s)) 
    (a) O(hp) notation 
    (b) Taylor series approximation 
    (c) Foward, backward, and central difference 
  2. Numerical solutions to ODEs (7-8 weeks) 
    (a) Single step method 
    (b) Runge-Kutta method 
    (c) Multiple step method 
    (d) Boundary value problems 
    (e) Stability analysis of numerical methods 
  3. Numerical solutions to PDEs (6 weeks) 
    (a) Introduction 
      i. 3 standard PDEs: elliptic, parabolic, and hyperbolic 
      ii. Boundary and initial value problems 
      iii. discretization of PDEs 
    (b) Elliptic equations 
      i. discretization of Laplacian operator 
      ii. Boundary conditions 
      iii. 2D Poisson equation 
    (c) Parabolic equations 
      i. Explicit in time method 
      ii. implicit methods: Backward Euler; Crank-Nicolson; BDF (maybe) 
    (d) Hyperbolic equations 
      i. advection equation 
      ii. wave equation
      iii. conservation laws (tentative) 

## Textbook
There is no required textbook. We list several good ones as references: 1) Numerical Methods Using MATLAB, 4th edition, Mathews and Fink; 2) Finite Difference Methods for Ordinary and Partial Differential Equations Steady State and Time Dependent Problems, Randall J. LeVeque; 3) Numerical Com puting with MATLAB, Cleve Moler (free online https://www.mathworks.com/moler/chapters.html) 

## Matlab resources 
* `https://www.evamariakiss.de/tutorial/matlab/`
* `https://www.mathworks.com/help/matlab/getting-started-with-matlab.html`
* `https://ocw.mit.edu/courses/2-086-numerical-computation-for-mechanical-engineers-fall-2014/pages/matlab tutorials/`


---

## Layout

```markdown
math428/
  main.py
  scripts/
    hw01_p02.py
    hw01_p03.py
    hw01_p04.py
  figures/
    hw01_p02_error.png
    hw01_p03_error.png
    hw01_p04_error.png
  materials/
    notes/
    example-code/
    handouts/
    homework/
```

## Repository Structure Note

Example code and reference implementations provided by the instructor can be found in:

- `materials/handouts/` (example MATLAB scripts and reference code)
- `materials/notes/` (lecture notes)
- `materials/homework/` (assigned homework problems)

These materials are provided for reference and context alongside the Python implementations developed in this repository.

## How main.py should behave (dispatcher, not logic)
> See `main.py`

## Script naming + a dispatcher
* One script = one numerical experiment
* Scripts are not libraries, they are executable artifacts
* The grader expects to open a file and see everything relevant for that problem

**Each script:**
  Implements one method/problem
  Produces its own plots
  Prints its own summary / error metrics
  Can be run standalone or via main.py
This mirrors MATLAB’s “run this .m file” workflow almost exactly.

*Each script must expose `def main(save=True):`*

## This gives you:
One terminal entry point
Reproducible figure generation
No ambiguity for grading

### You do not want:

CLI frameworks
config files
dependency injection
class hierarchies

main.py should not contain numerical methods.
Its only job is to select and run scripts.
