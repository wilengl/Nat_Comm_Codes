clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\slow_tracking\';

p.Nmin = 4;     %%%   min. number of jumps

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

p.th1 = 95;
p.a = .6;
p.c1 = [0 0 1];

p.th2 = 99;
p.b = 1;
p.c2 = [2 .6 0];


A = [];
n = list_file(path0, 'bind.mat');
[Nx, Ny] = NxNy(n);

f = figure(1);
set(f, 'position', [200 400 1000 320])
set(gca, 'position', [0 0 1 1])

for j = 1:Ny
    Ax = [];
    for i = 1:Nx
        
        u = (j-1)*Nx+ i;

        load([path0 'cell_' num2str(u) '_diff']);
        T0 = T;
        load([path0 'cell_' num2str(u) '_bind'])
        p.r = imread([path0 '-\cell_' num2str(u) '_roi.tif']);
        im = MAP_Binding_vs_Diff(T0, T, p);
        im = trim_image(im, dx, dy);              

        Ax = [Ax im];  
        
    end
    A = [A; Ax];
end
    
imagesc(A)
axis equal off

imwrite(A, [path0 'MAP_Binding_vs_Diff.tif'])






