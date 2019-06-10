function img_gp=BilateralTV_fast(image)

alpha=0.6;
w=2;

%[nrow,ncol] = size(image);


% [X,Y] = meshgrid(-w:w,-w:w);
% G = alpha.^(abs(X)+abs(Y));

%B=zeros(size(image));
% initialize the matrix of mask
img_stand=zeros(size(image,1)+2*w,size(image,2)+2*w);
img_stand(w+1:end-w,w+1:end-w)=ones(size(image));

img_gp=zeros(size(image));

for i=-w:w
    for j=-w:w
        % shift the image
        img_temp=circshift(image,[i,j]);
        % shift the mask
        img_stand2=circshift(img_stand,[i,j]);
        img_label=img_stand2(w+1:end-w,w+1:end-w);
        
        val_eff=alpha.^(abs(i)+abs(j));
        img_gp=img_gp+val_eff*img_label.*sign(image-img_temp);
    end
end




% 
% img_gp=zeros(size(image));
% for i = 1:nrow
%     for j = 1:ncol
%         % Extract local region.
%         iMin = max(i-w,1);
%         iMax = min(i+w,nrow);
%         jMin = max(j-w,1);
%         jMax = min(j+w,ncol);
%         I = image(iMin:iMax,jMin:jMax);
%         
%         %pmask=mask(iMin:iMax,jMin:jMax);
% 
%         % Calculate bilateral filter response.
%         F = G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
%         
%         %F=F.*pmask;
%         
%         %F(i-iMin+1,j-jMin+1)=0;
%         
%         %F=F./(sum(F(:)));
%         
%         %B(i,j)=sum(F(:).*sign(image(i,j)-I(:)));
%         
%         %img_gp(iMin:iMax,jMin:jMax)=img_gp(iMin:iMax,jMin:jMax)-F.*sign(image(i,j)-I);
%         % total variation l2 norm
%         %img_gp(iMin:iMax,jMin:jMax)=img_gp(iMin:iMax,jMin:jMax)-F.*(image(i,j)-I);
%         
%         img_gp(i,j)=img_gp(i,j)+sum(F(:).*sign(image(i,j)-I(:)));
%         
% %         B(i,j) = sum(F(:).*I(:))/sum(F(:));
%     end
% end
% 
% %img_gp=B; % img_gp is the gradient of prior knowledge