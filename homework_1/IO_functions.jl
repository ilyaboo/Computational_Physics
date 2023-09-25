function read_input()::Tuple{UInt64, UInt64}
    # function that reads the the number of walks
    # and number of steps per walk from the
    # read.in file
    # Output: number of walks, number of steps as 
    # integers

    # opening the file
    f = open("read.in", "r")
    
    # reading the 2 lines from the file
    line_1 = readline(f)
    line_2 = readline(f)

    # converting the lines to integers
    num_walks = parse(UInt64, line_1)
    num_steps = parse(UInt64, line_2)

    # closing the file
    close(f)

    return num_walks, num_steps
end