function y = model_3_states_fit(p, r)

    global dt dr ds
    
    D_BOUND = p(1);
    D_SLOW = p(2);
    D_FAST = p(3);
    F_BOUND = p(4);
    F_SLOW = p(5);
    
    y =           F_BOUND.*(dr*r./(2*(D_BOUND*dt + ds^2))).*exp(-r.^2./(4*(D_BOUND*dt + ds^2))) +...
                   F_SLOW.*(dr*r./(2*(D_SLOW*dt + ds^2))).*exp(-r.^2./(4*(D_SLOW*dt + ds^2))) +...
       (1-F_BOUND-F_SLOW).*(dr*r./(2*(D_FAST*dt + ds^2))).*exp(-r.^2./(4*(D_FAST*dt + ds^2))) ;
    
end

