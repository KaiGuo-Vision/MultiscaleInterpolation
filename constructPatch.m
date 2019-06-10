function patch_hr=constructPatch(patch_o,patch_r,patch_d,patch_x)

[nrow,ncol]=size(patch_o);

patch_hr=zeros(nrow*2,ncol*2);

for i=1:nrow
    for j=1:ncol
        patch_hr(2*i-1,2*j-1)=patch_o(i,j);
        patch_hr(2*i-1,2*j)=patch_r(i,j);
        patch_hr(2*i,2*j-1)=patch_d(i,j);
        patch_hr(2*i,2*j)=patch_x(i,j);
    end
end
