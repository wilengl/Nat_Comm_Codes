function Density = binding_density(file, ResTime, px)

r = imread(file);
A = length(find(r>0))*px^2; 
Density = length(ResTime)/A;