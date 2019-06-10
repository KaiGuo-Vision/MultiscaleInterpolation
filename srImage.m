function img_h = srImage(img_o,patch_size,img_hPre,candi,phi,ps_skip,mask_label)

[nrow,ncol]=size(img_o);

sigma_d=0.12*(patch_size/5)^2;


ps_index=patch_size-ps_skip;

tt_o=ones(size(img_o));
tt_x=zeros(size(img_o));
mask=joinImage(tt_o,tt_x,tt_x,tt_x);

mask_gradient=zeros(size(mask));
mask_gradient(mask_label==2)=1;


img_h=img_hPre;
% figure;
% imshow(img_h,[]);

% fprintf(1,'psnr: %10.6f', psnr(255*img_gt,255*img_h));
% data fidelity term and prior knowledge, L2 norm used
% lambda=0.009;


% the weighting parameter
lambda=0.002; % previous value is 0.002
% the step size of updating
eta=0.05; % previous value is 0.007
counter=1;
candi_num=8;%+round(0*patch_size/ps_max);
% retrieve best candidates from candi through phi
for i=1:nrow*2
    for j=1:ncol*2
        if mask_label(i,j)==2
            val_can=[];
            pix_can=[];
            
            phi_temp=phi{ps_index,i,j};
            candi_temp=candi{ps_index,i,j};
            for k=1:candi_num
                [C,I]=min(phi_temp);
                val_can=[val_can;
                    C];
                pix_can=[pix_can;
                    candi_temp(I)];
                
                phi_temp(I)=10000;
            end
            
            phi_current{i,j}=val_can;
            candi_current{i,j}=pix_can;
        end
    end
end

% use the mean value to initialize the HR image
% calculate the numerator
img_numerator=img_hPre;
for i=1:nrow*2
    for j=1:ncol*2
        if mask_label(i,j)==2
            %val_pix=img_h(i,j);
            
            phi_temp=phi_current{i,j};
            candi_temp=candi_current{i,j};
            
            num_candi=size(phi_temp,1);
            for k=1:num_candi
                phi_temp(k) = exp(-phi_temp(k)^2/(2*sigma_d^2))/(sqrt(2*3.14159*(sigma_d^2)));
            end
            
            weight=phi_temp./sum(phi_temp);
            
            %weight=phi_temp;
            
            % L1 norm
            %img_gradient(i,j)=sum(weight.*sign(val_pix-candi_temp));
            
            % L2 norm
            img_numerator(i,j)=sum(weight.*candi_temp);
        end
    end
end
img_h=img_numerator;

%fprintf(1,'psnr: %10.6f', psnr(255*img_gt,255*img_h));

% start regularize to reconstruct HR image
psnr_pre=0;

while 1  
    fprintf(1,'\n MAP iteration %6d in level %6d \n',counter, patch_size);
    img_gradient=zeros(nrow*2,ncol*2);
    for i=1:nrow*2
        for j=1:ncol*2
            if mask_label(i,j)==2
                val_pix=img_h(i,j);
                
                phi_temp=phi_current{i,j};
                candi_temp=candi_current{i,j};
                %                 if size(phi_temp,1)~=size(candi_temp,1)
                %                     fprintf(1,'\n unequal size in:   row %4d, col %4d \n', i,j);
                %                 end
                
                num_candi=size(phi_temp,1);
                for k=1:num_candi
                    phi_temp(k) = exp(-phi_temp(k)^2/(2*sigma_d^2))/(sqrt(2*3.14159*(sigma_d^2)));
                end
                
                weight=phi_temp./sum(phi_temp);
                
                % L1 norm
                %img_gradient(i,j)=sum(weight.*sign(val_pix-candi_temp));
                
                % L2 norm
                img_gradient(i,j)=sum(weight.*(val_pix-candi_temp));
            end
        end
    end
    
    %img_gp=BilateralPriorMask_centerO(img_h,mask);
    %     img_gp=mask_gradient.*img_gp;
    %     img_gradient=1*img_gradient+0.15*img_gp;
    img_gp=TV_fast(img_h);
    img_gp=mask_gradient.*img_gp;
    % the previous value of 'lambda' is set as 0.002
    img_gradient=1*img_gradient+lambda*img_gp;
    
    
    %     img_hPre=img_h;
    
    % identify the condition based on second order gradient
    %     graD_now=img_gradient-gra_pre;
    
    vec_gra=lambda*img_gradient;
    val_gra=std(vec_gra(:));
    
    
    %0.00008
    %thre=0.000065+0.00000*patch_size/ps_max;
    
    
    if counter<150
        
        
        img_h=img_h-eta*img_gradient;
    
        %psnr_now=psnr(255*img_gt,255*img_h);
        
    else
        break;
    end
    counter=counter+1;
end







