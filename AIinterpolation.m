function img_h=AIinterpolation(img_o)

address_ai1='AI1\';
address_ai2='AI2\';



img=round(255*img_o);

% save it as PGM
if max(max(img))<256
    maxval = 255;
    flag = 0;
else
    maxval = 65535;
    flag = 1;
end

outputfile=strcat(address_ai1,'tmp','.pgm');
fid = fopen(outputfile, 'wb');
fprintf(fid, 'P5\n%d %d\n%d\n', size(img,2), size(img,1), maxval);
if flag==0
    fwrite(fid, img', 'uint8');
else
    fwrite(fid, img', 'uint16');
end
fclose(fid);
% interpolate it
resultfile=strcat(address_ai2,'tmp','.pgm');
mycmd=['ARInterpolation.exe',' ',outputfile,' ',resultfile];
dos(mycmd);
% calculate MSE and save it as bmp
img_result=imread(resultfile,'pgm');

img_h=double(img_result)/255;
% imgH=double(imgH);
% img_result=double(img_result);
% 
% file_results=strcat(address_results2,'img',num2str(i),'_','PSNR_',num2str(psnr(imgH, img_result)),'.bmp');
% imwrite(img_result/255,file_results,'bmp');