include("math_functions.jl")

function read_input()::Tuple{UInt64, UInt64, UInt64}
    # function that reads the the number of walks,
    # number of steps per walk and the seed from the
    # read.in file
    # Output: number of walks, number of steps, seed 
    # as integers

    # opening the file
    f = open("read.in", "r")
    
    # reading the 3 lines from the file
    line_1 = readline(f)
    line_2 = readline(f)
    line_3 = readline(f)

    # converting the lines to integers
    num_walks = parse(UInt64, line_1)
    num_steps = parse(UInt64, line_2)
    seed = parse(UInt64, line_3)

    # closing the file
    close(f)

    return num_walks, num_steps, seed
end

function write_deviations(deviations::Vector{Float64}, num_walks::UInt64)
    # function that writes the deviations into the file d.dat
    # Input: deviations – deviations vector
    #        num_walks – number of walks conducted

    f = open("d.dat", "w")

    for i in 1:64
        println(f, i, " ", deviations[i] * num_walks^0.5)
    end

    close(f)
end

function write_distributions(bit_freqs::Vector{Vector{UInt64}}, num_walks::UInt64, num_steps::UInt64)
    # function that writes the full distributions into the files
    # Input: bit_freqs – results for bits after performing walks
    #        num_walks – number of walks conducted
    #        num_steps – number of steps in each walk

    # iterating over bits
    for b in 1:64

        # generating the name of the file
        if b < 10
            filename = "p0" * string(b) * ".dat"
        else
            filename = "p" * string(b) * ".dat"
        end

        f = open(filename, "w")

        # recording metrics for each value
        for index in 1:length(bit_freqs[1])
            println(f, bit_freqs[b][index],
                    " ",
                    Float64(bit_freqs[b][index]) / num_walks,
                    " ",
                    probability_bit_value(num_steps, index - Int64(num_steps) - 1))
        end
        
        close(f)
    end
end