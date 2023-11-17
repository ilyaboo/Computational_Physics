include("IO_functions.jl")
include("math_functions.jl")

using Statistics
using Random

# setting the name for input and output files
filename_read = "read.in"
filenmae_write_bin_averages = "res.dat"
filenmae_write_graphing_data = "graphing.dat"

# resetting output files if they exist
tmp = open(filenmae_write_bin_averages, "w")
close(tmp)
tmp = open(filenmae_write_graphing_data, "w")
close(tmp)

# reading input from the file
L, T, bins, reps, steps = read_input(filename_read)

# calculating the size of one bin
bin_size = ceil(UInt64, reps / bins)

# сhecking if the number of steps is not zero (first part)
if steps != 0

    # storing averages of bins for all steps
    bins_averages::Vector{Vector{Float64}} = [[] for _ in 1:steps]

    # 2D vector for storing magnetizations for different reps,
    # where i-th row represents magnetizations on the n-th step
    # until reaches full capacity of bin_size
    local magnetizations_bin::Vector{Vector{Float64}} = [[] for _ in 1:steps]

    # running the simulation reps number of times
    for _ in 1:reps

        # initial state
        state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

        # keeping track of total magnetization
        M::Int64 = L^2

        # conducting steps for Monte Carlo simulation
        for step in 1:steps

            # applying Monte Carlo algorithm
            M = conduct_Monte_Carlo(state, M)

            # adding new magnetization to the bin
            push!(magnetizations_bin[step], M / L^2)
        end

        # checking if the bin is full
        if length(magnetizations_bin[1]) == bin_size

            # iterating over time steps
            for step in 1:steps

                # calculatin the average for the timestep
                avg_val = mean(magnetizations_bin[step])

                # adding the averages of the bin for each step
                push!(bins_averages[step], avg_val)
            end

            # writing bin averages to a file
            write_bin_averages(bins_averages, filenmae_write_bin_averages)

            # resetting the bin
            magnetizations_bin = [[] for _ in 1:steps]
        end
    end

    # if number of reps is not divisible by the number of bins,
    # add the accumulated results for the last bin
    if length(magnetizations_bin[1]) != 0

        # iterating over time steps
        for step in 1:steps

            # calculatin the average for the timestep
            avg_val = mean(magnetizations_bin[step])

            # adding the averages of the bin for each step
            push!(bins_averages[step], avg_val)
        end

        # writing bin averages to a file
        write_bin_averages(bins_averages, filenmae_write_bin_averages)
    end
    
    # calculating averages among bins for each timestep
    # and corresponding errors
    steps_averages, steps_errors = bins_average_and_error(bins_averages)

    # recording steps_averages and steps_errors for future graphing
    write_steps_averages_and_errors(steps_averages, steps_errors, filenmae_write_graphing_data)

# otherwise, 0 steps (second part)
else

    # sotring bin averages
    bin_averages::Vector{Float64} = []

    # sotring times of current bin
    local bin_times::Vector{Float64} = []

    # running the simulation
    for _ in 1:reps

        # initial state
        state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

        # keeping track of total magnetization
        M::Int64 = L^2

        # repeating Monte Carlo algorithm until reach M = 0
        step_number::UInt64 = 1
        while true

            # condcuting Monte Carlo algorithm
            M, MC_step = conduct_Monte_Carlo_2(state, M)

            # checking if obtained zero magnetization
            if MC_step != -1

                # adding the result to bin_times
                push!(bin_times, step_number - 1 + MC_step / L^2)

                break
            end
            
            # incrementing step number
            step_number += 1
        end

        # checking if filled the bin
        if length(bin_times) == bin_size

            avg_time = mean(bin_times)

            # adding the average
            push!(bin_averages, avg_time)

            # writing the average to the file
            write_time(avg_time, filenmae_write_bin_averages)
            
            # resetting bin times
            bin_times = []
        end
    end

    # checkign is something left in the last bin
    if length(bin_times) != 0

        # adding the average
        push!(bin_averages, mean(bin_times))

        # writing the average to the file
        write_time(mean(bin_times), filenmae_write_bin_averages)
    end
end