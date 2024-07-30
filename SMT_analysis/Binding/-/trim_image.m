function im = trim_image(im, dx, dy)

[v, u, ~] = size(im);
x0 = round(u/2);
y0 = round(v/2);
im = im(y0-dy/2:y0+dy/2, x0-dx/2:x0+dx/2,:);