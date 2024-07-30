function [frame, prob] = survivalProb_curve(T, Jmin)

bin = (1:max(T)+1);
prob = 1 - histcounts(T, bin, 'normalization', 'cdf');
frame = (Jmin:max(T));
prob = prob(Jmin:end-1);
frame = frame(1:end-1);