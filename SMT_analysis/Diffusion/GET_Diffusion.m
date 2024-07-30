clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\fast_tracking\';

global dr ds dt

px = .16;        %%%   pixel size (in micron)
dt = .0055;      %%%   exposure time (s)
dr = .005;       %%%   distance for binning (in micron)
ds = .010;       %%%   localizaion uncertainty (in micron)
dmax = 4;        %%%   max. distance for the histogram (px)


p.start = [.05 .3 1 .4 .4]; 
p.LB = [.001 .01 .1 0 0]; 
p.UB = [.5 4 20 1 1];       

X = [];
n = list_file(path0, '_traj.mat');
[Nx, Ny] = NxNy(n);

f = figure(1);
set(f, 'position', [300 530-190*Ny/2 300*Nx Ny*190+20], 'color', 'w');   

for i = 1:n       
    
    load([path0 'cell_' num2str(i) '_traj.mat']);
    jump = jump_distribution(T);
    x0 = mod(i-1,Nx);
    y0 = floor((i-1)/Nx);        
    ax = axes('units', 'pixels', 'position', [55+x0*290 30+(Ny-1-y0)*185 250 175]);
    P = model_3_states(jump, dmax, p, px, i);
    X = [X; [i P]];    
    
end

exportgraphics(f, [path0 'Diffusion.png'])
save([path0 'Diffusion.mat'], 'X')
    




