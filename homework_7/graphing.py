from matplotlib import pyplot as plt
    
def parse_results(filename: str, total_time: int) -> tuple[list[float], list[float], list[float]]:
    """ function which parses the ferro.jl output """
    f = open(filename)
    times, Ps, Es = [], [], []
    for line in f:
        vals = [float(val) for val in line.split("  ")]
        times.append(vals[0] * total_time)
        Ps.append(vals[1])
        Es.append(vals[2])
    return times, Ps, Es

def graph_Ps(folder_path: str, num_steps: list[int], total_time: int, title: str):
    """ graphs Ps vals on one graph"""

    # iterating over time steps
    for step_num in num_steps:

        # getting the values
        times, Ps, _ = parse_results(folder_path + "/" + "s_" + str(step_num) + ".dat", total_time)

        # calculating dt
        dt = 1 / step_num

        plt.plot(times, Ps, "--", label = "dt = " + str(dt) + " s")

    plt.xlabel("time, s")
    plt.ylabel("Success Rate")
    plt.title(title)
    plt.grid()
    plt.legend()
    plt.show()

def graph_Pe(folder_path: str, num_steps: list[int], total_time: int, title: str):
    """ graphs Pe vals on one graph"""

    # iterating over time steps
    for step_num in num_steps:

        # getting the values
        times, _, Pe = parse_results(folder_path + "/" + "s_" + str(step_num) + ".dat", total_time)

        # calculating dt
        dt = 1 / step_num

        plt.plot(times, Pe, "--", label = "dt = " + str(dt) + " s")

    plt.xlabel("time, s")
    plt.ylabel("Excess Energy")
    plt.title(title)
    plt.grid()
    plt.legend()
    plt.show()

graph_Ps("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 10, title = "Success Rate VS Time for T = 10")
graph_Pe("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 10, title = "Excess Energy VS Time for T = 10")

graph_Ps("./data_100", [10, 20, 25, 50, 100, 1000, 10000], total_time = 100, title = "Success Rate VS Time for T = 100")
graph_Pe("./data_10", [10, 20, 25, 50, 100, 1000, 10000], total_time = 100, title = "Excess Energy VS Time for T = 100")

