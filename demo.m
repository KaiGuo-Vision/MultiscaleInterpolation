% This is a code (new implementation) of the algorithm described in "Multiscale Semilocal Interpolation With Antialiasing, 
% K. Guo, X. Yang, H. Zha, W. Lin and S. Yu, IEEE Trans. Image Processing, 2012". 
% If you use this code for academic purposes, please consider citing:
% 
% @injournal{TIP2012,
%  	 title={Multiscale Semilocal Interpolation With Antialiasing},
%  	 author={Kai Guo, Xiaokang Yang, Hongyuan Zha, Weiyao Lin and Songyu Yu},
%  	 booktitle={IEEE Transactions on Image Processing},
%  	 year={2012}}

clear;
close all;
% parameter setting
% -------------------------------------------------------------------------
file_images='testImages\*.bmp';
address_images='testImages\';
address_results='results\';


% Find the directory of training images
fileDir_images=dir(file_images);
for i=1:length(fileDir_images)
    file_image=strcat(address_images,fileDir_images(i).name);
    im=imread(file_image);
    img_gt=double(im)/255;
    figure;
    imshow(img_gt);
    
    [nrow,ncol]=size(img_gt);
    nrow = floor(nrow/2)*2;
    ncol = floor(ncol/2)*2;
  
    img_gt=img_gt(1:nrow,1:ncol);
    
    
    [img_o, img_r1, img_d1, img_rd1]=extract_quater(img_gt);
    
    t=cputime;
    img_h=MSI_factor2(img_o);
    
    e = cputime-t;
    time_our=e;
    
    % -----------------------------------------------------
    f1=figure;
    imshow(img_h,'Border','tight','initialMagnification',100);
    axis off
    axis image
    psnr_now=psnr(255*img_gt,255*img_h);
    ssim_now=ssim(255*img_gt,255*img_h);
    %psnr_now=psnr(255*img_gt(index_s:end-index_e,index_s:end-index_e),255*img_h(index_s:end-index_e,index_s:end-index_e));
    file_results=strcat(address_results,'img_',num2str(i),'_our_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_our),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img_',num2str(i),'_our_psnr',num2str(psnr_now),'ssim_',num2str(ssim_now),'_time',num2str(time_our),'.bmp');
    imwrite(img_h,file_results,'bmp');
    
    
    % ---------------------------------------------------------------------
    f1=figure;
    imshow(img_gt,'Border','tight','initialMagnification',100);
    axis off
    axis image
    psnr_now=psnr(255*img_gt,255*img_gt);
    ssim_now=ssim(255*img_gt,255*img_gt);
    file_results=strcat(address_results,'img',num2str(i),'_gt_',num2str(psnr_now),'_',num2str(ssim_now),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_gt_',num2str(psnr_now),'_',num2str(ssim_now),'.bmp');
    imwrite(img_gt,file_results,'bmp');
    
    f1=figure;
    imshow(img_o,'Border','tight','initialMagnification',100);
    axis off
    axis image
    file_results=strcat(address_results,'img',num2str(i),'_o','.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_o','.bmp');
    imwrite(img_o,file_results,'bmp');
    
    
    % ---------------------------------------
    t=cputime;
    [bic_r,bic_d,bic_rd,bic_full]=bicubicInter4(img_o);
    %[bic_r,bic_d,bic_rd,bic_full]=bicubicInter4(bic_m);
    e = cputime-t;
    time_bic=e;
    
    f1=figure;
    imshow(bic_full,'Border','tight','initialMagnification',100);
    axis off
    axis image
    psnr_now=psnr(255*img_gt,255*bic_full);
    ssim_now=ssim(255*img_gt,255*bic_full);
    file_results=strcat(address_results,'img',num2str(i),'_bic_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_bic),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_bic_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_bic),'.bmp');
    imwrite(bic_full,file_results,'bmp');
    
    
    % AI
    t = cputime;
    img_inter1=AIinterpolation(img_o);
    %img_inter2=AIinterpolation(img_inter1);
    img_inter=img_inter1;
    e = cputime-t;
    time_AI=e;
    
    f1=figure;
    imshow(img_inter,'Border','tight','initialMagnification',100);
    axis off
    axis image
    psnr_now=psnr(255*img_gt,255*img_inter);
    ssim_now=ssim(255*img_gt,255*img_inter);
    file_results=strcat(address_results,'img',num2str(i),'_AI_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_AI),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_AI_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_AI),'.bmp');
    imwrite(img_inter,file_results,'bmp');
    img_AI=img_inter;
    % inedi
    t=cputime;
    
    img_inedi=inediInterpolation(img_o);
    %img_inedi=inediInterpolation(img_temp);
    
    e = cputime-t;
    time_inedi=e;
    close all;
    f1=figure;
    imshow(img_inedi,'Border','tight','initialMagnification',100);
    axis off
    axis image
    
    psnr_now=psnr(255*img_gt,255*img_inedi);
    ssim_now=ssim(255*img_gt,255*img_inedi);
    file_results=strcat(address_results,'img',num2str(i),'_inedi_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_inedi),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_inedi_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_inedi),'.bmp');
    imwrite(img_inedi,file_results,'bmp');
    
    
    
    % esintp
    t=cputime;
    
    img_esintp=esintpInterpolation(img_o,img_inter1);
    %img_esintp=esintpInterpolation(img_temp,img_inter2);
    
    e = cputime-t;
    time_esintp=e;
    
    f1=figure;
    imshow(img_esintp,'Border','tight','initialMagnification',100);
    axis off
    axis image
    
    psnr_now=psnr(255*img_gt,255*img_esintp);
    ssim_now=ssim(255*img_gt,255*img_esintp);
    %psnr_now=psnr(255*img_gt(index_s:end-index_e,index_s:end-index_e),255*img_esintp(index_s:end-index_e,index_s:end-index_e));
    file_results=strcat(address_results,'img',num2str(i),'_esintp_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_esintp),'.eps');
    saveas(f1,file_results,'psc2');
    file_results=strcat(address_results,'img',num2str(i),'_esintp_psnr',num2str(psnr_now),'_ssim',num2str(ssim_now),'_time',num2str(time_esintp),'.bmp');
    imwrite(img_esintp,file_results,'bmp');
    

    
    close all;
    
    
end


