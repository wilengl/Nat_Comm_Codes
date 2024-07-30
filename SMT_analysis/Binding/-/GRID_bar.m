function [F, T] = GRID_bar(t, S, th)

ind = [0 (S>th) 0];
u = find(diff(ind)>0);
v = find(diff(ind)<0)-1;

for i = 1:length(u)
    j = u(i):v(i);
    T(i) = sum(t(j).*S(j))/sum(S(j));
    F(i) = sum(S(j));
end

% Time = fliplr(Time);
% Fraction = fliplr(Fraction);
