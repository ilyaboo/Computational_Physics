function f(x::Int64, epsilon::UInt64, alpha::UInt64)::Float64
    # function that is used in the assignment
    return 1 / (epsilon + x)^alpha
end

function discretization_step(x_N::UInt64, N::UInt64)::Float64
    # helper function that returns the discretization step
    # calculating it from upper bound and number of steps
    # (assuming lower bound is zero)
    return x_N / N
end

#function first_order_integration(x_N::UInt64, epsilon::UInt64, alpha::UInt64)