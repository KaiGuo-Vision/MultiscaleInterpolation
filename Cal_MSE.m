function MSE=Cal_MSE(img1,img2)

% img1=img1*255;
% img2=img2*255;

[nrow,ncol]=size(img1);
Error=sum(sum((img1-img2).^2));
MSE=Error/(nrow*ncol);

% PSNR=10*log10(255^2/Error);