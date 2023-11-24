import numpy as np
from matplotlib import pyplot as plt

def get_steps_avergaes_errors(filename: str):
    # function which reads the graphing data from filename,
    # including step numbers, magnetization avergaes and errors

    # storing the results
    steps, magnetizations, errors = [], [], []

    # parsing the file
    f = open(filename, "r")
    for line in f:

        # obtaining values
        step, val, error = line.split(" ")

        # recording the results
        steps.append(int(step))
        magnetizations.append(float(val))
        errors.append(float(error))

    f.close()
    return steps, magnetizations, errors

def graph_magnetizations_lin(steps: list[int], magnetizations: list[float], errors: list[float], include_errors: bool):
    # function which produces the graph for magnetization using lin-lin scale

    # plotting data
    if include_errors:
        plt.errorbar(steps, magnetizations, errors)
    else:
        plt.plot(steps, magnetizations)

    # labels
    plt.xlabel("Steps")
    plt.ylabel("Average Magnetization")
    plt.title("Average Magnetization vs. Steps (Lin-Lin Scale)")
    plt.grid(True)
    plt.show()

def graph_magnetizations_log(steps: list[int], magnetizations: list[float], errors: list[float], include_errors: bool):
    # function which produces the graph for magnetization using lin-log scale

    # converting magnetizations to log scale for fitting
    log_magnetizations = np.log(magnetizations)

    # performing linear regression
    slope, intercept = np.polyfit(steps, log_magnetizations, 1)
    fit_line = np.polyval([slope, intercept], steps)

    # plotting data
    if include_errors:
        plt.errorbar(steps, magnetizations, yerr = errors)
    else:
        plt.plot(steps, magnetizations)
    
    # plotting best fit line
    plt.plot(steps, np.exp(fit_line), label = f'Fit: y = {np.exp(intercept):.2f} * exp({slope:.2f} * x)')

    # setting y-axis to logarithmic scale
    plt.yscale('log')

    # labels
    plt.xlabel("Steps")
    plt.ylabel("Logarithm of Average Magnetization")
    plt.title("Log of Average Magnetization vs. Steps (Lin-Log Scale)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

def graph_steps(L_vals: list[int], step_vals: list[int], type: int):
    # function which produces the graphs for the average number of steps 
    # needed to reach zero magnetization for different values of L
    # type specifies the type of the scales

    plt.plot(L_vals, step_vals)

    if type == 1:
        plt.xlabel("L values")
        plt.ylabel("Average Number of Steps")
        plt.title("Average Number of Steps vs. L Values (Lin-Lin Scale)")

    elif type == 2:
        plt.yscale('log')

        plt.xlabel("L values")
        plt.ylabel("Logarithm of the Average Number of Steps")
        plt.title("Average Number of Steps vs. L Values (Lin-Log Scale)")

    elif type == 3:
        plt.xscale('log')
        plt.yscale('log')

        plt.xlabel("Logarithm of L values")
        plt.ylabel("Logarithm of the Average Number of Steps")
        plt.title("Average Number of Steps vs. L Values (Log-Log Scale)")

    elif type == 4:
        plt.xscale('log')

        plt.xlabel("Logarithm of L values")
        plt.ylabel("Average Number of Steps")
        plt.title("Average Number of Steps vs. L Values (Log-Lin Scale)")

    else:
        raise Exception("Incorrect type of the graph")
        
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

#steps, magnetizations, errors = get_steps_avergaes_errors("graphing.dat")
#graph_magnetizations_log(steps, magnetizations, errors, True)

#vals_2 = [182, 838, 3262, 12334, 39257]
#vals_21 = [