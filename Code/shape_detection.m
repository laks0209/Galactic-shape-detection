
function [ellipse,circle,spiral,barred] = shape_detection(B)


[m,n] = size(B);


ellipse=0;
spiral = 0;
barred=0;
circle = 0;



%Otsu's thresholding
a = round(255*(graythresh(B)));

for i=1:m
    for j=1:n
        if(B(i,j)>a)
            D(i,j) = 1;
        else
            D(i,j) = 0;
        end
    end
end
%figure;imshow(D);title('thresholded image');




% filling holes
E= imfill(D,'holes');
% figure;imshow(E);title('Filled image');



% FINAL BINARY IMAGE
% largest connected component
[L,num] = bwlabel(E);
pix = zeros(1,num);
for(i=1:m)
    for(j=1:n) 
        if(L(i,j)~=0)
            a = L(i,j);
            pix(a) = pix(a) + 1;
        end
    end
end
maximum = max(pix);
for(a = 1:num)
    if(pix(a)==maximum)
        k = a;
    end   
end
F = zeros(m,n);
for(i=1:m)
    for(j=1:n)  
        if(L(i,j)==k)
            F(i,j) = 1;
        end  
    end
end
% figure;imshow(F);title('Final binary image');



%centering
measure = regionprops(F, 'Centroid');
centrX = round(measure.Centroid(1));
centrY = round(measure.Centroid(2));



%alignment
bound = bwboundaries(F);
boundary = bound{1};
dist =sqrt((((boundary(:,1) - centrY).^2 )+((boundary(:,2)-centrX).^2)));
minrad = round(min(dist));
[maxrad, maxradcoord] = max(dist);
maxcoord = boundary(maxradcoord,:);
maxrad = round(max(dist));
y2 = maxcoord(1);
x2 = maxcoord(2);

theta=atan2(y2-centrY,x2-centrX)*180/pi; 
G = imrotate(F,theta,'crop');
% figure;imshow(G);title('Aligned image');

 
measure = regionprops(G, 'Centroid');
centrX = round(measure.Centroid(1));
centrY = round(measure.Centroid(2));
   

    
% CHECK 1 (elliptical Vs spiral galaxy)
% counting number of black pixels inside 10% contracted ellipse
a = round(0.9*maxrad);
for i=centrY:-1:2
    if((G(i,centrX)==1)&&(G(i-1,centrX)==0))
        b = round(0.9*(centrY - i));
    end
end


countblk = 0;
for i = 1:m
    for j=1:n
        if(((i-centrY)/b)^2 + ((j-centrX)/a)^2 <= 1)
           if(G(i,j)==0)
               countblk = countblk + 1;
           end
        end
    end
end

if(countblk<5)
     ellipse=ellipse+1;
else
    spiral = spiral+1;
end


% CHECK 2 (elliptical Vs spiral galaxy)
% counting number of pixel transitions along radial path 
maxrad = maxrad + 10;
displ = 20;
m3 = (360/10)+1;
x3 = zeros(m3,displ+maxrad);
y3 = zeros(m3,displ+maxrad);

    i=1;
    for(theta2=0:10:360)
        for(r11 = 1 : displ : maxrad)
        y3(i,r11) = (ceil(r11*cos((3.14/180.0)*theta2))+centrX);
        x3(i,r11) = (ceil(r11*sin((3.14/180.0)*theta2))+centrY);
        end 
        i=i+1;
    end

count = 0;

for(i=1:m3-1)
    for(j=1:displ:maxrad)
        x4 = x3(i,j);
        y4 = y3(i,j);
        x5 = x3(i,j+displ);
        y5 = y3(i,j+displ);
         if((x5<=0)||(y5<=0)||(x4<=0)||(y4<=0)||x5>m||y5>n||x4>m||y4>n)
             continue;
         end
        if((G(x4,y4))~=(G(x5,y5))) 
            count = count + 1;
        end
    end
end

avgcount = count - 36;
if(avgcount<5)
    ellipse = ellipse+1;
else
    spiral = spiral +1;
end


% CHECK 3 (elliptical Vs spiral galaxy)
% counting the number of white pixels in opposite quadrants
H = imrotate(G,45,'crop');
% figure(8);
% imshow(H);
measure = regionprops(H, 'Centroid');
centrX1 = round(measure.Centroid(1));
centrY1 = round(measure.Centroid(2));
I1=H(1:centrY1,1:centrX1);
% figure,imshow(I1);
I2=H(1:centrY1,centrX1+1:n);
% figure,imshow(I2);
I3=H(centrY1+1:m,1:centrX1);
% figure,imshow(I3);
I4=H(centrY1+1:m,centrX1+1:n); 
% figure,imshow(I4);
c1 = 0;c2 = 0;c3 = 0;c4 = 0;
for(i=1:centrY1)
    for(j=1:centrX1)
        if(I1(i,j)==1)
            c1 = c1+1;
        end
    end
end
for(i=1:centrY1)
    for(j=1:n-centrX1)
        if(I2(i,j)==1)
            c2 = c2+1;
        end
    end
end
for(i=1:m-centrY1)
    for(j=1:centrX1)
        if(I3(i,j)==1)
            c3 = c3+1;
        end
    end
end
for(i=1:m-centrY1)
    for(j=1:n-centrX1)
        if(I4(i,j)==1)
            c4 = c4+1;
        end
    end
end
r1 = c1/c4;
r2 = c2/c3;
r3 = c1/c2;
r4 = c3/c4;
if((r1<=1.02)&&(r1>=0.98)&&(r2<=1.02)&&(r2>=0.98))
     ellipse=ellipse+1;
      if((r3<=1.02)&&(r3>=0.98)&&(r4<=1.02)&&(r4>=0.98))
          circle = circle+1;
      end
else 
    spiral = spiral+1;
end

% CHECK for barred spiral Vs normal spiral galaxy
% counting number of pixel transitions along 20% contracted circumferential path
r = round(0.8*maxrad); 
i=1;
for(theta1 = 0 : 0.15 : 2*pi)
    y5(i) = round(r*cos(theta1)+centrX);
    x5(i) = round(r*sin(theta1)+centrY);
    i=i+1;
end
sz1 = size(x5);
sz = sz1(2);
count3 = 0;
for(i=1:sz-1)
   x6 = x5(i);
   y6 = y5(i);
   x7 = x5(i+1);
   y7 = y5(i+1);
    if((x6<=0)||(y6<=0)||(x7<=0)||(y7<=0)||(x6>m)||(y6>n)||(x7>m)||(y7>n))
             continue;
         end
        if(G(x6,y6)~=G(x7,y7))
            count3 = count3 + 1;
        end
end
if(count3<6)   
    barred=1;
end
