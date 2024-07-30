clc;
clearvars;
close all;

path0 = 'D:\Nat Comm codes\SMT_analysis\Data_BRG1_WT\fast_tracking\';

u = 7;     %%%   cell #
w = 128;   %%%   image size (px)


file = ['cell_' num2str(u)];
im = imread([path0 '-\' file '.tif']);

f = figure(1);
set(f, 'position', [500 100 700 700])
set(gca, 'position', [0 0 1 1])
imagesc(im)
axis equal off
hold on
colormap gray

roi = images.roi.Polygon(gca, 'color', [0 .9 0], 'visible', 'on', 'facealpha', .1);   
draw(roi);  
in = createMask(roi, w, w);
in = 1.*(in>0);

imwrite(in, [path0 '-\' file '_roi.tif'])
