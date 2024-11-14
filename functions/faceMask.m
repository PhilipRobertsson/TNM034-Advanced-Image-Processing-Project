function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = imageInput;

% Avrage of the color channels
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);
avgR = mean(R(:));
avgG = mean(G(:));
avgB = mean(B(:));
avgGray = (avgR+avgG+avgB)/3;

% Adjustment factors
aR = avgGray/avgR;
aG = avgGray/avgG;
aB = avgGray/avgB;

% Adjustment of RGB channels
adR = R * aR;
adG = G * aG;
adB = B * aB;

% Temporary image viewing
subplot(2,4,1);
imshow(R);
title('Red channel');

subplot(2,4,2);
imshow(G);
title('Green channel');

subplot(2,4,3);
imshow(B);
title('Blue channel');

subplot(2,4,4);
imshow(workloadImage);
title('Original Image');

subplot(2,4,5);
imshow(adR);
title('Adjusted red channel');

subplot(2,4,6);
imshow(adG);
title('Adjusted green channel');

subplot(2,4,7);
imshow(adB);
title('Adjusted blue channel');

subplot(2,4,8);
imshow(cat(3, adR, adG, adB));
title('Adjusted image');



end

