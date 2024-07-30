function [Nx, Ny] = NxNy(n)

if n>=1 && n<=2
    Nx = n;
end

if n>=3 && n<=4
    Nx = 2;
end

if n>=5 && n<=6
    Nx = 3;
end

if n>=7 && n<=12
    Nx = 4;
end

if n>=13
    Nx = 5;
end

if n>=20
    Nx = 6;
end

Ny = floor((n-1)/Nx)+1;
