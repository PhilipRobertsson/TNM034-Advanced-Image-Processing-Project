function [res] = findEyes(inputMask, inputImage)
%FINDEYES Summary of this function goes here
%   Detailed explanation goes here
workloadMask = inputMask;
workloadImage = im2double(inputImage);

faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

YCbCr = rgb2ycbcr(faceOnly);
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
Cg = (128/255) - (81.085/255)*workloadImage(:,:,1) + (122/255)*workloadImage(:,:,2) - (30.915/255)*workloadImage(:,:,3);

Eyes = 1.05 * pow2(Cg) - pow2(Cr);
Eyes = Eyes.*workloadMask;
Eyes = Eyes - 0.01*(Cg.*workloadMask);

 res = Eyes;
end

