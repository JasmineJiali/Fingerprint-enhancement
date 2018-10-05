function H = Hfilter(D0,M)
% Create a Homomorphic filter
[X, Y] = meshgrid(1:M);
gamma_h = 2;
gamma_l = 0.25;
c = 1;
H = (gamma_h-gamma_l) * (1-exp(-c*((X-M/2-1).^2+(Y-M/2-1).^2)/(D0*D0))) + gamma_l;