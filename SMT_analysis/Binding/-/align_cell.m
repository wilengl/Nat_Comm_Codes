function [x0, y0, theta] = align_cell(T, dir)

    if dir == 0
        a = 0;
    else
        a = pi/2;
    end

    [x, y] = binding_coord(T, 4);
    x0 = (max(x)+min(x))/2;
    y0 = (max(y)+min(y))/2;
    R = cov(x,y);
    lambda = eig(R);
    [S, ~] = eig(R);
    [~, a_i] = max(lambda);
    [~, b_i] = min(lambda);
    if R(1,1) > R(2,2)
        theta = atan2(S(2,a_i),S(1,a_i))+pi/2+a;
    else
        theta = atan2(S(2,b_i),S(1,b_i))+a;
    end
    
    if dir == -1
        theta = 0;
    end

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
