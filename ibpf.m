function H = ibpf(D0,W,M)
% Create a ideal band pass filter
H = zeros(M,M);
[DX, DY] = meshgrid(1:M);
D = sqrt((DX-M/2-1).^2+(DY-M/2-1).^2);
MASK = (D<=D0+W/2) & (D>=D0-W/2);
H(MASK) = 1;