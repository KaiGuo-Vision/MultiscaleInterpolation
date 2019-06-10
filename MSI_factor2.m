function img_h = MSI_factor2(img_o)

% This is a code (new implementation) of the algorithm described in "Multiscale Semilocal Interpolation With Antialiasing, 
% K. Guo, X. Yang, H. Zha, W. Lin and S. Yu, IEEE Trans. Image Processing, 2012". 
% If you use this code for academic purposes, please consider citing:
% 
% @injournal{TIP2012,
%  	 title={Multiscale Semilocal Interpolation With Antialiasing},
%  	 author={Kai Guo, Xiaokang Yang, Hongyuan Zha, Weiyao Lin and Songyu Yu},
%  	 booktitle={IEEE Transactions on Image Processing},
%  	 year={2012}}

% Note that this code was not efficiently written but for clarity of the
% proposed algorithm. Therefore it may take several minutes to run an image.


% i: the index of the image
% level: the interpolation level

t=cputime;
[bic_r,bic_d,bic_rd,bic_full]=bicubicInter4(img_o);
%e = cputime-t;
%time_bic=e;

% *********************************************************************
% ---------------------------------------------------------------------
% *********************************************************************
% our method
t=cputime;

img_hPre=bic_full;
% img_inter
% set the patch size parameters
ps_max=16;
ps_min=6;
ps_step=-1;

search_radius=8;
% ---------------------------------------------------------------------
% mask_label
% 1: LR pixel
% 2: the undersampled pixels in the area of high activities, and will
%    be interpolated by our method
% 0: the undersampled pixels in the smooth area, and will be interpolated by bicubic method
tt_o=ones(size(img_o));
tt_r=zeros(size(img_o));
temp_a=joinImage(tt_o,tt_r,tt_r,tt_r);
%     figure;
%     imshow(img_gt,[]);
%     figure;
%     imshow(bic_full,[]);
fil_lap=[ 0  -1   0;
    -1   4  -1;
    0  -1   0];
fil_ave=ones(5,5);
temp_b=abs(conv2(bic_full,fil_lap,'same'));
temp_c=zeros(size(bic_full));
temp_c(temp_b>0.09)=1;
temp_d=conv2(temp_c,fil_ave,'same');
temp_e=zeros(size(bic_full));
temp_e(temp_d>0)=2;
%     figure;
%     imshow(temp_e,[]);
temp_e(temp_a==1)=1;
mask_label=temp_e;

% define the candidates cell, phi value cell, candidates position cell
ps_skip=ps_min-1;
[nrow,ncol]=size(bic_full);
for patch_size=ps_min:1:ps_max
    k=patch_size-ps_skip;
    for m=1:nrow
        for n=1:ncol
            candi{k,m,n}=[];
            phi{k,m,n}=[];
        end
    end
end

% start retrieval the ground truth pixels
%mat_counter=[];

for patch_size=ps_max:ps_step:ps_min
    [img_h,candi_old,phi_old]=SR_deArtifact(img_o,patch_size,img_hPre,search_radius,candi,phi,ps_skip,ps_step,mask_label);
    
%     mat_counter=[mat_counter;
%         patch_size counter];
    img_h(mask_label==0)=bic_full(mask_label==0);
    % -----------------------------------------------------
    clear candi phi;
    for ppss=ps_min:1:patch_size-1
        k=ppss-ps_skip;
        for m=1:nrow
            for n=1:ncol
                candi{k,m,n}=candi_old{k,m,n};
                phi{k,m,n}=phi_old{k,m,n};
            end
        end
    end
    
    
    k=patch_size-ps_skip;
    for m=1:nrow
        for n=1:ncol
            candi{k,m,n}=[];
            phi{k,m,n}=[];
        end
    end
    
    clear candi_old phi_old;
    
    % -----------------------------------------------------
%     f1=figure;
%     imshow(img_h,'Border','tight','initialMagnification',100);
%     axis off
%     axis image
%     psnr_now=psnr(255*img_gt,255*img_h);
%     ssim_now=ssim(255*img_gt,255*img_h);
%     %psnr_now=psnr(255*img_gt(index_s:end-index_e,index_s:end-index_e),255*img_h(index_s:end-index_e,index_s:end-index_e));
%     file_results=strcat(address_results,'our_',num2str(i),'_level_',num2str(level),'_h_ps',num2str(patch_size),'_',num2str(psnr_now),'_',num2str(ssim_now),'.eps');
%     saveas(f1,file_results,'psc2');
%     file_results=strcat(address_results,'our_',num2str(i),'_level_',num2str(level),'_h_ps',num2str(patch_size),'_',num2str(psnr_now),'_',num2str(ssim_now),'.bmp');
%     imwrite(img_h,file_results,'bmp');
    
    
    % --------------------------------------------------------------
    img_hPre=img_h;
    close all;
end

e = cputime-t;
%time_our=e;


close all;

