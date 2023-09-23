function graph_walks(walks::Array{Array{Int64, 1}, 1})
    for i in 1:64
        display(plot(0:100, walks[i]))
    end
end