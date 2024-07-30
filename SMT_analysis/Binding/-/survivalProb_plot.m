function survivalProb_plot(t, prob, fun, p, P, tmax, N)

t0 = t(2)-t(1);
ym = 1E-4; 
fx = @(x0) exp(log(t0)+ x0*(log(tmax)-log(t0)));
fy = @(y0) exp(log(ym)+ y0*(log(1)-log(ym)));
c1 = .7*[1 1 1];
c2 = .5*[1 1 1];

hold on
plot(t, prob/N, 'ko', 'color', c1, 'markerfacecolor', c1, 'markersize', 5);
plot(t, fun(p, t)/N, '-', 'linewidth', 3, 'color', [1 0 0 .6])
xlim([t0 tmax])
xticks([1 10 100])
ylim([ym 1])
set(gca,'xscale', 'log', 'yscale', 'log')
set(gca, 'fontsize', 11)
yticks(logspace(-3,0, 4));

opts = struct('fontsize', 11, 'fontname', 'arial', 'HorizontalAlignment', 'right');
text(fx(.9), fy(.9), num2str(P(1)), 'fontsize', 11, 'fontname', 'arial', 'fontweight', 'bold')

if length(p) == 4
    text(fx(.2), fy(.25), sprintf('%.1f',P(2)), opts)
    text(fx(.4), fy(.25), sprintf('%.1f',P(3)), opts)
    text(fx(.2), fy(.12), sprintf('%.0f',P(4)), opts, 'color', c2)
    text(fx(.4), fy(.12), sprintf('%.0f',P(5)), opts, 'color', c2)
    text(fx(.2), fy(.5), sprintf('%.1f',P(6)), opts, 'fontangle', 'italic', 'color', .6*[1 1 1])
end

if length(p) == 6
    text(fx(.2), fy(.25), sprintf('%.1f',P(2)), opts)
    text(fx(.4), fy(.25), sprintf('%.1f',P(3)), opts)
    text(fx(.6), fy(.25), sprintf('%.1f',P(4)), opts)
    text(fx(.2), fy(.12), sprintf('%.0f',P(5)), opts, 'color', c2)
    text(fx(.4), fy(.12), sprintf('%.0f',P(6)), opts, 'color', c2)
    text(fx(.6), fy(.12), sprintf('%.1f',P(7)), opts, 'color', c2)
    text(fx(.2), fy(.5), sprintf('%.1f',P(8)), opts, 'fontangle', 'italic', 'color', .6*[1 1 1])
end
