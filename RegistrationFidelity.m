function [candi,phi]=RegistrationFidelity(img_o,patch_size,ps_skip,ps_step,img_hPre,search_radius,candi,phi,mask_label)




% candi_num1=8;
% candi_num=8;
% define the Gaussian mask for the patch distance calculation
%sigma_g=25;
sigma_g=0.5*patch_size;

% the mask of ground truth pixels, that will be used to calculate the M-L2
% distance
tt_o=ones(size(img_o));
tt_r=zeros(size(img_o));
mask=joinImage(tt_o,tt_r,tt_r,tt_r);


[nrow,ncol]=size(img_hPre);

% ps_min=ps_skip+1;
for ps=patch_size:ps_step:ps_skip+1
    fprintf(1,'\n Finding candidates, patch size %6d in level %6d \n',ps,patch_size);
    ps_index=ps-ps_skip;
    
    % parameters setting at current patch size
    if mod(ps,2)==0
        patch_halfL=(ps)/2-1;
        patch_halfR=(ps)/2;
    else
        patch_halfL=(ps-1)/2;
        patch_halfR=(ps-1)/2;
    end
    wL=patch_halfL;
    wR=patch_halfR;
    [X,Y] = meshgrid(-wL:wR,-wL:wR);
    G = exp(-(X.^2+Y.^2)/(2*sigma_g^2));


    for i=1:nrow
        for j=1:ncol
            if mask_label(i,j)==2
                % start retrieval
                imin=max(i-patch_halfL,1);
                imax=min(i+patch_halfR,nrow);
                jmin=max(j-patch_halfL,1);
                jmax=min(j+patch_halfR,ncol);

                p_mask=mask(imin:imax,jmin:jmax);



                p_G=G((imin:imax)-i+wL+1,(jmin:jmax)-j+wL+1);
                p_F=p_mask.*p_G;


                % -------------------------------------------------------------
                p_test=img_hPre(imin:imax,jmin:jmax);

                pdim=size(p_test,1)*size(p_test,2);
                vec_mask=reshape(p_F,pdim,1);
                vec_test=reshape(p_test,pdim,1);

                % define the patch size model
                pT=i-imin;
                pB=imax-i;
                pL=j-jmin;
                pR=jmax-j;

                % define the search range
                pm_min=max(i-search_radius,pT+1);
                pm_max=min(i+search_radius,nrow-pB);
                pn_min=max(j-search_radius,pL+1);
                pn_max=min(j+search_radius,ncol-pR);

                % -------------------------------------------------------------



                %candi_old=candi{ps_index,i,j};
                phi_old=phi{ps_index,i,j};

                if isempty(phi_old)

                    pixPool=[];
                    val_temp=[];

                    for m=pm_min:pm_max
                        for n=pn_min:pn_max

                            if mask(m,n)==1
                                % extract the patch in img_o

                                patch_o=img_hPre(m-pT:m+pB,n-pL:n+pR);
                                vec_o=reshape(patch_o,pdim,1);

                                pixPool=[pixPool;
                                    img_hPre(m,n)];

                                val_md=sqrt(sum((vec_mask.*vec_test-vec_mask.*vec_o).^2)); % the mask distance
                                val_temp=[val_temp;
                                    val_md];
                            end
                        end
                    end


                    candi{ps_index,i,j}=pixPool;
                    phi{ps_index,i,j}=val_temp;
                    
                    clear phi_old pixPool val_temp;
                    
                else
                    
                    val_temp=[];

                    for m=pm_min:pm_max
                        for n=pn_min:pn_max

                            if mask(m,n)==1
                                % extract the patch in img_o

                                patch_o=img_hPre(m-pT:m+pB,n-pL:n+pR);
                                vec_o=reshape(patch_o,pdim,1);
                                
                                clear patch_o;
                                
                                val_md=sqrt(sum((vec_mask.*vec_test-vec_mask.*vec_o).^2)); % the mask distance
                                val_temp=[val_temp;
                                    val_md];
                            end
                        end
                    end
                    %candi{ps_index,i,j}=pixPool;
                    phi{ps_index,i,j}=min(phi_old,val_temp);
                    clear phi_old val_temp;
                end

            end
        end
    end
end

