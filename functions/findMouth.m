function [res,centroid] = findMouth(inputMask, inputImage)
%FINDMOUTH Summary of this function goes here
%   Detailed explanation goes here
workloadMask = inputMask;
workloadImage = im2double(inputImage);

faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

YCbCr = rgb2ycbcr(faceOnly);
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
Cg = (128/255) - (81.085/255)*workloadImage(:,:,1) + (122/255)*workloadImage(:,:,2) - (30.915/255)*workloadImage(:,:,3);

mouthMap = rescale(1/3*(pow2(Cb) + pow2(rescale(Cr)) + (Cr./Cb))) .*workloadMask;
mouthMap = mouthMap - rescale(pow2(Cg./Cb));
mouthMap = (mouthMap > 0.5);

SE1 = strel("disk",1);
mouthMap = imerode(mouthMap,SE1);

SE2 = strel("disk", 4);
mouthMap = imdilate(mouthMap, SE2);

mouthMap = bwareafilt(mouthMap,1);

SE2 = strel("rectangle", [5, 5]);
mouthMap = imdilate(mouthMap, SE2);

res = mouthMap;
s = regionprops(mouthMap, 'centroid');
centroid = cat(1, s.Centroid);


end

