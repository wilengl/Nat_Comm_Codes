function im = MAP_Binding_vs_Diff(T0, T, p)

    [x0, y0, theta] = align_cell(T, p.dir);
    
    z = round(p.w/p.res); 
    im = zeros(z, z, 3);
    
    T0 = rot2d_cell(T0, x0, y0, theta, p.w/2, p.w/2);   
    [x1, y1] = binding_coord(T0, 2);
    T = rot2d_cell(T, x0, y0, theta, p.w/2, p.w/2);   
    [x2, y2] = binding_coord_range(T, 2, p.Nmin);
    x = [x1; x2];
    y = [y1; y2];
    [x3, y3] = binding_coord(T, p.Nmin);
     
    imD = binding_map(x, y, p.w, p.res, p.sigma);
    imD = image_rescale(imD, p.th1);

    imB = binding_map(x3, y3, p.w, p.res, p.sigma);
    imB = image_rescale(imB, p.th2);
    
    im(:,:,1) = p.c1(1)*imD.^p.a + p.c2(1)*imB.^p.b;
    im(:,:,2) = p.c1(2)*imD.^p.a + p.c2(2)*imB.^p.b;
    im(:,:,3) = p.c1(3)*imD.^p.a + p.c2(3)*imB.^p.b;

    if p.edge == 1
        im_edge = cell_edges(p.r, x0, y0, theta, p.w, p.res, p.e, p.shift);
        im = cell_edge(im, im_edge, z, .6);
    end
    
end


function im = cell_edge(im, im_edge, z, c1)
    ind1 = find(im_edge>0);
	im([ind1; ind1+z^2; ind1+2*z^2]) = c1;      
end



function [x, y] = binding_coord(T, Nmin)
    C = [];
    m = 0;
    for i = 1:length(T)
        x = T{i}(:,1);
        y = T{i}(:,2);
        t = T{i}(:,4);
        n = length(x);
        time = t(end)-t(1);
        if time >= Nmin
            C(m+1:m+n,:) = [x y];
            m = m + n;   
        end      
    end
    x = C(:,1);
    y = C(:,2);          
end

function [x, y] = binding_coord_range(T, N1, N2)
    C = [];
    m = 0;
    for i = 1:length(T)
        x = T{i}(:,1);
        y = T{i}(:,2);
        t = T{i}(:,4);
        n = length(x);
        time = t(end)-t(1);
        if time >= N1 && time <N2
            C(m+1:m+n,:) = [x y];
            m = m + n;   
        end      
    end
    if ~isempty(C)
        x = C(:,1);
        y = C(:,2);  
    end
end

function im = get_mapping(x, y, w, res)
    n = round(w/res);
    ind = n*round(x/res) + round(y/res);
    ind = ind(ind < n^2);
    b = accumarray(ind, 1, [n^2 1]);
    im = reshape(b, [n, n]);    
end

function im = binding_map(x, y, w, res, sigma)
    im = get_mapping(x, y, w, res);
    g = gauss2d(sigma/res);
    im = conv2(im, g/sum(g(:)), 'same');   
end

function [x2,y2] = rot2d(x,y,r)
    x2 = cos(r).*x-sin(r).*y;
    y2 = sin(r).*x+cos(r).*y;
end

function T = rot2d_cell(T,x0,y0,theta, x1, y1)
    for i = 1:length(T)
        A = T{i};
        [x, y] = rot2d(A(:,1)-x0, A(:,2)-y0, -theta);
        T{i}(:,1) = x+x1;
        T{i}(:,2) = y+y1;
    end
end

function F = gauss2d(w)
    [x, y] = meshgrid((-ceil(3*w):ceil(3*w)));
    F = 1/(2*pi*w^2)*exp( -.5*(x.^2 + y.^2)/w^2 );
end

function [a, M] = image_rescale(a, th)
    M = prctile(a(a>0), th);
    a = a.*(a<M) + M*(a>=M);
    a = a/M;
end

