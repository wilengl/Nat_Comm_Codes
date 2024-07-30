function T = fct_tracking(X, p, varargin)

X(end-1) = []; 
X(end) = [];    
for k = 1:length(X)
    X{k} = [X{k}(:,1:3), k*ones(length(X{k}(:,1)),1)];
end

all_points = vertcat(X{:});
[~, idx] = simpletracker(X, 'Method', 'NearestNeighbor', 'MaxGapClosing', p.mem, 'MaxLinkingDistance', p.dmax, 'Debug', false);

k = 1;
T = [];
if ~isempty(varargin)
    r = varargin{1};
    r = 1.*(r>0);
    for i = 1:length(idx)
        if length(idx{i}) >= p.Nmin
            x = all_points(idx{i},1);
            y = all_points(idx{i},2);
            if round(mean(x))>=1 && round(mean(y))>=1
            if r(round(mean(y)), round(mean(x))) == 1
                T{k} = all_points(idx{i},1:4); 
                k = k+1; 
            end
            end
        end
    end
else
     for i = 1:length(idx)
        if length(idx{i}) >= p.Nmin
            T{k} = all_points(idx{i},1:4); 
            k = k+1; 
        end
    end    
end
