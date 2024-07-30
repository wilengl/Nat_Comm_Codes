function [fun, p] = binding_ExpFit(n)

if n == 1
    p.start = [.3 1]; 
    p.LB = [0 .1]; 
    p.UB = [3 30]; 
    fun = @(p, x) p(1)*exp(-x/p(2));
end

if n == 2
    p.start = [.3 .3 1 2]; 
    p.LB = [0 0 .3 1.5]; 
    p.UB = [3 3 3 60]; 
    fun = @(p, x) p(1)*exp(-x/p(3)) + p(2)*exp(-x/p(4));
end

if n == 3
    p.start = [.3 .3 .3 1 4 15]; 
    p.LB = [0 0 0 .1 1 2]; 
    p.UB = [3 3 3 5 50 250]; 
    fun = @(p, x) p(1)*exp(-x/p(4)) + p(2)*exp(-x/p(5)) + p(3)*exp(-x/p(6));
end

if n == 4
    p.start = [.25 .25 .25 .25 1 2 6 15]; 
    p.LB = [0 0 0 0 .1 .3 1 4]; 
    p.UB = [2 2 2 2 1 6 12 80]; 
    fun = @(p, x) p(1)*exp(-x/p(5)) + p(2)*exp(-x/p(6)) + p(3)*exp(-x/p(7)) + p(4)*exp(-x/p(8));
end

if n == 5
    p.start = [.2 .2 .2 .2 .2 1 2 3 6 15]; 
    p.LB = [0 0 0 0 0 .1 .3 .5 1 4]; 
    p.UB = [2 2 2 2 2 1 6 8 12 100]; 
    fun = @(p, x) p(1)*exp(-x/p(6)) + p(2)*exp(-x/p(7)) + p(3)*exp(-x/p(8)) + p(4)*exp(-x/p(9)) + p(5)*exp(-x/p(10));
end

if n == 6
    p.start = [.3 1 10]; 
    p.LB = [0 .1 4]; 
    p.UB = [1 3 60]; 
    fun = @(p, x) p(1)*exp(-x/p(2)) + (1-p(1))*exp(-x/p(3));
end

if n == 7
    p.start = 10; 
    p.LB = .1; 
    p.UB = 60; 
    fun = @(p, x) exp(-x/p(1));
end


% p0.start = [.8 .5 7]; 
% p0.LB = [0 .3 3]; 
% p0.UB = [1 3 20]; 
% fun = @(p, x) p(1)*exp(-x/p(2)) + (1-p(1))*exp(-x/p(3));
