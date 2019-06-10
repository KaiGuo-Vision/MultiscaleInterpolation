function w_o=calWeight(img_o)

fx=[0  0  0;
    1  0 -1;
    0  0  0];
fy=[0  1  0;
    0  0  0;
    0 -1  0];


ox=conv2(img_o,fx,'same');
oy=conv2(img_o,fy,'same');

om=sqrt(ox.^2+oy.^2);
om(om==0)=0.003;
w_o=om;