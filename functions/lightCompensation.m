function [outputImage] = lightCompensation(inputImage)
%LIGHTCOMPENSATION Summary of this function goes here
workloadImage = im2double(inputImage);

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

% white patch
numRevPixels = floor((size(workloadImage,1)) * 0.1); % 10% of pixels

maxRed = max(maxk(R,numRevPixels,2));
maxGreen = max(maxk(G,numRevPixels,2));
maxBlue = max(maxk(B,numRevPixels,2));

meanMax = mean(cat(2, maxRed, maxGreen, maxBlue),"all");

mR=  R * mean(maxRed,"all");
mG = G * mean(maxGreen,"all");
mB = B * mean(maxBlue,"all");

alpha = mG / mR;
beta = mG / mB;

wpR = alpha * R;
wpG = G;
wpB = beta * B;

outputImage = cat(3,adR,adG,adB);


end

