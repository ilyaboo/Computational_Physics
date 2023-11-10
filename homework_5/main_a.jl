include("math_functions.jl")
include("IO_functions.jl")

# reading N_x and N_y parameters
N_x, N_y = read_input()

# constructing the Hamiltonian, obtaining eigenvalues and eigenvectors
Hamiltonian = construct_hamiltonian(N_x, N_y)
eigenvalues, eigenvectors = eigen(Hamiltonian)
write_eigenvalues(eigenvalues, "eigenvalues_a.dat")

# parameters for eigenfunctions writing
x_grid, y_grid = UInt64(100), UInt64(200)

# obtaining 4 lowest eigenvalue indices
sorted_indices = sortperm(eigenvalues)
lowest_indices = sorted_indices[1 : 4]

# iterating over the four lowest eigenvalues, writing the wavefunctions
for index in lowest_indices

    # extracting the eigenvector for the current eigenvalue
    eigenvector = eigenvectors[:, index]

    # constructing the wave function
    wave_function = construct_wave_function(eigenvector, N_x, N_y, x_grid, y_grid)

    # writing the wave function to a file
    filename = "wave_function_a_$index.dat"
    write_wave_function_to_file(wave_function, filename)
end