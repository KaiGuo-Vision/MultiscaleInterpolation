function [xmin,xmax,xstep,ncount]=disHis(dif_temp,xmin,xmax,xstep)

[m,n]=size(dif_temp);
mn=m*n;
vec_diffx1=reshape(dif_temp,mn,1);

xBar=xmin:xstep:xmax;

figure;
[ncount,xout]=hist(vec_diffx1,xBar);
% ncount=log(ncount);
plot(xout,ncount,'LineWidth',2);
axis([xmin xmax 0 2]);