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
function which writes eigenvalues to the file
    given the array of eigenvalues `eigenvalues`
"""
function write_eigenvalues(eigenvalues::Array{Float64, 1}, filename::String)
    
    f = open(filename, "w")

    # iterating over eigenvalues
    for value in eigenvalues
        println(f, value)
    end

    close(f)
end

"""
function whcih writes the wave function `wave_function` to
    the file named `filename`
"""
function write_wave_function_to_file(wave_function::Array{Float64, 2}, filename::String)

    f = open(filename, "w")

    # iterating over wave function values
    for j in 1:size(wave_function, 2)
        for i in 1:size(wave_function, 1)
            print(f, "$(wave_function[i, j]) ")
        end

        print(f, "\n")
    end

    close(f)
end

"""
function which writes the energy values stored in
    `energies` to the corresponding file `filename`
"""
function write_energies(energies::Array{Float64, 1}, filename::String)

    f = open(filename, "a")

    for E in energies
        print(f, E, " ")
    end

    print(f, "\n")
    close(f)
end