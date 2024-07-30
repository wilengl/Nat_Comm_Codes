function ResTime = resTime_distribution(T, Jmin)

k = 1;
ResTime = [];

for i = 1:length(T)
    
    t = T{i}(:,4);
    n = t(end)-t(1);
    
    if n >= Jmin
        ResTime(k) = n;
        k = k+1;    
    end
      
end
