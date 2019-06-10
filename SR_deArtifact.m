function [img_h,candi,phi]=SR_deArtifact(img_o,patch_size,img_hPre,search_radius,candi,phi,ps_skip,ps_step,mask_label)


[candi,phi]=RegistrationFidelity(img_o,patch_size,ps_skip,ps_step,img_hPre,search_radius,candi,phi,mask_label);
img_h = srImage(img_o,patch_size,img_hPre,candi,phi,ps_skip,mask_label);