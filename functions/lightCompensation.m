function [outputImage] = lightCompensation(inputImage)
%LIGHTCOMPENSATION Summary of this function goes here
workloadImage = im2double(inputImage); % Read image
HSV = rgb2hsv(workloadImage); % Create an HSV image from input

S = HSV(:,:,2); % Saturation part of HSV image
V = HSV(:,:,3); % Value part of HSV image
SV = S.*V; % Used to nomralize too bright images

workloadImage = double(workloadImage)./double(max(workloadImage(:))); % Create copy of input image

% Find max values
maxValues = sum(max(workloadImage));
maxValue = maxValues(:,:,1) + maxValues(:,:,2) + maxValues(:,:,3);

% Max value based on the number of pixels in the image
relativeMaxValues = maxValue / (size(workloadImage,1) * size(workloadImage,2));

% Normalize image values
workloadImage = workloadImage - (SV * (relativeMaxValues + 0.005));

% Split channels R, G, B
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

% Find avarage values for all channels, gray world
avgR = mean(R(:));
avgG = mean(G(:));
avgB = mean(B(:));

% Calculate alpha and beta
a = avgG / avgR;
b = avgG / avgB;

% Gray world light compensation
adR = a * R;
adG = G;
adB = b * B;

% Create output rgb image from R, G, and B channels
outputImage = cat(3,adR,adG,adB);

end

