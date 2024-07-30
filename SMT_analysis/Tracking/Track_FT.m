clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\fast_tracking\';

p.mem = 2;      %%%   max. number of lost frames
p.dmax = 4;     %%%   max. distance to connect dots between 2 consecutive frames (in px)
p.Nmin = 3;     %%%   min. number of jumps


for u = 1:10

    disp(['cell_' num2str(u)]);
    
    load([path0 '-\cell_' num2str(u) '.mat']) 
    r = imread([path0 '-\cell_' num2str(u) '_roi.tif']); 
    T = fct_tracking(X, p, r);
    
    save([path0 'cell_'  num2str(u) '_traj.mat'], 'T')    

end

