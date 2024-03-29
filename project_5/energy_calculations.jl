include("math_functions.jl")
include("constants.jl")
include("IO_functions.jl")

# for part a
function energies_a()

    # resetting the file if it was created
    f = open("energies_a.dat", "w")
    close(f)

    for i in 2:1:40

        # setting up the basis parameters
        N_x, N_y = UInt64(i), UInt64(i)

        # constructing the Hamiltonian, obtaining eigenvalues and eigenvectors
        Hamiltonian = construct_hamiltonian(N_x, N_y)
        eigenvalues, _ = eigen(Hamiltonian)

        # obtaining 4 lowest eigenvalues
        sorted_eigenvalues = sort!(eigenvalues)[1 : 4]
        sorted_eigenvalues = sorted_eigenvalues ./ β

        write_energies(sorted_eigenvalues, "energies_a.dat")
    end
end

# part b
function energies_b()

    # resetting the file if it was created
    f = open("energies_b.dat", "w")
    close(f)

    for i in [0.2, 0.1, 0.05, 0.025]
        Δ = i

        N_x = UInt64(Lx / Δ)
        N_y = UInt64(Lx / Δ)

        # constructing Hamiltonian
        H_matrix = construct_hamiltonian(N_x, N_y)

        # defining the Hamiltonian function for the Lanczos algorithm
        H = (psi) -> H_matrix * psi

        # creating initial state for the Lanczos iteration
        initial_state = rand(Float64, N_x * N_y)

        # iterating over numbers of steps
        for j in 20:10:500

            num_steps = UInt64(j)

            # using Lanczos iteration
            eigenvalues, _ = lanczos_iteration(H, initial_state, num_steps)

            # obtaining 4 lowest eigenvalues
            sorted_eigenvalues = sort!(eigenvalues)[1 : 4]
            sorted_eigenvalues = sorted_eigenvalues ./ β

            write_energies(sorted_eigenvalues, "energies_b.dat")
        end
    end
end

energies_a()
energies_b()