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

    if include_errors:
        plt.errorbar(steps, magnetizations, yerr = errors)
    else:
        plt.plot(steps, magnetizations)

    # setting y-axis to logarithmic scale
    plt.yscale('log')

    # labels
    plt.xlabel("Steps")
    plt.ylabel("Logarithm of Average Magnetization")
    plt.title("Log of Average Magnetization vs. Steps (Lin-Log Scale)")
    plt.grid(True)
    plt.show()

steps, magnetizations, errors = get_steps_avergaes_errors("graphing.dat")
graph_magnetizations_lin(steps, magnetizations, errors, False)