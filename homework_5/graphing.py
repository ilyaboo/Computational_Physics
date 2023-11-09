import matplotlib.pyplot as plt
import numpy as np

def plot_prob_density(filepath: str):
    """
    function which plots the 2D plot for probability density
    given the wave function in `filepath`
    """

    # loading the wave function
    function = np.loadtxt(filepath)

    # sqaure elements to get probabilities
    function **= 2

    # defining the plot parameters
    plt.imshow(function, extent = (0, function.shape[1], 0, function.shape[0]), origin = 'lower', cmap = 'viridis')
    plt.colorbar(label = 'Probability Density Scale')
    plt.xlabel('X coordinate')
    plt.ylabel('Y coordinate')
    plt.title('Probability Density Inside a Quantum Dot')
    plt.show()

plot_prob_density("wave_function_a_1.dat")