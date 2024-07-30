function im = MAP_Cluster(T, p)

    [x0, y0, theta] = align_cell(T, p.dir);
    z = round(p.w/p.res); 
    im = zeros(z, z, 3);
    
    T = rot2d_cell(T, x0, y0, theta, p.w/2, p.w/2);    
    [A, T] = mean_position(T, p.Nmin); 
    [k, kh] = cluster_selection(A, p);

    [x, y] = binding_coord_idx(T, k);
    imB = binding_map(x, y, p.w, p.res, p.sigma);
    imB = image_rescale(imB, p.th1);

    [x, y] = binding_coord_idx(T, kh);
    imC = binding_map(x, y, p.w, p.res, p.sigma);
    imC = image_rescale(imC, p.th2);

    im(:,:,1) = p.c1(1)*imB.^p.a + p.c2(1)*imC.^p.b;
    im(:,:,2) = p.c1(2)*imB.^p.a + p.c2(2)*imC.^p.b;
    im(:,:,3) = p.c1(3)*imB.^p.a + p.c2(3)*imC.^p.b;

     if p.edge == 1
        im_edge = cell_edges(p.r, x0, y0, theta, p.w, p.res, p.e, p.shift);
        im = cell_edge(im, im_edge, z, .6);
     end
    
end


function [k, kh] = cluster_selection(A, p)

    DT = delaunayTriangulation(A(:,1),A(:,2));
    pts = DT.Points;
    edges = DT.edges;
    Ledge = sqrt((pts(edges(:,1),1) - pts(edges(:,2),1)).^2 + (pts(edges(:,1),2) - pts(edges(:,2),2)).^2);
    cutoff = Ledge <= p.dmax;
    edg = edges(cutoff,:);
    G = graph(edg(:,1),edg(:,2));
    Gbin = conncomp(G,'OutputForm','cell')';

    N = 0;
    kh = [];
    for j = 1:numel(Gbin)     
        ind = Gbin{j};
        m = length(ind);
        if m >= p.Nhub
            kh = [kh ind];
            N = N+1;
        end             
    end      
    k = (1:size(A(:,1)));
    k = setdiff(k, kh);
    
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

function [x, y] = binding_coord_idx(T, idx)
    C = [];
    m = 0;
    for i = 1:length(idx)    
        j = idx(i);
        x = T{j}(:,1);
        y = T{j}(:,2);
        n = length(x);
        C(m+1:m+n,:) = [x y];
        m = m + n;               
    end
    
    if ~isempty(C)
        x = C(:,1);
        y = C(:,2);
    else
        x = 1;
        y = 1;
    end
end


function [a, M] = image_rescale(a, th)
    M = prctile(a(a>0), th);
    a = a.*(a<M) + M*(a>=M);
    a = a/M;
end


function [A, T] = mean_position(T, Nmin)
    j = 1;
    for i = 1:length(T)  
        t = T{i}(:,4);
        time = t(end)-t(1);
        if time >= Nmin
            A(j,:) = [mean(T{i}(:,1)) mean(T{i}(:,2)) time i];
            TT{j} = T{i};
            j = j+1;
        end
    end
    T = TT;
end

function im = cell_edge(im, im_edge, z, c1)
    ind1 = find(im_edge>0);
	im([ind1; ind1+z^2; ind1+2*z^2]) = c1;      
end
