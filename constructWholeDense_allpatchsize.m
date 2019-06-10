function img_h=constructWholeDense_allpatchsize(img_gt,bic_full,img_o,search_radius,patch_size)



% img_full=conv2(img_full,filter_lap,'same')+img_full;
% patch_size=4;

fprintf(1,'\n  patch size is  %4d \n',patch_size);

[nrow,ncol]=size(bic_full);
p_nrow=nrow-patch_size+1;
p_ncol=ncol-patch_size+1;
% 
% feature_ol=fextract_olDense44(img_o,patch_size);
% feature_bl=fextract_blDense44(bic_full,patch_size);

fprintf(1,'\n geneCandidate');
[candi,phi]=geneCandidateDense_allpatchsize(img_o,bic_full,search_radius,patch_size);

img_h=SR_MRFDense_allpatchsize(phi,candi,p_nrow,p_ncol,patch_size);

% fprintf(1,'\n SR_MRF');
% pseudo_t=SR_MRF(phi,candi_high,p_nrow,p_ncol,ov,fpatch_size,type);