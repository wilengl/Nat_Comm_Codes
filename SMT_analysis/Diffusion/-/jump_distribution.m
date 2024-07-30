function jump = jump_distribution(T)

jump = [];

for i = 1:length(T)   
    
    x = T{i}(:,1);
    y = T{i}(:,2);    
    r = sqrt(diff(x).^2 + diff(y).^2);    
    jump = [jump; r];
    
end