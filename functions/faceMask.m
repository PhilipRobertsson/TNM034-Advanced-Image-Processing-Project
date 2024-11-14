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

% Concentrate all adjusted channels to a single image
adWorkloadImage = cat(3, adR, adG, adB);

% Color space change with light compansated image
YCbCr = rgb2ycbcr(workloadImage);

% Split YCbCr image into separate images
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% Face mask
maskYCbCr = (135 < Cr & Cr < 180) & (85 < Cb & Cb <135) & (Y > 80);
maskRGB = (R > G & R > B) & ((G >= B & 5*R -12*G + 7*B >=0) | (G<B & 5*R + 7*G - 12*B >=0));


maskRes = bsxfun(@times, workloadImage, cast(maskYCbCr, 'like', workloadImage));


% Temporary image viewing
subplot(3,4,1);
imshow(R);
title('Red channel');

subplot(3,4,2);
imshow(G);
title('Green channel');

subplot(3,4,3);
imshow(B);
title('Blue channel');

subplot(3,4,4);
imshow(workloadImage);
title('Original Image');

subplot(3,4,5);
imshow(adR);
title('Adjusted red channel');

subplot(3,4,6);
imshow(adG);
title('Adjusted green channel');

subplot(3,4,7);
imshow(adB);
title('Adjusted blue channel');

subplot(3,4,8);
imshow(adWorkloadImage);
title('Adjusted image');

subplot(3,4,9);
imshow(Y);
title('Y channel');

subplot(3,4,10);
imshow(maskRes);
title('maskComb');

subplot(3,4,11);
imshow(maskYCbCr);
title('maskYCbCr');

subplot(3,4,12);
imshow(YCbCr);
title('YCbCr image');





end

