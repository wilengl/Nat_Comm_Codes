function S = GRID_spectrum(t, prob, k, E, dt)

    options = optimoptions('fmincon','Algorithm','sqp','GradObj','on','GradConstr','on','Display','off',...
        'CheckGradients',1==0,'MaxIterations',1000,'FiniteDIfferenceType','central','ConstraintTolerance',1);

    n = numel(k);
    x0 = zeros(1,n)+1/n;
    Aeq = ones(1,n);
    lb = zeros(1,n);
    ub = ones(1,n);

    S = fmincon(@(Si) lsqobj(Si, k, t, prob, E, dt), x0, [], [], Aeq, 1, lb, ub, [], options);

end

function [d, grad] = lsqobj(S, k, t, ftarg, E, dt)

    idx = 5;
    gradreg = zeros(numel(S),1);

    h = calch(S, k, t);
    eq0 = h./h(idx) - ftarg./ftarg(idx);
    ceq = sum(eq0.^2); 

    gradceq = gradh(eq0, h, t, k, idx);

    tau = [dt 2*dt];
    A = Transmat(tau, k);
    kquer = A*(k.*S)'./(A*S');
    reg = .5*(kquer(1)-kquer(2))^2;

    temp1 = A(1,:)'/(A(1,:)*S').*(k-kquer(1))';
    temp2 = A(2,:)'/(A(2,:)*S').*(k-kquer(2))';
    gradreg(1:numel(S)) = (kquer(1)-kquer(2))*(temp1'-temp2');

    d = ceq + E*reg;
    grad = gradceq + E*gradreg;

end

function h = calch(S, k, p)
    A = Transmat(p,k);
    h = A*S';
end

function gradS = gradh(eq0, h, p, k, idx)
    A = Transmat(p,k)';  
    gradS = zeros(numel(k),1);
    for n = 1:numel(p)
        gradS = gradS + 2*eq0(n)*(A(:,n)/(h(idx))-A(:,idx)*(h(n))/(h(idx))^2);
    end 
end

function A = Transmat(p, k)
    M = numel(p);
    N = numel(k);
    A = ones(M,N);
    for m = 1:M
        for n = 1:N
            A(m,n) = exp(-k(n)*p(m));
        end
    end
end
