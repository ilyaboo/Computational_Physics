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

    for deviation in deviations
        println(f, deviation * num_walks^0.5)
    end
end