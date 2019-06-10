function val_mean=distance_pixel(p_patch,refPix)

[nrow,ncol]=size(p_patch);

val=0;
for i=1:nrow
    for j=1:ncol
        [C,I]=min(abs(p_patch(i,j)-refPix{i,j}));
        val=val+C;
    end
end
val_mean=val/(nrow*ncol);
