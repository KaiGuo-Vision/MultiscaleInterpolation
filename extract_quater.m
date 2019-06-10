function [img_o, img_r, img_d, img_rd]=extract_quater(img_hr)

[num_row,num_col]=size(img_hr);
img_o=zeros(num_row/2,num_col/2);
img_r=zeros(num_row/2,num_col/2);
img_d=zeros(num_row/2,num_col/2);
img_rd=zeros(num_row/2,num_col/2);

for i=1:(num_row/2)
    for j=1:(num_col/2)
        img_o(i,j)=img_hr((i-1)*2+1,(j-1)*2+1);
        img_r(i,j)=img_hr((i-1)*2+1,(j-1)*2+2);
        img_d(i,j)=img_hr((i-1)*2+2,(j-1)*2+1);
        img_rd(i,j)=img_hr((i-1)*2+2,(j-1)*2+2);
    end
end