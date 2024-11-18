function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = im2double(imageInput);

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

maximumValue = max(max(adWorkloadImage));
[x,y] = find(adWorkloadImage == maximumValue);

maxR = maximumValue*R(x(1), y(1));
maxG = maximumValue*G(x(1), y(1));
maxB = maximumValue*B(x(1), y(1));

alpha = maxG(:,:,1)/maxR(:,:,1);
beta = maxG(:,:,1)/maxB(:,:,1);

whitePatchR = alpha * R;
whitePatchG = 1.01 * G;
whitePatchB = beta * B;

whitepatchWorkloadImage = cat(3, whitePatchR, whitePatchG, whitePatchB);

% Color space change with light compansated image
YCbCr = rgb2ycbcr(whitepatchWorkloadImage);
HSV = rgb2hsv(adWorkloadImage);

% Split YCbCr image into separate channels
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% Split HSV image into separate channels
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);


maxCr = max(Cr);
normCr = Cr./maxCr;

% YCbCr skin mask
maskCbR = R - Cb.*1.1;
maskCbRCr = maskCbR.*normCr;
maskCbRCr = maskCbRCr >=0.2;



% Edge mask
workloadImageGray = im2gray(Cr);
Sobx = [-1,-2,-1;0,0,0;1, 2, 1];
Soby = [-1,0,1;-2,0,2;-1, 0, 1];

imgSobx =filter2(Sobx,workloadImageGray,'same');
imgSoby = filter2(Soby,workloadImageGray,'same');

maskEdge = sqrt(imgSobx.^2+ imgSoby.^2);
maskEdge = (maskEdge >= 0.1);

maskComb = (maskCbRCr == 1) & (maskEdge == 0);

SE1=strel("rectangle", [17,17]);
maskComb = imopen(maskComb,SE1);
SE2=strel("disk",[16]);
maskComb = imclose(maskComb,SE2);

cropped = bwareafilt(maskComb,1);

SE1=strel("rectangle", [17,17]);
cropped = imopen(cropped,SE1);
SE2=strel("disk",[40]);
cropped = imclose(cropped,SE2);

maskedImage = bsxfun(@times, whitepatchWorkloadImage, cast(cropped, 'like', whitepatchWorkloadImage));


% Temporary image viewing
subplot(3,4,1);
imshow(Y);
title('Y');

subplot(3,4,2);
imshow(Cb);
title('Cb');

subplot(3,4,3);
imshow(Cr);
title('Cr');

subplot(3,4,4);
imshow(YCbCr);
title('YCbCr Image');

subplot(3,4,5);
imshow(maskCbRCr);
title('(R - Cb) mask');

subplot(3,4,6);
imshow(maskEdge);
title('Edge mask');

subplot(3,4,7);
imshow(cropped);
title('Combined YCbCr and edge masks');

subplot(3,4,8)
imshow(Cr./maxCr);
title('CrmaxCr')

subplot(3,4,9);
imshow(workloadImage);
title('Original image');

subplot(3,4,10);
imshow(whitepatchWorkloadImage);
title('Light compensated image');

subplot(3,4,11);
imshow(maskedImage);
title('Masked light compensated image');

end

