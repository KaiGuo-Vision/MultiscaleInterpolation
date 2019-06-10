function [candi,phi]=geneCandidateDense_allpatchsize(img_o,bic_full,search_radius,fpatch_size)


[nrow,ncol]=size(bic_full);
skip_wid=fpatch_size-1; %1
p_nrow=nrow-fpatch_size+1; % -2
p_ncol=ncol-fpatch_size+1; % -2

fdim=fpatch_size*fpatch_size;

[orow,ocol]=size(img_o);


% % the edge mask and the low-frequency component mask
% [bic_edge_temp,threshold]=edge(bic_full,'sobel');
% threshold=threshold*3/4;
% bic_edge=edge(bic_full,'sobel',threshold);
% mask_e=zeros(size(bic_full));
% mask_e(bic_edge)=1;
% % the mask for image_o
% mask1=ones(size(img_o));
% mask2=zeros(size(img_o));
% mask3=zeros(size(img_o));
% mask4=zeros(size(img_o));
% mask_o=joinImage(mask1,mask2,mask3,mask4);

% % 
% [cos1,sin1,tt1,tt2,biclow_coh,Lo,La]=structureTensorCoh(bic_full);
% [cos2,sin2,tt3,tt4,o_coh,Loo,Lao]=structureTensorCoh2(img_o);
% % [cos3,sin3,tt5,tt6,o_coh,Loo,Lao]=structureTensorCoh3(img_o);
% clear tt1 tt2 tt3 tt4;



% index_empty=0;
% Step 1: Choose top candidates based on edge information
for i=1:p_nrow
    fprintf(1,'\n row %4d  in geneCandidate',i);
    pi=i;
    for j=1:p_ncol
        pj=j;
 
%         pemask=mask_e(pi:pi+skip_wid,pj:pj+skip_wid);
%         pomask=mask_o(pi:pi+skip_wid,pj:pj+skip_wid);
        % extract test feature vector
        patch_t=bic_full(pi:pi+skip_wid,pj:pj+skip_wid);
        vec_t=reshape(patch_t,fdim,1);
        
        % extract test feature vector

%         flag_edge=sum(pemask(:));
%         flag_o=sum(pomask(:));
        
        % caculate the distance between test patch vector and it's
        % surronding patches extracted from img_o

        val_temp1=[];
        mat_temp=[];


        oi=pi;
        oj=pj;
        for m=max(oi-search_radius,1):min(oi+search_radius,orow-skip_wid)
            for n=max(oj-search_radius,1):min(oj+search_radius,ocol-skip_wid)
                
               % extract training image feature vector
                patch_o=img_o(m:m+skip_wid,n:n+skip_wid);
                vec_o=reshape(patch_o,fdim,1);


                val_temp1=[val_temp1;
                           sqrt(sum((vec_t-vec_o).^2))];
                mat_temp=[mat_temp vec_o];

            end
        end

        % pick the best one
            [C,I]=min(val_temp1);
            candi_temp=mat_temp(:,I);
            phi_temp=C;
        % find 1 nearest patch around this keypoint


        phi{i,j}=phi_temp;
        candi{i,j}=candi_temp;

    end
end

% find the best candidate

