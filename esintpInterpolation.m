function img_esintp=esintpInterpolation(img_o,img_inter)

img_o255=round(img_o*255);
img_esintp=esintp(img_o255);
img_esintp=img_esintp/255;

img_esintp(1:4,:)=img_inter(1:4,:);
img_esintp(end-3:end,:)=img_inter(end-3:end,:);
img_esintp(:,1:4)=img_inter(:,1:4);
img_esintp(:,end-3:end)=img_inter(:,end-3:end);

