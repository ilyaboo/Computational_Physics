function graph_walks(walks::Vector{Vector{Int64}})
    for i in 1:64
        display(plot(0:100, walks[i]))
    end
end