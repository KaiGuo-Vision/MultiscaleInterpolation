function img_all=joinImage(img_o,pseudo_r,pseudo_d,pseudo_rd)

[nrow,ncol]=size(img_o);

img_all=zeros(nrow*2,ncol*2);

for i=1:nrow
    for j=1:ncol
        img_all(2*(i-1)+1,2*(j-1)+1)=img_o(i,j);
        img_all(2*(i-1)+1,2*(j-1)+2)=pseudo_r(i,j);
        img_all(2*(i-1)+2,2*(j-1)+1)=pseudo_d(i,j);
        img_all(2*(i-1)+2,2*(j-1)+2)=pseudo_rd(i,j);
    end
end