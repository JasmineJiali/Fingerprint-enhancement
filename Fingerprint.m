clc;
close all;
%16*16��С��
A = imread('D:\1.ѧϰ\������\��ͼ\��ҵ\�ۺ���ҵ1\100_3.bmp');
B = im2double(A);
[M,N] = size(B);
num = 32;


C = imresize(B,[492 492],'bicubic');
C_mean = mean2(C);
C_var = std2(C);

G = zeros(492,492);

for i = 1:492
    for j = 1:492
        if (C(i,j)>C_mean)
           G(i,j) = 0.5 + sqrt(0.25*(C(i,j) - C_mean)^2/C_var);
        else 
           G(i,j) = 0.5 - sqrt(0.25*(C(i,j) - C_mean)^2/C_var);
        end
    end
end
        
  

D = cell(35,35);
%�ָ��16*16��С�飬���ڿ��ص�2��
for i = 1:35
    for j = 1:35
        D{i,j}= C(i+13*(i-1):i+13*(i-1)+15,j+13*(j-1):j+13*(j-1)+15);
    end
end
figure(1),imshow(D{30,30});  

%��άDFT
D_DFT = cell(35,35);
D_margin = cell(35,35);
D_log = cell(35,35);
theta = pi/2*ones(35,35);
fre = zeros(35,35);
for i = 1:35
    for j = 1:35
        D_DFT{i,j} = fftshift(fft2(D{i,j}));
      
        D_margin{i,j} = abs(D_DFT{i,j});
        D_log{i,j} = fftshift(fft2(log(D{i,j}))); 
        [x,y] = sort(D_margin{i,j}(:),'descend');%����������
        for k = 1:10
           [x1,y1] = ind2sub(size(D{i,j}),y(k));
           [x2,y2] = ind2sub(size(D{i,j}),y(k+1));
           if(D_margin{i,j}(x1,y1)== D_margin{i,j}(x2,y2)&&(x1+x2)/2==9&&(y1+y2)/2==9)%��ֵ������ĶԳƵ�����
                 theta(i,j) = atand((x1-x2)/(y1-y2));
                 fre(i,j) = sqrt(((x1-x2)/2)^2+((y1-y2)/2)^2);
                 if(fre(i,j)>=4)%ǰ�������ж�
                     fre(i,j) = 0;
%                      theta(i,j) = pi/2;
                 end
                break;
           end
        end
         if(theta(i,j)<0)
             theta(i,j) = 180+theta(i,j);%�Ƕȷ�Χ��0~180��֮��
         end
    end
end
theta = medfilt2(theta,[5 5]);%��ֵ�˲�
fre = medfilt2(fre,[5,5]);
% A=fspecial('average',[5,5]); %��ֵ�˲�
% theta=imfilter(theta,A);   

figure(2),quiver(1:35,1:35,-sind(theta),cosd(theta));
set(gca,'XAxisLocation','top')
set(gca,'Ydir','reverse')

%�����ϳ�ͼƬ
dst = zeros(490,490);
F = cell(35,35);
E = cell(35,35);
for i = 1:35
    for j = 1:35
       %H = gbpf(fre(i,j),4,16);%��˹��ͨ
       %H = bbpf(fre(i,j),1,1,16);%������˹
       H = ibpf(fre(i,j),4,16);%�����ͨ
       %H = Hfilter(fre(i,j),16);%̬ͬ
       H2 =  myfilter(theta(i,j),90,16);%�Ƕ�
      
       F{i,j} = D_DFT{i,j}.*H;
       F{i,j} = F{i,j}.*H2; 
       F{i,j} = real(ifft2(ifftshift(F{i,j})));
       
%        E{i,j} = D_log{i,j}.*H;
%        E{i,j} = E{i,j}.*H2;
%       
%        E{i,j} = real(ifft2(ifftshift(E{i,j})));
%        E{i,j} = exp(E{i,j});
       
       dst(i+13*(i-1):i+13*(i-1)+13,j+13*(j-1):j+13*(j-1)+13) = F{i,j}(2:15,2:15);%ͼƬ�ϳ�
    end
end
thresh = graythresh(dst);
dst = imbinarize(dst,thresh);

figure(4),clf
subplot(1,2,1),imshow(G),title('Original image');
subplot(1,2,2),imshow(dst),title('Dstination image');
