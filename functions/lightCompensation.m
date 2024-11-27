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

outputImage = cat(3,adR,adG,adB);


end

