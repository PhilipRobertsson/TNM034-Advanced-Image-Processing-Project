function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = im2double(imageInput);

% Color space change with image
YCbCr = rgb2ycbcr(workloadImage);
HSV = rgb2hsv(workloadImage);

% Split RGB into separate channels
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

% Split YCbCr image into separate channels
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cg = (128/255) - (81.085/255)*R + (122/255)*G - (30.915/255)*B;
Cr = YCbCr(:,:,3);

% Split HSV image into separate channels
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

% YCbCr skin mask
maskCbR = (R - Cg).*(Cr.*1.0);
maskCbR = (maskCbR >= 0.05);

% Edge mask
workloadImageGray = im2gray(workloadImage);
Sobx = [-1,-2,-1;0,0,0;1, 2, 1];
Soby = [-1,0,1;-2,0,2;-1, 0, 1];

imgSobx =filter2(Sobx,workloadImageGray,'same');
imgSoby = filter2(Soby,workloadImageGray,'same');

maskEdge = sqrt(imgSobx.^2+ imgSoby.^2);
maskEdge = (maskEdge > 0.4);

maskComb = (maskCbR == 1) & (maskEdge == 0);

SE1=strel("rectangle", [10,10]);
maskComb = imopen(maskComb,SE1);
SE2=strel("disk",[10]);
maskComb = imclose(maskComb,SE2);

cropped = bwareafilt(maskComb,1);

SE1=strel("rectangle", [12,12]);
cropped = imopen(cropped,SE1);
SE2=strel("disk",[50]);
cropped = imclose(cropped,SE2);

maskedImage = bsxfun(@times, workloadImage, cast(cropped, 'like', workloadImage));


% Temporary image viewing
%subplot(3,4,1);
%imshow(Y);
%title('Y');

%subplot(3,4,2);
%imshow(Cb);
%title('Cb');

%subplot(3,4,3);
%imshow(Cr);
%title('Cr');

%subplot(3,4,4);
%imshow(Cg);
%title('Cg');

%subplot(3,4,5);
%imshow(maskCbR);
%title('(R - Cb) mask');

%subplot(3,4,6);
%imshow(maskEdge);
%title('Edge mask');

%subplot(3,4,7);
%imshow(cropped);
%title('Combined YCbCr and edge masks');


%subplot(3,4,9);
%imshow(workloadImage);
%title('Original image');

%subplot(3,4,11);
%imshow(maskedImage);
%title('Masked light compensated image');

maskOutput = maskedImage;
end

