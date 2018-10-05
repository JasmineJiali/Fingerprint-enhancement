clc;
close all;

A = imread('D:\1.学习\大三上\数图\作业\综合作业1\100_3.bmp');
B = im2double(A);
[M,N] = size(B);
num = 32;
figure(6),imshow(B);

C = imresize(B,[512 512],'bicubic');
C_mean = mean2(C);
C_var = std2(C);

G = zeros(512,512);

for i = 1:512
    for j = 1:512
        if (C(i,j)>C_mean)
           G(i,j) = 0.5 + sqrt(0.25*(C(i,j) - C_mean)^2/C_var);
        else 
           G(i,j) = 0.5 - sqrt(0.25*(C(i,j) - C_mean)^2/C_var);
        end
    end
end
        
  

D = cell(21,21);
%分割成32*32的小块
for i = 1:21
    for j = 1:21
        D{i,j}= G(i+23*(i-1):i+23*(i-1)+31,j+23*(j-1):j+23*(j-1)+31);
    end
end
figure(1),imshow(D{15,18});  
%二维DFT
D_DFT = cell(21,21);

D_margin = cell(21,21);
D_log = cell(21,21);
theta = pi/2*ones(21,21);
fre = zeros(21,21);
for i = 1:21
    for j = 1:21
        D_DFT{i,j} = fftshift(fft2(D{i,j}));
        
        D_margin{i,j} = abs(D_DFT{i,j});
       % D_log{i,j} = fftshift(fft2(log(D{i,j})));
        [x,y] = sort(D_margin{i,j}(:),'descend');
        for k = 1:10
           [x1,y1] = ind2sub(size(D{i,j}),y(k));
           [x2,y2] = ind2sub(size(D{i,j}),y(k+1));
           if(D_margin{i,j}(x1,y1)== D_margin{i,j}(x2,y2)&&(x1+x2)/2==17&&(y1+y2)/2==17)
                 theta(i,j) = atand((x1-x2)/(y1-y2));
                 fre(i,j) = sqrt(((x1-x2)/2)^2+((y1-y2)/2)^2);
                 if(fre(i,j)>=4)
                     fre(i,j) = 0;
                     theta(i,j)=pi/2;
                 end
                break;
           end
        end
         if(theta(i,j)<0)
             theta(i,j) = 180+theta(i,j);
         end
    end
end
theta = medfilt2(theta,[5 5]);
fre = medfilt2(fre,[5,5]);
%A=fspecial('average',[3,3]); %生成系统预定义的3X3滤波器  
%theta=imfilter(theta,A);   

figure(2),quiver(1:21,1:21,-sind(theta),cosd(theta));
set(gca,'XAxisLocation','top')
set(gca,'Ydir','reverse')

%处理后合成图片
dst = zeros(504,504);
F = cell(21,21);
E = cell(21,21);
for i = 1:21
    for j = 1:21
       %H = gbpf(fre(i,j),2,32);%高斯
       H = bbpf(fre(i,j),2,1,32);%巴特沃斯
       %H = ibpf(fre(i,j),6,32);%理想低通
       %H = Hfilter(fre(i,j),32);%同态
       H2 =  myfilter(theta(i,j),60,32);
       F{i,j} = D_DFT{i,j}.*H;
       %F{i,j} = F{i,j}.*H2; 
       F{i,j} = real(ifft2(ifftshift(F{i,j})));
       
%        E{i,j} = D_log{i,j}.*H;
%        E{i,j} = E{i,j}.*H2;
%       
%        E{i,j} = real(ifft2(ifftshift(E{i,j})));
%        E{i,j} = exp(E{i,j});
     
       dst(i+23*(i-1):i+23*(i-1)+23,j+23*(j-1):j+23*(j-1)+23) = F{i,j}(5:28,5:28);
    end
end
thresh = graythresh(dst);
dst = imbinarize(dst,thresh);
figure(3),imshow(~fre);
figure(4),clf
subplot(1,2,1),imshow(G),title('Original image');
subplot(1,2,2),imshow(dst),title('Dstination image');
