
clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\slow_tracking\';

Jmin = 4;    %%%   min. number of jumps in the binding trajectory
dt = .3;     %%%   exposure time (s)


E = 0.005;
tmax = 20;
th = 1E-3;

ti = (Jmin*dt:dt:50);
ki = 1./ti;

ResTime = [];
n = list_file(path0, 'bind.mat');

for i = 1:n
    load([path0 'cell_' num2str(i) '_bind']);     
    ResTime = [ResTime resTime_distribution(T, Jmin)];      
end

[frame, prob] = survivalProb_curve(ResTime, Jmin);   
t = dt*frame; 

Si = GRID_spectrum(t', prob', ki, E, dt);
% [F, T] = GRID_bar(ti, Si, th);

f = figure(1);
set(f, 'position', [200 200 500 400], 'color', 'w');
a = area(ti, Si, 'FaceColor', [.3 .3 .3]);
ylim([th .8])
xlim([0 tmax])
set(gca, 'yscale', 'log', 'fontsize', 14)




