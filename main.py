from problems import nd1_compare_error_fd_bd_cd, ode1_euler

def main():
    # Run each problem (and save their figures)
    nd1_compare_error_fd_bd_cd.main(save=True)
    ode1_euler.main(save=True)

if __name__ == "__main__":
    main()
