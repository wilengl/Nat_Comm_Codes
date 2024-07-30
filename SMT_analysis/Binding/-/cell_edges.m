function im = cell_edges(r, x0, y0, theta, w, res, e, shift)

    [xs, ys] = smooth_contour(1.*(r>0), 30);
    [xs, ys] = rot2d(xs-x0, ys-y0, -theta);   
    xs = xs + shift.x;
    ys = ys + shift.y;
    im = dot_connect(w, res, xs, ys, 8);
    g = gauss2d(e);
    im = conv2(im, g, 'same');
    im = 1.*(im>.01);
    
end

function im = get_mapping(x, y, w, res)
    n = round(w/res);
    ind = n*round(x/res) + round(y/res);
    ind = ind(ind < n^2);
    b = accumarray(ind, 1, [n^2 1]);
    im = reshape(b, [n, n]);    
end

function im = dot_connect(w, res, xs, ys, n)
    x = [];
    y = [];
    for i = 1:numel(xs)-1
        x = [x linspace(xs(i), xs(i+1), n)];
        y = [y linspace(ys(i), ys(i+1), n)];
    end
    im = get_mapping(x'+w/2, y'+w/2, w, res);
end

function [xs, ys] = smooth_contour(r, w)
    r = del2(r)>0;
    [y, x] = find(r); 
    c = bwtraceboundary(1.*r, [y(1),x(1)], 'SW');
    u = 80;
    c = [c; c(1:u,:)];
    x = c(:,2);
    y = c(:,1);
    [xs, ys] = fct_smooth_contours(x, y, w);
    xs = xs(40:end-40);
    ys = ys(40:end-40);
end

function [Xs, Ys] = fct_smooth_contours(X, Y, Radius)

    Xs = zeros(length(X),1);
    Ys = zeros(length(X),1);
    Xs(1:Radius) = X(1:Radius);
    Ys(1:Radius) = Y(1:Radius);
    Xs(length(X)-Radius:end) = X(length(X)-Radius:end);
    Ys(length(X)-Radius:end) = Y(length(X)-Radius:end);
    maxX = max(max(X));
    minX = min(min(X));
    maxY = max(max(Y));
    minY = min(min(Y));

    for i = Radius+1:length(X)-Radius
        ind = (i-Radius:i+Radius);
        xLocal = X(ind);
        yLocal = Y(ind);
        [a, b, c] = wols(xLocal,yLocal,gausswin(length(xLocal),5));
        p(1) = -a/b;
        p(2) = -c/b;
        [x2, y2]=project_point_on_line(p(1), p(2), X(i), Y(i));
        if (x2>=minX && y2>minY && x2<=maxX && y2<=maxY)
            Xs(i)=x2;
            Ys(i)=y2;
        else
            Xs(i)=X(i);
            Ys(i)=Y(i);
        end
    end

end

function [x2, y2] = project_point_on_line(m1, b1, x1, y1)
    m2 = -1./m1;
    b2 = -m2*x1+y1;
    x2 = (b2-b1)./(m1-m2);
    y2 = m2.*x2+b2;
end

function [a, b, c] = wols(x,y,w)
    n = sum(w);
    meanx = sum(w.*x)/n;
    meany = sum(w.*y)/n;
    x = x - meanx;
    y = y - meany;
    y2x2 = sum(w.*(y.^2 - x.^2));
    xy = sum(w.*x.*y);
    alpha = 0.5 * acot(0.5 * y2x2 / xy) + pi/2*(y2x2 > 0);
    a = sin(alpha);
    b = cos(alpha);
    c = -(a*meanx + b*meany);
end

function F = gauss2d(sigma)
    w0 = 3*ceil(sigma);
    [x, y] = meshgrid((-w0:w0));
    F = exp( -.5*(x.^2 + y.^2)/sigma^2 );
    F = F/sum(F(:));   
end

function [x2,y2] = rot2d(x,y,r)
    x2 = cos(r).*x - sin(r).*y;
    y2 = sin(r).*x + cos(r).*y;
end

