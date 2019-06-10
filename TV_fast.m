function img_gp=TV_fast(image)

w=1;
% initialize the matrix of mask
img_stand=zeros(size(image,1)+2*w,size(image,2)+2*w);
img_stand(w+1:end-w,w+1:end-w)=ones(size(image));

img_gp=zeros(size(image));

% --------------------------------------------------
i=0;
j=-1;
% shift the image
img_temp=circshift(image,[i,j]);
% shift the mask
img_stand2=circshift(img_stand,[i,j]);
img_label=img_stand2(w+1:end-w,w+1:end-w);
img_gp=img_gp+img_label.*sign(image-img_temp);

% --------------------------------------------------
i=0;
j=1;
% shift the image
img_temp=circshift(image,[i,j]);
% shift the mask
img_stand2=circshift(img_stand,[i,j]);
img_label=img_stand2(w+1:end-w,w+1:end-w);
img_gp=img_gp+img_label.*sign(image-img_temp);

% --------------------------------------------------
i=-1;
j=0;
% shift the image
img_temp=circshift(image,[i,j]);
% shift the mask
img_stand2=circshift(img_stand,[i,j]);
img_label=img_stand2(w+1:end-w,w+1:end-w);
img_gp=img_gp+img_label.*sign(image-img_temp);

% --------------------------------------------------
i=1;
j=0;
% shift the image
img_temp=circshift(image,[i,j]);
% shift the mask
img_stand2=circshift(img_stand,[i,j]);
img_label=img_stand2(w+1:end-w,w+1:end-w);
img_gp=img_gp+img_label.*sign(image-img_temp);