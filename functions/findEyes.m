function [res, centroids] = findEyes(inputMask, inputImage)
%FINDEYES Summary of this function goes here
%   Detailed explanation goes here
workloadMask = inputMask;
workloadImage = im2double(inputImage);

faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

YCbCr = im2double(rgb2ycbcr(faceOnly));
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

HSV = im2double(rgb2hsv(faceOnly));
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

Cb2 = Cb .^2;
Cr2=(1-Cr).^2;
CbCr=Cb2./Cr;


Cr2S = rescale(Cr.*S - Cb);

imgGray=rgb2gray(faceOnly);
g=1./3;
l=g*Cb2;
m=g*Cr2;
n=g*CbCr;

EyeMapC=rescale(l+m+n);

J=histeq(EyeMapC)./1.5;

SE=strel('disk',12,8);
o=imdilate(imgGray,SE);
p=1+imerode(imgGray,SE);
EyeMapL=o./p;

SE=strel('disk',20,8);
smallerFaceMask = imerode(workloadMask, SE);

EyeMapL = (EyeMapL .* Cr2S) .* smallerFaceMask;

EyeMapRes = J .* EyeMapL;


EyeMapRes(EyeMapRes <= 0.50 * max(EyeMapRes(:))) = 0;


SE1 = strel("disk", 15);
EyeMapRes = imdilate(EyeMapRes, SE1);

EyeMapRes = imbinarize(rescale(EyeMapRes));

EyeMapRes = bwareafilt(EyeMapRes, 2, 'smallest');

SE2 = strel("disk", 10,8);
EyeMapRes = imdilate(EyeMapRes, SE2);


 res = EyeMapRes;
s = regionprops(EyeMapRes, 'centroid');
centroids = cat(1, s.Centroid);

end

