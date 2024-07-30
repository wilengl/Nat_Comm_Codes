function jump_histogram(bin, dr, N, color)

for j = 1:length(N)
    patch(bin(j)+[0 dr dr 0], [0 0 N(j) N(j)], color, 'edgecolor', 'none', 'facealpha', .2)
end