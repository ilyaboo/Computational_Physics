include("IO_functions.jl")
include("math_functions.jl")
include("constants.jl")

alpha, Nt, tmax, Nw = read_user_input()
run_simulation(alpha, Nt, tmax, Nw)