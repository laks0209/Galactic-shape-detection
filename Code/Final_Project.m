clear all;

A1 = imread('spiral1.tif');            % read galaxy image
figure;title('original image');
imshow(A1);                         % show image
gray = rgb2gray(A1);                % convert to grayscale image
% figure;title('gray image');
% imshow(gray);
R = A1(:,:,1);%figure;imshow(R)         % red 
G = A1(:,:,2);%figure;imshow(G)         %green
B = A1(:,:,3);%figure;imshow(B)         % Blue
[m,n] = size(B);


[centers, radii] = imfindcircles(A1,[5 40],'ObjectPolarity','bright','Sensitivity',0.92);

Luminosity_R = find_luminosity(R,centers,radii);%figure;plot(Luminosity_R);
Luminosity_G = find_luminosity(G,centers,radii);%figure;plot(Luminosity_G);
Luminosity_B = find_luminosity(B,centers,radii);%figure;plot(Luminosity_B);

color = Luminosity_B - Luminosity_G;
Luminosity = log(10*(Luminosity_R + Luminosity_G + Luminosity_B));
figure
scatter(color,Luminosity)
set(gca,'yscale','log')
axis([-1 2 0.1 10]);title('Main sequence plot')
%axis([-1 2 -2 3]);title('Main sequence plot')
brush on

%%

if(size(centers) ~=0)
    for i = 1:size(select)
        [c, index(i)] = min(abs(color - select(i,1)));
    end
end
brush off;
[u,v,d]=size(A1);
 
 Y=ones(u,v);
 Y=Y.*255;
 what=size(Y);
 black = uint8([0 0 0]); % [R G B];
[r,t]=size(centers);
 for i=1:size(select)
     Y = insertShape(Y, 'FilledCircle', [centers(index(i),1) centers(index(i),2) radii(index(i))], 'Color', black);
 end
 figure;imshow(uint8(Y));title('Y');
 
 figure;imshow(uint8(rgb2gray(Y)));title('Yg');

A1=double(A1);Y=double(Y);

C=A1.*(A1-Y);

figure;imshow(uint8(C));title('C');
YY=imgbtmask(uint8(Y));YF=YY;
YY=YY.*256;

starmask = ((YY./256));

R_stars = uint8(double(R).*starmask);          %red image of stars
G_stars = uint8(double(G).*starmask);          %green image of stars
B_stars = uint8(double(B).*starmask);          %blue image of stars

starimage(:,:,1) = R_stars;
starimage(:,:,2) = G_stars;
starimage(:,:,3) = B_stars;
figure;imshow(starimage);title('Star Image');


level_gray = graythresh(gray);      %   Thresholding for gray image
D = im2bw(gray,level_gray);
%figure;imshow(D);

level_R = graythresh(R);             %   Thresholding for red image
R_thres = im2bw(R,level_R);
%figure;imshow(R_thres);


level_G = graythresh(G);             %   Thresholding for green image
G_thres = im2bw(G,level_G);
%figure;imshow(G_thres);

level_B = graythresh(B);             %   Thresholding for blue image
B_thres = im2bw(B,level_B);
%figure;imshow(B_thres);

% filling holes
E= imfill(D,'holes');
% figure(4);
% imshow(E);

R_fill = imfill(R_thres,'holes');%figure; imshow(R_fill);
G_fill = imfill(G_thres,'holes');%figure; imshow(G_fill);
B_fill = imfill(B_thres,'holes');%figure; imshow(B_fill);

F = largest_component(E);           %find largest component
%figure;imshow(F);

R_comp = largest_component(R_fill);%figure; imshow(R_comp);
G_comp = largest_component(G_fill);%figure; imshow(G_comp);
B_comp = largest_component(B_fill);%figure; imshow(B_comp);

[ellipse,circle, spiral,barred] = shape_detection(gray);

[ellipse_R, circle_R, sprial_R,barred_R] = shape_detection(R);
[ellipse_G, circle_G, sprial_G,barred_G] = shape_detection(G);
[ellipse_B, circle_B, sprial_B,barred_B] = shape_detection(B);

%check
if(ellipse>1)
    if(circle==1)
        disp('CIRCLE');
    else
        disp('ELLIPSE');
    end
end


 if(spiral>1)
    if(barred==1)
        disp('BARRED SPIRAL');
    else
        disp('NORMAL SPIRAL');
    end
end