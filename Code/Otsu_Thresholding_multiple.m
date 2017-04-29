
Function (D, R_thres, G_thres, B_thres) = Otsu_Thresholding_multiple(gray, R, G, B)
    level_gray = graythresh(gray);      %   Thresholding for gray image
    D = im2bw(gray,level_gray);
    %imshow(D);

    level_R = graythresh(R);             %   Thresholding for red image
    R_thres = im2bw(R,level_R);
    %imshow(R_thres);

    level_G = graythresh(G);             %   Thresholding for green image
    G_thres = im2bw(G,level_G);
    %imshow(G_thres);

    level_B = graythresh(B);             %   Thresholding for blue image
    B_thres = im2bw(B,level_B);
    %imshow(B_thres);
    