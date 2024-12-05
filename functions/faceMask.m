function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = im2double(imageInput);

% Color space change with image
YCbCr = rgb2ycbcr(workloadImage);

% Split RGB into separate channels
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

% Split YCbCr image into separate channels
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cg = (128/255) - (81.085/255)*R + (122/255)*G - (30.915/255)*B;
Cr = YCbCr(:,:,3);


% Cr/Cg Mask skin mask
maskCrCg =Cr - Cg;
maskCrCg(maskCrCg<0) = 0;
maskCrCg = 1.5 * sqrt(maskCrCg);
maskCrCg = (maskCrCg >= 0.005);

hairMask =1.5 * (sqrt(Cg - Y));
hairMask(hairMask<=0) = 0;
hairMask = (hairMask >= 0.7);

shadowMask =0.9 *  sqrt(Cr - Cb);
shadowMask = 1.2 * (shadowMask - sqrt(Cr-Cg));
shadowMask(shadowMask<=0) = 0;
shadowMask = (shadowMask >= 0.15);

% Edge mask
workloadImageGray = im2gray(workloadImage);
Sobx = [-1,-2,-1;0,0,0;1, 2, 1];
Soby = [-1,0,1;-2,0,2;-1, 0, 1];

imgSobx =filter2(Sobx,workloadImageGray,'same');
imgSoby = filter2(Soby,workloadImageGray,'same');

maskEdge = sqrt(imgSobx.^2+ imgSoby.^2);
maskEdge = (maskEdge > 0.6);

maskComb = (maskCrCg == 1) & (maskEdge == 0);
maskComb = maskComb - hairMask - shadowMask;
maskComb = imbinarize(maskComb);

SE1=strel("line",40,90);
maskComb = imclose(maskComb,SE1);
SE2=strel("line",54,90);
maskComb = imclose(maskComb,SE2);

cropped = bwareafilt(maskComb,1);

SE3=strel("rectangle", [110,100]);
cropped = imclose(cropped,SE3);

SE4=strel("disk", 15);
cropped = imerode(cropped,SE4);

maskOutput = cropped;
end

