%This code can only be used for research purpose only. 
%Please cite the following paper if you use it:

%L. Zhang and X. Wu,
%“An edge guided image interpolation algorithm via directional filtering and data fusion,”
%IEEE Trans. on Image Processing, vol. 15, pp. 2226-2238, Aug. 2006.

% Note that this code was not efficiently written but for clarity of the
% proposed algorithm. So it may take several minutes to run an image.

function A=esintp(I)
%%%%%process A%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n,m]=size(I);
n=2*n;m=2*m;
A=zeros(n,m);

A(1:2:n,1:2:m)=I;
Ax=A;Ay=A;
f=[-1/16 9/16 9/16 -1/16];
for i=4:2:n-4
   for j=4:2:m-4
      x=[A(i-3,j-3) A(i-1,j-1) A(i+1,j+1) A(i+3,j+3)];
      y=[A(i+3,j-3) A(i+1,j-1) A(i-1,j+1) A(i-3,j+3)];
      Ax(i,j)=sum(x.*f);
      Ay(i,j)=sum(f.*y);
   end
end

for i=4:2:n-4
   for j=4:2:m-4
      zx=[Ax(i-2,j-2) Ax(i-1,j-1) Ax(i,j) Ax(i+1,j+1) Ax(i+2,j+2)];
      zy=[Ay(i+2,j-2) Ay(i+1,j-1) Ay(i,j) Ay(i-1,j+1) Ay(i-2,j+2)];

      x=[A(i-1,j-1) A(i+1,j+1) A(i+1,j-1) A(i-1,j+1)];
      mx=mean(x);
      
      px=sum((x-mx).^2)/3+0.1;
      pzx=sum((zx-mx).^2)/4+0.1;
      pzy=sum((zy-mx).^2)/4+0.1;
      
      pv1=pzx-px;pv1=max(0.01,pv1);
      pv2=pzy-px;pv2=max(0.01,pv2);
      
      R=[pv1 0;0 pv2];
      y=[Ax(i,j) Ay(i,j)]';
      H=[1;1];
      A(i,j)=mx+px*H'*(H*px*H'+R)^(-1)*(y-H*mx);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   Ax=A;Ay=A;
   f=[-1/16 0 9/16 1 9/16 0 -1/16];
 
   Ax=conv2(Ax,f);
   Ax=Ax(:,4:m+3);
   Ay=conv2(Ay,f');
   Ay=Ay(4:n+3,:);
   c=1.5;
   h=[-1 5 5 -1];h=h/sum(h);
for i=5:2:n-5
   for j=4:2:m-4
      y=[Ax(i-2,j) A(i-1,j) A(i+1,j) Ax(i+2,j)];
      my=sum(h.*y);
      x=[Ax(i,j-2) Ax(i,j-1) Ax(i,j) Ax(i,j+1) Ax(i,j+2)];
      vx=cov(x)+0.1;
      vy=c*cov([y my])+0.1;
      A(i,j)=(Ax(i,j)*vy+my*vx)/(vx+vy);
   end
end
for i=4:2:n-4
   for j=5:2:m-5
      x=[Ay(i,j-2) A(i,j-1) A(i,j+1) Ay(i,j+2)];
      mx=sum(h.*x);
      y=[Ay(i-2,j) Ay(i-1,j) Ay(i,j) Ay(i+1,j) Ay(i+2,j)];
      vx=c*cov([x mx])+0.1;
      vy=cov(y)+0.1;
      A(i,j)=(mx*vy+Ay(i,j)*vx)/(vx+vy);
   end
end

return;

