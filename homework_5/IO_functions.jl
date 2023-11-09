"""
function that reads `N_x` and `N_y` from the
    console and returns the values
"""
function read_input()::Tuple{UInt64, UInt64}
    print("Enter N_x: ")
    N_x = parse(UInt64, readline())
    print("Enter N_y: ")
    N_y = parse(UInt64, readline())
    return N_x, N_y
end

"""
function whcih writes the wave function `wave_function` to
    the file named `filename`
"""
function write_wave_function_to_file(wave_function::Array{Float64,2}, filename::String)

    f = open(filename, "w")

    # iterating over wave function values
    for i in 1:size(wave_function, 1)
        for j in 1:size(wave_function, 2)
            print(f, "$(wave_function[i, j]) ")
        end

        print(f, "\n")
    end

    close(f)
end