include("IO_functions.jl")
include("math_functions.jl")

# setting the name for input and output files
filename_read = "read.in"
filenmae_write_magnetizations = "res.dat"

# reading input from the file
L, T, bins, reps, steps = read_input(filename_read)

# сhecking if the number of steps is not zero (first part)
if steps == zero

    # 2D vector for storing magnetizations for different runs,
    # where i-th row represents magnetizations on the n-th step
    magnetization_runs::Vector{Vector{Float64}} = [[] for _ in 1:bins]

    # calculating the size of one bin
    bin_size = ceil(UInt64, steps / bins)

    # running the simulation reps number of times
    for _ in 1:reps

        # initial state
        state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

        # storing magnetizations of the bin
        bin_vals::Vector{Float64} = []
        bin_num = 1

        # conducting steps for Monte Carlo simulation
        for step in 1:steps

            # creating new state
            state_new::Vector{Vector{Int64}} = [[0 for _ in 1:L] for _ in 1:L]

            # applying Monte Carlo algorithm
            ...
            
            # adding new magnetization to the bin
            push!(bin_vals, get_magnetization(state_new))

            # checking if the bin is full
            if length(bin_vals) == bin_size

                # recording new magnetization
                push!(magnetization_runs[bin_num], mean(bin_vals))
                bin_num += 1
                bin_vals = []
            end

            # updating current state
            state = state_new
        end

        # if the number of steps was not divisible by number of bins
        # adding the remaining bin_value
        if length(bin_vals) != 0

            # recording new magnetization
            push!(magnetization_runs[bin_num], mean(bin_vals))
        end

    end

    # creatring a vector of average magnetizations on each step
    average_magnetizations::Vector{Float64} = [mean(magnetization_runs[i]) for i in 1:length(magnetization_runs)]

    # recording average magnetizations

# otherwise, 0 steps (second part)
else