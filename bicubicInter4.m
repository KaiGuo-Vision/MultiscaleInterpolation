function [img_r,img_d,img_rd,img_full]=bicubicInter4(img_o)

[nrow,ncol]=size(img_o);

[Xcoarse, Ycoarse]=meshgrid(1:ncol,1:nrow);
[Xfine,Yfine]= meshgrid(linspace(1,ncol,ncol*2-1), linspace(1,nrow,nrow*2-1));

DataCoarse = img_o;

DataBicubicFine = interp2(Xcoarse,Ycoarse, DataCoarse, Xfine, Yfine, 'bicubic');

temp=2*((9/16)*DataBicubicFine(end,:)-(1/16)*DataBicubicFine(end-2,:));
DataBicubicFine=[DataBicubicFine;
                 temp];
             
temp=2*((9/16)*DataBicubicFine(:,end)-(1/16)*DataBicubicFine(:,end-2));
DataBicubicFine=[DataBicubicFine temp];
DataBicubicFine(DataBicubicFine>1)=1;
DataBicubicFine(DataBicubicFine<0)=0;


blur_o=zeros(nrow,ncol);
img_r=zeros(nrow,ncol);
img_d=zeros(nrow,ncol);
img_rd=zeros(nrow,ncol);

for i=1:nrow
    for j=1:ncol
%         blur_o(i,j)=DataBicubicFine((i-1)*2+1,(j-1)*2+1);
        img_r(i,j)=DataBicubicFine((i-1)*2+1,(j-1)*2+2);
        img_d(i,j)=DataBicubicFine((i-1)*2+2,(j-1)*2+1);
        img_rd(i,j)=DataBicubicFine((i-1)*2+2,(j-1)*2+2);
    end
end
img_full=DataBicubicFine;
% figure;
% imshow(DataBicubicFine,[]);
% 
% 
%     tmp_h=imresize(img_o,2,'bicubic');
%     figure;
%     imshow(tmp_h,[]);
