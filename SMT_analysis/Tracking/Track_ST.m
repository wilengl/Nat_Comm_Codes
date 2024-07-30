clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\slow_tracking\';

p.mem = 2;          %%%   max. number of lost frames
p.dmax = 1.75;      %%%   max. distance to connect dots between 2 consecutive frames (px)
p.Nmin = 2;         %%%   min. number of jumps

b.Jmin = 4;         %%%   min. number of jumps in the binding trajectory
b.px = 160;         %%%   pixel size (nm)
b.diameter = 100;   %%%   max. diameter of the circle that circumscribes the binding trajectory (nm) 


for u = 1:8
    
    disp(['cell_' num2str(u)]);

    load([path0 '-\cell_' num2str(u) '.mat']) 
    r = imread([path0 '-\cell_' num2str(u) '_roi.tif']); 
    T = fct_tracking(X, p, r);

    save([path0 'cell_'  num2str(u) '_traj.mat'], 'T');  

    [A, B] = Trim_Trajectories(T, b);
    T = A;
    save([path0 'cell_'  num2str(u) '_bind.mat'], 'T');  
    T = B;
    save([path0 'cell_'  num2str(u) '_diff.mat'], 'T');  

end



