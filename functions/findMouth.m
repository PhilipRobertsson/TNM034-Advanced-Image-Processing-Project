function [res, centroid] = findMouth(inputMask, inputImage)
%FINDMOUTH Summary of this function goes here
%   Detailed explanation goes here
workloadMask = inputMask;
workloadImage = im2double(inputImage);

faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));


YCbCr = im2double(rgb2ycbcr(faceOnly));
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
Cg = (128/255) - (81.085/255)*faceOnly(:,:,1) + (122/255)*faceOnly(:,:,2) - (30.915/255)*faceOnly(:,:,3);


Cg2 = Cg.^2;
Cb2 = Cb.^2;
Cr2=(1-Cr).^2;
CgCr=Cr2./Cg;

mouthMap = rescale(1/3*(Cb2 + rescale(Cr) + (Cr./Cb))) .*workloadMask;
mouthMap = mouthMap - rescale((Cg./Cb).^2);
mouthMap = (mouthMap > 0.5);


SE=strel('disk',20,8);
smallerFaceMask = imerode(workloadMask, SE);

smallerFaceMask([1:floor(size(smallerFaceMask,1)*0.35)],:) = 0;

mouthMap = (mouthMap .* smallerFaceMask);
%mouthMap = (mouthMap>0.5);

SE1=strel('disk',3);
mouthMap = imopen(mouthMap, SE1);

SE2 = strel('disk', 8);
mouthMap = imclose(mouthMap, SE2);

mouthMap = imbinarize(mouthMap);

mouthMap = bwareafilt(mouthMap,1);

SE2 = strel('disk', 15);
mouthMap = imclose(mouthMap, SE2);

res = mouthMap;
s = regionprops(mouthMap, 'centroid');
centroid = cat(1, s.Centroid);


end

