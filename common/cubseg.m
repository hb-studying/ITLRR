
function [labels,idx] = cubseg(indian_pines,cc)
%用于超像素分割
%把一个矩阵的
[M,N,B]=size(indian_pines);%正面的长宽 和 厚
Y_scale=scaleForSVM(reshape(indian_pines,M*N,B));
% Y_scale = reshape(indian_pines,M*N,B);
Y=reshape(Y_scale,M,N,B);
p = 1;
[Y_pca] = pca(Y_scale, p);

%% Y_pca = mean(Y_scale,2);
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));
sigma=0.05;
K=cc;
grey_img = im2uint8(mat2gray(Y(:,:,1)));
labels = mex_ers(double(img),K);

% labels 是分割后的结果，下面用了一些方法把分割后的结果体现出来
[height width] = size(grey_img);
[bmap] = seg2bmap(labels,width,height);
bmapOnImg = img;
idx = find(bmap>0);
timg = grey_img;
timg(idx) = 255;
bmapOnImg(:,:,2) = timg;
bmapOnImg(:,:,1) = grey_img;
bmapOnImg(:,:,3) = grey_img;

figure;
imshow(bmapOnImg,[]);
% imwrite(bmapOnImg,'bmapOnImg.bmp');
% %^imwrite(grey_img,'bmapOnImg.bmp')
% title('superpixel boundary map');