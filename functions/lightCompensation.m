function [outputImage] = lightCompensation(inputImage)
%LIGHTCOMPENSATION Summary of this function goes here

workloadImage = im2double(inputImage); %[0-1]
grayImage = rgb2gray(workloadImage); %[0-1]

mask = grayImage > 0.3;

redChannel = imadjust(workloadImage(:, :, 1));
greenChannel = imadjust(workloadImage(:, :, 2));
blueChannel = imadjust(workloadImage(:, :, 3));

meanR = mean(redChannel(mask));
meanG = mean(greenChannel(mask));
meanB = mean(blueChannel(mask));

maxR = max(redChannel(mask));
maxG = max(greenChannel(mask));
maxB = max(blueChannel(mask));

deltaR = maxR - meanR;
deltaG = maxG - meanG;
deltaB = maxB - meanB;

newR = redChannel + deltaR;
newG = greenChannel + deltaG;
newB = blueChannel + deltaB;
outputImage = cat(3,newR,newG,newB);

end

