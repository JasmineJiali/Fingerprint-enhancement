function H = bbpf(D0,W,n,M)
% Create a Butterworth band pass filter
[DX, DY] = meshgrid(1:M);
D = sqrt((DX-M/2-1).^2+(DY-M/2-1).^2);
H = 1./(1+((D.^2-D0^2)/(D0*W)).^(2*n));