clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\slow_tracking\';

Nexp = 3;    %%%   number of binding modes

dt = .3;     %%%   exposure time (s)
Jmin = 4;    %%%   min. number of jumps in the binding trajectory
px = .16;    %%%   pixel size (micron)

tmax = 150;  %%%   max. time to display the survival probability
ym = 1E-4;   %%%   min. value of the survival probability to display


[fun, p0] = binding_ExpFit(Nexp);

X = [];
n = list_file(path0, 'bind.mat');
[Nx, Ny] = NxNy(n);

f = figure(1);
set(f, 'position', [200 500-180*Ny/2 300*Nx Ny*190+20], 'color', 'w');

for i = 1:n
    if exist([path0 'cell_' num2str(i) '_bind.mat'], 'file') 

        load([path0 'cell_' num2str(i) '_bind.mat']);     
        ResTime = resTime_distribution(T, Jmin); 
        Density = binding_density([path0 '-\cell_' num2str(i) '_roi.tif'], ResTime, px);

        [frame, prob] = survivalProb_curve(ResTime, Jmin);       
        t = dt*frame; 
        [p, P] = survivalProb_fit(t, prob, fun, p0);
        N = P(end);
        P = [i P(1:end-1) Density];    
        X = [X; P];

        x0 = mod(i-1,Nx);
        y0 = floor((i-1)/Nx);        
        ax = axes('units', 'pixels', 'position', [55+x0*290 30+(Ny-1-y0)*185 245 180]);
        box on 
        survivalProb_plot(t, prob, fun, p, P, tmax, N);

    end
end 


exportgraphics(f, [path0 'ResTime.tif'])
save([path0 'ResTime.mat'], 'X')


