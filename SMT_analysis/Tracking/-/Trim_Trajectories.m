function [A, B] = Trim_Trajectories(T, b)

    Dmax = b.diameter/b.px;
    f = waitbar(0, ''); 
    j = 1;
    B = {};
    jj = 1;
    n = length(T);
    
    for i = 1:n

        x = T{i}(:,1);
        N = numel(x)-1;
        waitbar(i/n,f);
        
        if N >= b.Jmin 
            
            ind = fct_TrimTraj(T{i}, b.Jmin, Dmax);        
            if ~isempty(ind)
                
                A{j} = T{i}(ind,:);
                j = j+1;
                
%%%             Branche 1

                if ind(1)-1 >= b.Jmin     
                    TT = T{i}(1:ind(1),:);
                    ind1 = fct_TrimTraj(TT, b.Jmin, Dmax);
                    
                    if ~isempty(ind1)
                        A{j} = TT(ind1,:);
                        j = j+1;
                        
                        k = 1:ind1(1)-1;                           
                        [B, jj] = update_diffusion(B, TT, k, jj);                     
                        k = ind1(end)+1:length(TT(:,1));                     
                        [B, jj] = update_diffusion(B, TT, k, jj);                    
                        
                    else 
                        k = 1:ind(1)-1;
                        [B, jj] = update_diffusion(B, T{i}, k, jj);                               
                    end
                else       
                    k = 1:ind(1)-1;
                    [B, jj] = update_diffusion(B, T{i}, k, jj);
                end
                
 %%%            Branche 2
 
                if numel(x)-ind(end) >= b.Jmin
                    TT = T{i}(ind(end):numel(x),:);
                    ind1 = fct_TrimTraj(TT, b.Jmin, Dmax);
                    
                    if ~isempty(ind1)
                        A{j} = TT(ind1,:);
                        j = j+1;
                        
                        k = 1:ind1(1)-1;                           
                        [B, jj] = update_diffusion(B, TT, k, jj);                     
                        k = ind1(end)+1:length(TT(:,1));                     
                        [B, jj] = update_diffusion(B, TT, k, jj);    
                        
                    else 
                        k = ind(end)+1:numel(x);
                        [B, jj] = update_diffusion(B, T{i}, k, jj);                               
                    end
                else
                    k = ind(end)+1:numel(x);
                    [B, jj] = update_diffusion(B, T{i}, k, jj);
                end
                
                
            else
                [B, jj] = update_diffusion(B, T{i}, (1:numel(T{i}(:,1))), jj);    
            end
        end
        
    end
    
    delete(f);

end


function [B, jj] = update_diffusion(B, T, k, jj)
    if ~isempty(k)
        B{jj} = T(k,:);
        jj = jj+1;
    end
end

function ind = fct_TrimTraj(T, Jmin, Dmax)

    x = T(:,1);
    y = T(:,2);
    n = numel(x);
    idx = (1:n);
    X = [];

    for i = Jmin:n-1  
        for j = 1:i   
            
            k = idx(j:i:end); 

            for u = 1:length(k)-1     

                ind = k(u):k(u+1);
                xi = x(ind);
                yi = y(ind);
                    
                kk = convhull(xi,yi);
                c = eig(cov(xi(kk), yi(kk)));
                D = sqrt(norm(c));

                if D < Dmax
                    X = [X; [k(u) k(u+1)]];
                end 

            end    
            
        end     
    end

    if ~isempty(X)
        d = X(:,2)-X(:,1);
        z = find(d==max(d));
        ind = X(z,1):X(z,2);
    else
        ind = [];
    end

end





