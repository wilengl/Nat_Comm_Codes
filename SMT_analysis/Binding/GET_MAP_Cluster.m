clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\slow_tracking\';

p.Nmin = 10;    %%%   min. number of jump
p.dmax = 1.25;  %%%   max. distance between binding events in a cluster (px)
p.Nhub = 3;     %%%   min. number of binding events per cluster

p.res = .25;    %%%   resolution (px)
p.sigma = .25;  %%%   gaussian blur (px)

p.dir = 1;      %%%   nucleus orientation: horizontal (1), vertical (0), no reorientation (-1)
p.edge = 1;     %%%   showing nucleus boundary: yes (1), no (0)
p.e = 1;        %%%   thickness of the nucleus boundary
dx = 800;       %%%   width (px)
dy = 500;       %%%   height (px)

p.w = 400;  
p.shift.x = 0;
p.shift.y = 0;

p.th1 = 98;
p.a = .8;
p.c1 = [.8 .8 0];

p.th2 = 99;
p.b = .7;
p.c2 = [1 0 1];


A = [];
n = list_file(path0, 'bind.mat');
[Nx, Ny] = NxNy(n);

f = figure(1);
set(f, 'position', [200 400 1000 320])
set(gca, 'position', [0 0 1 1])

for j = 1:Ny
    Ax = [];
    
    for i = 1:Nx

        k = (j-1)*Nx+ i;

        load([path0 'cell_' num2str(k) '_bind'])
        p.r = imread([path0 '-\cell_' num2str(k) '_roi.tif']);
        im = MAP_Cluster(T, p);
        im = trim_image(im, dx, dy);   
        
        Ax = [Ax im];   
        
    end
    A = [A; Ax];

end

imagesc(A)
axis equal off

imwrite(A, [path0 'MAP_Cluster.tif'])





