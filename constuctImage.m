function img_highResolution=constuctImage(img_o,candi_r,candi_d,candi_rd,phi_r,phi_d,phi_rd,img_gt,fpatch_size)
% ---------------------------------------------------------------------
% parameter setting and models loading
skip_wid=fpatch_size-1;
full_skipWid=fpatch_size*2-1;
full_patchsize=fpatch_size*2;

[nrow,ncol]=size(img_o);
p_nrow=nrow-skip_wid;
p_ncol=ncol-skip_wid;



% plan 2
mat_one=ones(size(img_o));
mat_zero=zeros(size(img_o));
mask_full=joinImage(mat_one,2*mat_one,3*mat_one,4*mat_one);


dmask1=[0 1 0;
        1 0 1;
        0 1 0]; % the mask of diamond in patch
vmask1=[0 0 0;
        0 1 0;
        0 0 0];

dmask2=[1 0 1;
        0 0 0;
        1 0 1]; % the mask of diamond in patch
vmask2=[0 0 0;
        0 1 0;
        0 0 0];





for i=1:p_nrow
    pi=i;   % the index for img_o
    pp_i=2*i-1; % the index for whole image
    fprintf(1,'\n Evaluate probability, Row %4d',i);
    for j=1:p_ncol
        pj=j; % the index for img_o
        pp_j=2*j-1; % the index for whole image
        % the patch of bicubic interpolation
        p_gt=img_gt(pp_i:pp_i+full_skipWid,pp_j:pp_j+full_skipWid);
        % the patch of steerable filter's direction
        pmask=mask_full(pp_i:pp_i+full_skipWid,pp_j:pp_j+full_skipWid);
        %pmask=pmask(p_skip+1:end-p_skip,p_skip+1:end-p_skip);
        patch_o=img_o(pi:pi+skip_wid,pj:pj+skip_wid);
      
        pEn_o=img_o(max(pi,1):min(pi+skip_wid+1,nrow),max(pj,1):min(pj+skip_wid+1,ncol));
        
        [pe_row,pe_col]=size(pEn_o);
        % next next step: compare the linear combination coefficients in
        % square, it also need the nearest patch search, so as to calculate
        % the mask of candidates
        
        % calculate the coefficient 'b' for r sub_image
        matD1=[];
        matV1=[];
        matD2=[];
        matV2=[];
        for m=1:pe_row-3
            pm=1+m;
            for n=1:pe_col-2
                pn=1+n;
                subp_temp=pEn_o(pm-1:pm+1,pn-1:pn+1);
                vec_d1=subp_temp(dmask1>0);
                vec_v1=subp_temp(vmask1>0);
                
                vec_d2=subp_temp(dmask2>0);
                vec_v2=subp_temp(vmask2>0);
                
                matD1=[matD1;
                       vec_d1'];
                matV1=[matV1;
                       vec_v1];
                matD2=[matD2;
                       vec_d2'];
                matV2=[matV2;
                       vec_v2];
            end 
        end
        mat_b1_r=inv(matD1'*matD1)*matD1'*matV1;
        label_inv1_r=det(matD1'*matD1);
        mat_b2_r=inv(matD2'*matD2)*matD2'*matV2;
        label_inv2_r=det(matD2'*matD2);
        
        % calculate the coefficient 'b' for d sub_image
        matD1=[];
        matV1=[];
        matD2=[];
        matV2=[];
        for m=1:pe_row-2
            pm=1+m;
            for n=1:pe_col-3
                pn=1+n;
                subp_temp=pEn_o(pm-1:pm+1,pn-1:pn+1);
                vec_d1=subp_temp(dmask1>0);
                vec_v1=subp_temp(vmask1>0);
                
                vec_d2=subp_temp(dmask2>0);
                vec_v2=subp_temp(vmask2>0);
                
                matD1=[matD1;
                       vec_d1'];
                matV1=[matV1;
                       vec_v1];
                matD2=[matD2;
                       vec_d2'];
                matV2=[matV2;
                       vec_v2];
            end 
        end
        mat_b1_d=inv(matD1'*matD1)*matD1'*matV1;
        label_inv1_d=det(matD1'*matD1);
        mat_b2_d=inv(matD2'*matD2)*matD2'*matV2;
        label_inv2_d=det(matD2'*matD2);
        
        % calculate the coefficient 'b' for x sub_image
        matD1=[];
        matV1=[];
        matD2=[];
        matV2=[];
        for m=1:pe_row-2
            pm=1+m;
            for n=1:pe_col-2
                pn=1+n;
                subp_temp=pEn_o(pm-1:pm+1,pn-1:pn+1);
                vec_d1=subp_temp(dmask1>0);
                vec_v1=subp_temp(vmask1>0);
                
                vec_d2=subp_temp(dmask2>0);
                vec_v2=subp_temp(vmask2>0);
                
                matD1=[matD1;
                       vec_d1'];
                matV1=[matV1;
                       vec_v1];
                matD2=[matD2;
                       vec_d2'];
                matV2=[matV2;
                       vec_v2];
            end 
        end
        mat_b1_x=inv(matD1'*matD1)*matD1'*matV1;
        label_inv1_x=det(matD1'*matD1);
        mat_b2_x=inv(matD2'*matD2)*matD2'*matV2;
        label_inv2_x=det(matD2'*matD2);
        
        % extract the candidates
        pset_r=candi_r{i,j};
        pset_d=candi_d{i,j};
        pset_x=candi_rd{i,j};
        
        % Initialize the value of fidelity
        fidelity_r=phi_r{i,j};
        fidelity_d=phi_d{i,j};
        fidelity_x=phi_rd{i,j};

        [pdim,num_r]=size(pset_r);
        [pdim,num_d]=size(pset_d);
        [pdim,num_x]=size(pset_x);

        num_hr=num_r*num_d*num_x;
        pset_hr=zeros(full_patchsize,full_patchsize,num_hr);
        
        % -----------------------------------------------------------------
        % we have finished the mask of r d and x, the next step is to
        % calculate the linear combination MSE of diamond in r d and x,
        
        % set the denominator
        deno1=3;
        deno2=3;
        %-----------------------
        conB1_r=zeros(num_r,1);
        conB2_r=zeros(num_r,1);
        for k=1:num_r
            ptemp=reshape(pset_r(:,k),fpatch_size,fpatch_size);
            matD1=[];
            matV1=[];
            matD2=[];
            matV2=[];
            for m=1:fpatch_size-2
                pm=1+m;
                for n=1:fpatch_size-2
                    pn=1+n;
                    subp_temp=ptemp(pm-1:pm+1,pn-1:pn+1);
                    vec_d1=subp_temp(dmask1>0);
                    vec_v1=subp_temp(vmask1>0);
                    vec_d2=subp_temp(dmask2>0);
                    vec_v2=subp_temp(vmask2>0);

                    matD1=[matD1;
                        vec_d1'];
                    matV1=[matV1;
                        vec_v1];
                    matD2=[matD2;
                        vec_d2'];
                    matV2=[matV2;
                        vec_v2];
                end
            end
            conB1_r(k)=sum(abs(matD1*mat_b1_r-matV1))/((fpatch_size-2)^2);
            conB2_r(k)=sum(abs(matD2*mat_b2_r-matV2))/((fpatch_size-2)^2);
        end
        if label_inv1_r==0
            conB1_r=zeros(num_r,1);
            deno1=deno1-1;
        end
        if label_inv2_r==0
            conB2_r=zeros(num_r,1);
            deno2=deno2-1;
        end
        
        
        conB1_d=zeros(num_d,1);
        conB2_d=zeros(num_d,1);
        for k=1:num_d
            ptemp=reshape(pset_d(:,k),fpatch_size,fpatch_size);
            matD1=[];
            matV1=[];
            matD2=[];
            matV2=[];
            for m=1:fpatch_size-2
                pm=1+m;
                for n=1:fpatch_size-2
                    pn=1+n;
                    subp_temp=ptemp(pm-1:pm+1,pn-1:pn+1);
                    vec_d1=subp_temp(dmask1>0);
                    vec_v1=subp_temp(vmask1>0);
                    vec_d2=subp_temp(dmask2>0);
                    vec_v2=subp_temp(vmask2>0);

                    matD1=[matD1;
                        vec_d1'];
                    matV1=[matV1;
                        vec_v1];
                    matD2=[matD2;
                        vec_d2'];
                    matV2=[matV2;
                        vec_v2];
                end
            end
            conB1_d(k)=sum(abs(matD1*mat_b1_d-matV1))/((fpatch_size-2)^2);
            conB2_d(k)=sum(abs(matD2*mat_b2_d-matV2))/((fpatch_size-2)^2);
        end
        if label_inv1_d==0
            conB1_d=zeros(num_d,1);
            deno1=deno1-1;
        end
        if label_inv2_d==0
            conB2_d=zeros(num_d,1);
            deno2=deno2-1;
        end
        
        
        
        
        
        conB1_x=zeros(num_x,1);
        conB2_x=zeros(num_x,1);
        for k=1:num_x
            ptemp=reshape(pset_x(:,k),fpatch_size,fpatch_size);
            matD1=[];
            matV1=[];
            matD2=[];
            matV2=[];
            for m=1:fpatch_size-2
                pm=1+m;
                for n=1:fpatch_size-2
                    pn=1+n;
                    subp_temp=ptemp(pm-1:pm+1,pn-1:pn+1);
                    vec_d1=subp_temp(dmask1>0);
                    vec_v1=subp_temp(vmask1>0);
                    vec_d2=subp_temp(dmask2>0);
                    vec_v2=subp_temp(vmask2>0);

                    matD1=[matD1;
                        vec_d1'];
                    matV1=[matV1;
                        vec_v1];
                    matD2=[matD2;
                        vec_d2'];
                    matV2=[matV2;
                        vec_v2];
                end
            end
            conB1_x(k)=sum(abs(matD1*mat_b1_x-matV1))/((fpatch_size-2)^2);
            conB2_x(k)=sum(abs(matD2*mat_b2_x-matV2))/((fpatch_size-2)^2);
        end
        if label_inv1_x==0
            conB1_x=zeros(num_x,1);
            deno1=deno1-1;
        end
        if label_inv2_x==0
            conB2_x=zeros(num_x,1);
            deno2=deno2-1;
        end
        
        
        
        deno1(deno1==0)=1;
        deno2(deno2==0)=1;
        % -----------------------------------------------------------------
        counter=0;
        %proSte2=[];

        
        con_phi=[];
        con_B1=[];
        con_B2=[];
        
        for m=1:num_r
            patch_r=reshape(pset_r(:,m),fpatch_size,fpatch_size);
            valFid_r=fidelity_r(m);
            valB1_r=conB1_r(m);
            valB2_r=conB2_r(m);
            for n=1:num_d
                patch_d=reshape(pset_d(:,n),fpatch_size,fpatch_size);
                valFid_d=fidelity_d(n);
                valB1_d=conB1_d(n);
                valB2_d=conB2_d(n);
                for k=1:num_x
                    counter=counter+1;

                    patch_x=reshape(pset_x(:,k),fpatch_size,fpatch_size);
                    valFid_x=fidelity_x(k);
                    valB1_x=conB1_x(k);
                    valB2_x=conB2_x(k);
                    % construct the high-resolution patch
                    p_hr=constructPatch(patch_o,patch_r,patch_d,patch_x);
                    pset_hr(:,:,counter)=p_hr;
                    
                    con_phi=[con_phi;
                        (valFid_r+valFid_d+valFid_x)/3];
                    con_B1=[con_B1;
                            (valB1_r+valB1_d+valB1_x)/deno1];
                    con_B2=[con_B2;
                            (valB2_r+valB2_d+valB2_x)/deno2];
                end
            end
        end
        % Calculate the probability of each high-resolution patch
        
        % ----------------------------------------------------------
        % diagonal prior 2
        pro_hr=zeros(num_hr,1);
        for p=1:num_hr
            patch_candi=pset_hr(:,:,p);
            pro_hr(p) =BilateralPrior(patch_candi);%val_mse;%%evaluate_foe_log(model, pset_hr(:,:,p));%%-1*sum(sum((p_gt-pset_hr(:,:,p)).^2)) %calPS_E(patch_candi);% BilateralPriorNear(patch_candi);%+std(patch_candi(:)); %% %
        end

        
        proCon=1*con_phi+0.4*pro_hr-2*con_B1-2*con_B2;% -1*pro_hr3


        % Extract the final top candidates
        [C,I]=max(proCon);
        Pro(i,j)=exp(C);
        image{i,j}=pset_hr(:,:,I);

    end
end


% -------------------------------------------------------------------------
% start to construct the final image

fprintf(1,'\n Best high-resolution patches have been found, now construct the final image \n');

img_h=zeros(nrow*2,ncol*2);
coeff=zeros(nrow*2,ncol*2);
p1=ones(full_patchsize,full_patchsize);

Pro_temp=Pro;
Pro_temp(Pro_temp<=0)=0.01;

for i=1:p_nrow
    pi=2*i-1;
    for j=1:p_ncol
        pj=2*j-1;
        img_h(pi:pi+full_skipWid,pj:pj+full_skipWid)=img_h(pi:pi+full_skipWid,pj:pj+full_skipWid)+image{i,j}*Pro_temp(i,j);
        coeff(pi:pi+full_skipWid,pj:pj+full_skipWid)=coeff(pi:pi+full_skipWid,pj:pj+full_skipWid)+p1*Pro_temp(i,j);
    end
end
img_highResolution=img_h./coeff;

% maintain the img_o values
for i=1:nrow
    for j=1:ncol
        img_highResolution(2*i-1,2*j-1)=img_o(i,j);
    end
end
