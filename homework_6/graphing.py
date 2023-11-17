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

def graph_magnetizations(steps: list[int], magnetizations: list[float], errors: list[float]):
    # function which produces the graph for magnetization

    plt.plot(steps, magnetizations)
    plt.errorbar(steps, magnetizations, errors)
    plt.show()

steps, magnetizations, errors = get_steps_avergaes_errors("graphing.dat")
graph_magnetizations(steps, magnetizations, errors)