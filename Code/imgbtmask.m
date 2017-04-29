function Iout = imgbtmask(Iin)

A=rgb2gray(Iin);

[m,n]=size(A);

L=logical(A);

%Histogram calculation
H=zeros(1,256);

for i=1:m
    for j=1:n
        H(1,A(i,j)+1)=H(1,A(i,j)+1)+1;
    end
end

A=double(A);
IDY=zeros(m,n);

z=m*n;
B=reshape(A,1,z);

IDX=A;

Th=254;

for i=1:m
    for j=1:n
        if(IDX(i,j)>Th)
            IDY(i,j)=1;
        end
        if(IDX(i,j)<Th)
            IDY(i,j)=0;
        end
    end
end

Iout=IDY;