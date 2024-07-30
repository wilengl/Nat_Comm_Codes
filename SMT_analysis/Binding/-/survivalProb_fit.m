function [p, P] = survivalProb_fit(t, prob, fun, p0)

p = lsqcurvefit(fun, p0.start, t , prob, p0.LB, p0.UB, optimset('Display','off'));  

if length(p) == 2
	P = [p(2) 1 p(1)];
end

if length(p) == 4
	P = [p(3:4) 100*p(1:2)/sum(p(1:2)) sum(p(1:2))];
end

if length(p) == 6
    P = [p(4:6) 100*p(1:3)/sum(p(1:3)) sum(p(1:3))];
end

if length(p) == 8
    P = [p(5:8) 100*p(1:4)/sum(p(1:4)) sum(p(1:4))];
end

if length(p) == 10
    P = [p(6:10) 100*p(1:5)/sum(p(1:5)) sum(p(1:5))];
end