include("IO_functions.jl")
include("math_functions.jl")

# reading input from the file
L, T, bins, reps, steps = read_input()

# 2D vector for storing magnetizations for different returns
magnetization_runs::Vector{Vector{Float64}} = []

# running the simulation reps number of times
for _ in 1:reps

    # storing magnetization values
    magnetization_vals::Vector{Float64} = []

    # initial state
    state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

    # adding initial magnetization
    push!(magnetization_vals, get_magnetization(state))

    # conducting steps for Monte Carlo simulation
    for _ in 1:steps

        # creating new state
        state_new::Vector{Vector{Int64}} = [[0 for _ in 1:L] for _ in 1:L]

        # applying Monte Carlo algorithm
        ...
        
        # recording new magnetization
        push!(magnetization_vals, get_magnetization(state_new))

        # updating current state
        state = state_new
    end

    # adding current run to magnetization_runs
    push!(magnetization_runs, magnetization_vals)
end

# saving magnetization runs to the file
...