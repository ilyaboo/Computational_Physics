include("math_functions.jl")
include("IO_functions.jl")

# reading input
x_N, N_0, n_max = read_input()

# f(x) parameters
epsilon::Float64 = 10^-5
alpha::Float64 = 0.5

# scenario (1-4 for porblem scenarios, any other number for quick run)
scenario = 4

# running the integrations
conduct_series_integration(n_max, N_0, x_N, epsilon, alpha, scenario)