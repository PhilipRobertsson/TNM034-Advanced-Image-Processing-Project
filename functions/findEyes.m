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

gSigma = rescale(imgaussfilt(Y,6));

EyeMapC = rescale(1/3*(pow2(Cr) + pow2(rescale(Cb)) + (Cr.*Cb))) .*workloadMask;
%EyeMapC = (EyeMapC .* workloadMask) - 0.65 * rescale(pow2(Cr));
%EyeMapC = 2 * EyeMapC - rescale(pow2(Cr));
%EyeMapC = (EyeMapC > 0.4);

%SE1 = strel("disk",15);
%EyeMapC = imdilate(EyeMapC,SE1);

%EyeMapC = EyeMapC - (Cr>0.5);

%SE1 = strel("disk",15);
%EyeMapC = imdilate(EyeMapC,SE1);

%SE2 = strel("disk",10);
%EyeMapC = imopen(EyeMapC,SE2);



%[centers, radii] = imfindcircles(EyeMapC, [6 10], 'ObjectPolarity', 'dark', 'Sensitivity', 0.97);

%hold on
    %viscircles(centers, radii);
%hold off

 res = EyeMapL;
end

