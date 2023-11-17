include("IO_functions.jl")
include("math_functions.jl")

# setting the name for input and output files
filename_read = "read.in"
filenmae_write_magnetizations = "res.dat"

# reading input from the file
L, T, bins, reps, steps = read_input(filename_read)

# сhecking if the number of steps is not zero (first part)
if steps == zero

    # storing averages of bins for all steps
    bins_averages::Vector{Vector{Float64}} = [[] for _ in 1:steps]

    # calculating the size of one bin
    bin_size = ceil(UInt64, reps / bins)

    # 2D vector for storing magnetizations for different reps,
    # where i-th row represents magnetizations on the n-th step
    # until reaches full capacity of bin_size
    magnetizations_bin::Vector{Vector{Float64}} = [[] for _ in 1:steps]

    # running the simulation reps number of times
    for _ in 1:reps

        # initial state
        state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

        # conducting steps for Monte Carlo simulation
        for step in 1:steps

            # creating new state
            state_new::Vector{Vector{Int64}} = [[0 for _ in 1:L] for _ in 1:L]

            # applying Monte Carlo algorithm
            ...
            
            # adding new magnetization to the bin
            push!(magnetizations_bin[step], get_magnetization(state_new))

            # updating current state
            state = state_new
        end

        # checking if the bin is full
        if length(magnetizations_bin[1]) == bin_size

            # iterating over time steps
            for step in 1:steps

                # adding the averages of the bin for each step
                push!(bins_averages[step], mean(magnetizations_bin[step]))
            end

            # resetting the bin
            magnetizations_bin = []
        end
    end

    # if number of reps is not divisible by the number of bins,
    # add the accumulated results for the last bin
    if length(magnetizations_bin[1]) != 0

        # iterating over time steps
        for step in 1:steps

            # adding the averages of the bin for each step
            push!(bins_averages[step], mean(magnetizations_bin[step]))
        end
    end
    
    # calculating averages among bins for each timestep
    # and corresponding errors
    steps_averages, steps_errors = bins_average_and_error(bins_averages)

# otherwise, 0 steps (second part)
else