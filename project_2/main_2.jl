include("IO_functions.jl")

r1, r2, rho1, rho2, npt, nbi = read_input_2()

run_monte_carlo_integration(r1, r2, rho1, rho2, npt, nbi)