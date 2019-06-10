function img_quant=quantImage(img_full,img_o)


pixel_radius=3;
[nrow,ncol]=size(img_full);
[orow,ocol]=size(img_o);

img_quant=img_full;

fprintf(1,'\n Start quantify the image based on LR image, radius is %4d . \n',pixel_radius);
for i=1:nrow
    for j=1:ncol
        
        pixel_full=img_full(i,j);
        
        oi=round(i/2);
        oj=round(j/2);
        
        val_temp=[];
        mat_temp=[];
        for m=max(oi-pixel_radius,1):min(oi+pixel_radius,orow)
            for n=max(oj-pixel_radius,1):min(oj+pixel_radius,ocol)

                val_temp=[val_temp;
                    (pixel_full-img_o(m,n))^2];
                mat_temp=[mat_temp;
                          img_o(m,n)];
            end
        end
        
        [C,I]=min(val_temp);
        img_quant(i,j)=mat_temp(I);
    end
end