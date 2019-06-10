function [candi,phi]=geneCandidateDense_allpatchsize_forAnalyze(img_o,search_radius,patch_size,bic_full,type)


filter1_num=6;
candi_num=3;

[nrow,ncol]=size(img_o);
skip_wid=patch_size-1; %
full_skipWid=skip_wid*2;
full_patchsize=patch_size*2-1;


p_nrow=nrow-patch_size+1; %
p_ncol=ncol-patch_size+1; %

fdim=patch_size*patch_size;


% the mask of ground truth pixels
tt_o=ones(size(img_o));
tt_r=zeros(size(img_o));
tt_d=zeros(size(img_o));
tt_rd=zeros(size(img_o));
mask=joinImage(tt_o,tt_r,tt_d,tt_rd);



% -------------------------------------------------------------------------
% the low-frequency of bicubic image and img_o
filter_g=fspecial('gaussian',[5 5],1.2);
bic_low=conv2(bic_full,filter_g,'same');
[img_oL, img_rL, img_dL, img_rdL]=extract_quater(bic_low);

if type=='r'
    x_skip=0;
    y_skip=1;

    [ttt1, bic_t, ttt2, ttt3]=extract_quater(bic_full);
    
    mask_c=[0 1 0 1 0 1 0;
            0 0 0 0 0 0 0;
            0 1 0 1 0 1 0;
            0 0 0 0 0 0 0;
            0 1 0 1 0 1 0;
            0 0 0 0 0 0 0;
            0 1 0 1 0 1 0];
    
    mask_c2=[1 1 1 1 1 1 1;
            0 0 0 0 0 0 0;
            1 1 1 1 1 1 1;
            0 0 0 0 0 0 0;
            1 1 1 1 1 1 1;
            0 0 0 0 0 0 0;
            1 1 1 1 1 1 1];
    
elseif type=='d'
    x_skip=1;
    y_skip=0;

    [ttt1, ttt2, bic_t, ttt3]=extract_quater(bic_full);
    
    mask_c=[0 0 0 0 0 0 0;
            1 0 1 0 1 0 1;
            0 0 0 0 0 0 0;
            1 0 1 0 1 0 1;
            0 0 0 0 0 0 0;
            1 0 1 0 1 0 1;
            0 0 0 0 0 0 0];
    mask_c2=[1 0 1 0 1 0 1;
            1 0 1 0 1 0 1;
            1 0 1 0 1 0 1;
            1 0 1 0 1 0 1;
            1 0 1 0 1 0 1;
            1 0 1 0 1 0 1;
            1 0 1 0 1 0 1];
    
elseif type=='rd'
    x_skip=1;
    y_skip=1;

    [ttt1, ttt2, ttt3, bic_t]=extract_quater(bic_full);
    
    mask_c=[0 0 0 0 0 0 0;
            0 1 0 1 0 1 0;
            0 0 0 0 0 0 0;
            0 1 0 1 0 1 0;
            0 0 0 0 0 0 0;
            0 1 0 1 0 1 0;
            0 0 0 0 0 0 0];
        
    mask_c2=[1 0 1 0 1 0 1;
            0 1 0 1 0 1 0;
            1 0 1 0 1 0 1;
            0 1 0 1 0 1 0;
            1 0 1 0 1 0 1;
            0 1 0 1 0 1 0;
            1 0 1 0 1 0 1];  
        
else
    fprintf(1,'\n type is wrong \n');
end

mask_c=reshape(mask_c,49,1);
mask_c2=reshape(mask_c2,49,1);


t_low=0.12;
t_sub=0.23;
t_full=0.36;

% threshold_patch=sqrt(fdim*threshold_pixel^2);
% threshold_sub=abs(t_subs*sqrt(ps_x^2+ps_y^2))/fdim;
% threshold_full=abs(t_full*sqrt(ps_x^2+ps_y^2))/fdim;

mat_dis=zeros(size(img_o));
for i=1:p_nrow
    fprintf(1,'\n row %4d  in geneCandidate',i);
    for j=1:p_ncol

        % extract the test image patch
        vec_t=reshape(bic_t(i:i+skip_wid,j:j+skip_wid),fdim,1);


        % the coordinate of test image patch in full_image
        pm=2*i-1+x_skip;
        pn=2*j-1+y_skip;

        p_bicLow=bic_low(pm:pm+full_skipWid,pn:pn+full_skipWid);
        vec_tL=reshape(p_bicLow,full_patchsize*full_patchsize,1);

        p_bicFull=bic_full(pm:pm+full_skipWid,pn:pn+full_skipWid);
        vec_tF=reshape(p_bicFull,full_patchsize*full_patchsize,1);
        % define the range of the search domain, based on full_image
        pm_min=max(pm-search_radius,1);
        pm_max=min(pm+search_radius,(nrow-skip_wid)*2);
        pn_min=max(pn-search_radius,1);
        pn_max=min(pn+search_radius,(ncol-skip_wid)*2);


        val_temp1=[];
        mat_temp1=[];

        val_tempL=[];
        val_tempF=[];
        val_tempO=[];
        val_tempC=[];
        % has none edges
        for m=pm_min:pm_max
            for n=pn_min:pn_max

                % check whether the patch is img_o or not
                if mask(m,n)==1
                    % calculate the coordinate in img_o
                    om=(m+1)/2;
                    on=(n+1)/2;

                    % extract the patch in img_o
                    patch_o=img_o(om:om+skip_wid,on:on+skip_wid);
                    vec_o=reshape(patch_o,fdim,1);

                    vec_oL=reshape(bic_low(m:m+full_skipWid,n:n+full_skipWid),full_patchsize*full_patchsize,1);
                    vec_oF=reshape(bic_full(m:m+full_skipWid,n:n+full_skipWid),full_patchsize*full_patchsize,1);

                    %valL=sum(abs(vec_tL-vec_oL))/(full_patchsize*full_patchsize);
                    valL=sqrt(sum((vec_tL-vec_oL).^2));
                    val_tempL=[val_tempL;
                        valL];

                    %valF=sum(abs(vec_tF-vec_oF))/(full_patchsize*full_patchsize);
                    valF=sqrt(sum((vec_tF-vec_oF).^2));
                    val_tempF=[val_tempF;
                        valF];
                    %valO=sum(abs(vec_t-vec_o))/fdim;
                    valO=sqrt(sum((vec_t-vec_o).^2));
                    val_tempO=[val_tempO;
                        valO];

                    val_temp1=[val_temp1;
                        0*valL+1*valF+0*valO];
                    mat_temp1=[mat_temp1 vec_o];
                    
                    valC=sqrt(sum((mask_c.*vec_tF-mask_c.*vec_oF).^2));
                    val_tempC=[val_tempC;
                               valC];
                end

            end
        end


        % -----------------------------------------------------------------
        % option 2
        % first filter by bicubic
        val_temp2=[];
        mat_temp2=[];

        [C,I]=min(val_temp1);
%         mat_dis(i+1,j+1)=val_tempC(I);
        
        if val_temp1(I)<=0.1
            phi{i,j}=C;
            candi{i,j}=vec_t;
        else
            for L=1:filter1_num
                [C,I]=min(val_temp1);
                p_patch=reshape(mat_temp1(:,I),patch_size,patch_size);

                val_temp2=[val_temp2;
                    -1*val_tempC(I)];
                %                 distance_patch(p_patch,refP1,refP2,xmin,xmax,xstep,nc1,nc2)];
                mat_temp2=[mat_temp2 mat_temp1(:,I)];
                val_temp1(I)=10000;
            end
            % second filter by distribution
            phi_temp=[];
            candi_temp=[];
            % find the best candidate one
            for L=1:candi_num
                [C,I]=max(val_temp2);

                candi_temp=[candi_temp mat_temp2(:,I)];
                phi_temp=[phi_temp;
                    C];
                val_temp2(I)=-inf;
            end
            % find 1 nearest patch around this keypoint
            phi{i,j}=phi_temp;
            candi{i,j}=candi_temp;
        end


    end
end



