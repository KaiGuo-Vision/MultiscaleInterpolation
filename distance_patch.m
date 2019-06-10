function pro=distance_patch(p_patch,refP1,refP2,xmin,xmax,xstep,nc1,nc2)

[nrow,ncol]=size(p_patch);




% when patch size is 1
valSize=1;
valSkip=valSize-1;
valDim=valSize*valSize;

pro1=0;
for i=1:nrow-valSkip
    for j=1:ncol-valSkip
        p_vec=reshape(p_patch(i:i+valSkip,j:j+valSkip),valDim,1);
        
        refMat=refP1{i,j};
        nref=size(refMat,2);
        
        difMat=abs(repmat(p_vec,1,nref)-refMat);
        
        [C,I]=min(difMat);
        
        pro_index=round(1+(C-xmin)/xstep);
        
        pro1=pro1+nc1(pro_index);
    end
end

pro1=pro1/((nrow-valSkip)*(ncol-valSkip));
% when patch size is 2
valSize=2;
valSkip=valSize-1;
valDim=valSize*valSize;

pro2=0;
for i=1:nrow-valSkip
    for j=1:ncol-valSkip
        p_vec=reshape(p_patch(i:i+valSkip,j:j+valSkip),valDim,1);
        
        refMat=refP2{i,j};
        nref=size(refMat,2);
        
        
        difMat=abs(repmat(p_vec,1,nref)-refMat);
        
        difMat=sum(difMat)/valDim;
        
        [C,I]=min(difMat);
        
        pro_index=round(1+(C-xmin)/xstep);
        
        pro2=pro2+nc2(pro_index);
    end
end
pro2=pro2/((nrow-valSkip)*(ncol-valSkip));


pro=pro1+pro2;
