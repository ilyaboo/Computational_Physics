include("math_functions.jl")
include("IO_functions.jl")

x_N, N_0, n_max = read_input()
conduct_series_integration(n_max, N_0, x_N, 1.0, 0.5, 1)