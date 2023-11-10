include("math_functions.jl")
include("IO_functions.jl")

N_x = UInt64(10)
N_y = UInt64(10)

# constructing Hamiltonian
H_matrix = construct_hamiltonian(N_x, N_y)

# defining the Hamiltonian function for the Lanczos algorithm
H = (psi) -> H_matrix * psi

# creating initial state for the Lanczos iteration
initial_state = rand(Float64, N_x * N_y)

# setting up the number of Lanczos iterations
num_steps = UInt64(100)

# using Lanczos iteration
eigenvalues, eigenvectors = lanczos_iteration(H, initial_state, num_steps)

# recording eigenvalues
write_eigenvalues(eigenvalues, "eigenvalues_b.dat")

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
    filename = "wave_function_b_$index.dat"
    write_wave_function_to_file(wave_function, filename)
end