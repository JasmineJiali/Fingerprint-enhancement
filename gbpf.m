function H = gbpf(D0,W,M)
% Create a Gaussian band pass filter
[DX, DY] = meshgrid(1:M);
if(D0 == 0)
    H = ones(M,M);
else
D = sqrt((DX-M/2-1).^2+(DY-M/2-1).^2);
H = exp(-((D.^2-D0^2)/(D0*W)).^2);
end