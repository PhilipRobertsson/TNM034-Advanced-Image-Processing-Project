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

% Cr/Cg Mask skin mask
maskCrCg =Cr - Cg;
maskCrCg(maskCrCg<0) = 0;
maskCrCg = sqrt(maskCrCg);
maskCrCg = (maskCrCg >= 0.01);


% Edge mask
workloadImageGray = im2gray(workloadImage);
Sobx = [-1,-2,-1;0,0,0;1, 2, 1];
Soby = [-1,0,1;-2,0,2;-1, 0, 1];

imgSobx =filter2(Sobx,workloadImageGray,'same');
imgSoby = filter2(Soby,workloadImageGray,'same');

maskEdge = sqrt(imgSobx.^2+ imgSoby.^2);
maskEdge = (maskEdge > 0.5);

maskComb = (maskCrCg == 1) & (maskEdge == 0);
SE1=strel("disk",[5]);
maskComb = imopen(maskComb,SE1);
SE2=strel("line",[20],0);
maskComb = imclose(maskComb,SE2);
SE3=strel("line",[20],90);
maskComb = imclose(maskComb,SE3);

cropped = bwareafilt(maskComb,1);

SE1=strel("rectangle", [12,12]);
cropped = imopen(cropped,SE1);
SE2=strel("disk",[50]);
cropped = imclose(cropped,SE2);
maskedImage = bsxfun(@times, workloadImage, cast(cropped, 'like', workloadImage));

maskOutput = maskedImage;
end

