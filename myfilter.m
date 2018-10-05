function H = myfilter(D0,W,M)
% Create a angle filter
H = zeros(M,M);
H(M/2+1,M/2+1) = 1;
[DX, DY] = meshgrid(1:M);
D = atand((DX-M/2-1)./(DY-M/2-1));
for i = 1:M
    for j = 1:M
        if(D(i,j)<0)
            D(i,j) = 180+D(i,j);
        end
    end
end
MASK = (abs(D-D0)<= W);
H(MASK) = 1;

