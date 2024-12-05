function [outputImage] = lightCompensation(inputImage,i)
%LIGHTCOMPENSATION Summary of this function goes here
workloadImage = im2double(inputImage);
HSV = rgb2hsv(workloadImage);

S = HSV(:,:,2);
V = HSV(:,:,3);
SV = S.*V;

workloadImage = double(workloadImage)./double(max(workloadImage(:)));

maxValues = sum(max(workloadImage));
maxValue = maxValues(:,:,1) + maxValues(:,:,2) + maxValues(:,:,3);

relativeMaxValues = maxValue / (size(workloadImage,1) * size(workloadImage,2));

workloadImage = workloadImage - (SV * (relativeMaxValues + 0.01));

% Split channels R, G, B
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

% Find avarage values for all channels, gray world
avgR = mean(R(:));
avgG = mean(G(:));
avgB = mean(B(:));

a = avgG / avgR;
b = avgG / avgB;

adR = a * R;
adG = G;
adB = b * B;

outputImage = cat(3,adR,adG,adB);

%outputImage = SV;


end

