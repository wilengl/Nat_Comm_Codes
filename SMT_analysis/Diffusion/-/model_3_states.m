function P = model_3_states(jump, dmax, param, px, i)

global dr dt

c0 = [.5 .5 .5];

rbin = (0:dr:px*dmax);
r = (dr/2:dr:rbin(end));

N = histcounts(px*jump, rbin, 'normalization', 'probability');
p = lsqcurvefit('model_3_states_fit', param.start, r, N, param.LB, param.UB, optimset('Display','off'));
P = [p(1:3) 100*[p(4:5) (1-p(4)-p(5))]];

r_fit = linspace(0, px*dmax, 200);
y_fit = model_3_states_fit(p, r_fit);

jump_histogram(rbin, dr, N, c0);
hold on

y1 = p(4).*(dr*r_fit./(2*p(1)*dt)).*exp(-r_fit.^2./(4*p(1)*dt)); 
y2 = p(5).*(dr*r_fit./(2*p(2)*dt)).*exp(-r_fit.^2./(4*p(2)*dt)); 
y3 = (1-p(4)-p(5)).*(dr*r_fit./(2*p(3)*dt)).*exp(-r_fit.^2./(4*p(3)*dt)); 

plot(r_fit, y1, 'k-', 'linewidth', 2, 'color', [1 0 0 .5]);
plot(r_fit, y2, 'k-', 'linewidth', 2, 'color', [0 .8 0 .5]);
plot(r_fit, y3, 'k-', 'linewidth', 2, 'color', [0 0 1 .5]);
plot(r_fit, y_fit, 'r-', 'linewidth', 2, 'color', [.5 .5 .5 .5])
box on

m = get(gca, 'ylim');
m = m(2);
opts = struct('fontsize', 12, 'fontname', 'arial', 'HorizontalAlignment', 'right');
text(.9*px*dmax, .98*m, num2str(i), 'fontsize', 12, 'fontname', 'arial', 'fontweight', 'bold')
text(.3, .77*m, sprintf('%.2f',P(1)), opts, 'color', [1 0 0 .5])
text(.42, .77*m, sprintf('%.2f',P(2)), opts, 'color', [0 .8 0 .5])
text(.54, .77*m, sprintf('%.1f',P(3)), opts, 'color', [0 0 1 .5])
text(.3, .65*m, sprintf('%.0f',P(4)), opts, 'color', .6*[1 1 1])
text(.42, .65*m, sprintf('%.0f',P(5)), opts, 'color', .6*[1 1 1])
text(.54, .65*m, sprintf('%.0f',P(6)), opts, 'color', .6*[1 1 1])
text(.54, .5*m, sprintf('%.0f',length(jump)/1000), opts, 'color', .0*[1 1 1])

yticks((0:.01:.1))
xlim([0 px*dmax])    
ylim([0 1.1*m])




