from matplotlib import pyplot as plt
    
def parse_results(filename: str, total_time: int) -> tuple[list[float], list[float], list[float]]:
    """ function which parses the ferro.jl output """
    f = open(filename, "r")
    times, Ps, Es = [], [], []
    for line in f:
        vals = [float(val) for val in line.split("  ")]
        times.append(vals[0] * total_time)
        Ps.append(vals[1])
        Es.append(vals[2])
    return times, Ps, Es

def parse_results_2(filename: str) -> list[tuple[list[float], list[float], list[float], list[float], list[float]]]:
        """ function which parses the ferro.jl output for part 2 of the assignment """
        f = open(filename, "r")
        results = []
        times, Ps_avgs, Ps_errors, Es_avgs, Es_errors = [], [], [], [], []

        # tracking last time read
        last_time = 0

        for line in f:

            vals = [float(val) for val in line.split("  ")]

            # checking if reached the next bin
            if vals[0] < last_time:

                # recording bin results
                results.append((times, Ps_avgs, Ps_errors, Es_avgs, Es_errors))

                # resetting results
                times, Ps_avgs, Ps_errors, Es_avgs, Es_errors = [], [], [], [], []
            
            last_time = vals[0]

            times.append(vals[0])
            Ps_avgs.append(vals[1])
            Ps_errors.append(vals[2])
            Es_avgs.append(vals[3])
            Es_errors.append(vals[4])
        
        # recording bin results
        results.append((times, Ps_avgs, Ps_errors, Es_avgs, Es_errors))

        return results

def graph_Ps(folder_path: str, num_steps: list[int], total_time: int, title: str):
    """ graphs Ps vals on one graph"""

    # iterating over time steps
    for step_num in num_steps:

        # getting the values
        times, Ps, _ = parse_results(folder_path + "/" + "s_" + str(step_num) + ".dat", total_time)

        # calculating dt
        dt = 1 / step_num

        plt.plot(times, Ps, "--", label = "dt = " + str(dt))

    plt.xlabel("time")
    plt.ylabel("Success Rate")
    plt.title(title)
    plt.grid()
    plt.legend()
    plt.show()

def graph_Es(folder_path: str, num_steps: list[int], total_time: int, title: str):
    """ graphs Es vals on one graph"""

    # iterating over time steps
    for step_num in num_steps:

        # getting the values
        times, _, Es = parse_results(folder_path + "/" + "s_" + str(step_num) + ".dat", total_time)

        # calculating dt
        dt = 1 / step_num

        plt.plot(times, Es, "--", label = "dt = " + str(dt))

    plt.xlabel("time")
    plt.ylabel("Excess Energy")
    plt.title(title)
    plt.grid()
    plt.legend()
    plt.show()

def plot_Ps_Es_errors(data: tuple[list[float], list[float], list[float], list[float], list[float]], N: int, T: int, reps: int):
    """ function which plots Ps vs time and Es vs time grraphs with error bars """

    bin_times, bin_Ps, bin_Ps_errors, bin_Es, bin_Es_errors = data

    # ending of the graph titles
    ending = "for system of size N = " + str(N) + ", velocity of v = " + str(1 / T) + "\nand number of repetitions of reps = " + str(reps)

    # plotting Ps
    plt.errorbar(bin_times, bin_Ps, yerr = bin_Ps_errors, markersize = 3, linestyle = "--", fmt = 'o', ecolor = 'red', capsize = 1)
    plt.xlabel("time, t / T")
    plt.ylabel("Success Rate")
    plt.title("Success Rate VS Time\n" + ending)
    plt.grid()
    plt.tight_layout()
    plt.show()

    # plotting Es
    plt.errorbar(bin_times, bin_Es, yerr = bin_Es_errors, markersize = 3, linestyle = "--", fmt = 'o', ecolor = 'red', capsize = 1)
    plt.xlabel("time, t / T")
    plt.ylabel("Excess Energy")
    plt.title("Escess Energy VS Time\n" + ending)
    plt.grid()
    plt.tight_layout()
    plt.show()



# part 1
graph_Ps("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 10, title = "Success Rate VS Time for T = 10")
graph_Es("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 10, title = "Excess Energy VS Time for T = 10")

graph_Ps("./data_100", [10, 20, 25, 50, 100, 1000, 10000], total_time = 100, title = "Success Rate VS Time for T = 100")
graph_Es("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 100, title = "Excess Energy VS Time for T = 100")
    


# part 2
bins_vals = parse_results_2("res.dat", 10)
bin_vals = bins_vals[0]

plot_Ps_Es_errors(data = bin_vals, N = 8, reps = 2)