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