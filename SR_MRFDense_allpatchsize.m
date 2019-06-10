function image_H=SR_MRFDense_allpatchsize(phi,candi,p_nrow,p_ncol,fpatch_size)

%load final_belief b_nb2p;
%load candidate phi candi_l candi_h;

wid=fpatch_size-1; %1
% construct the optimal image use these patches
fprintf(1,'\n construct the optimal image use these optimal patches\n');

img_h=zeros(p_nrow+wid,p_ncol+wid);
coeff=zeros(p_nrow+wid,p_ncol+wid);


p1=ones(fpatch_size,fpatch_size);



for i=1:p_nrow
    for j=1:p_ncol
        
        pi=i;
        pj=j;
        
        %if mod(pi,2)==0 && mod(pj,2)==0
            ph=reshape(candi{i,j},fpatch_size,fpatch_size);
            val_h=exp(-1*phi{i,j});

            img_h(pi:pi+wid,pj:pj+wid)=img_h(pi:pi+wid,pj:pj+wid)+val_h.*ph;
            coeff(pi:pi+wid,pj:pj+wid)=coeff(pi:pi+wid,pj:pj+wid)+val_h.*p1;
        %end
        
    end
end
coeff(coeff==0)=1;

image_H=img_h./coeff;
