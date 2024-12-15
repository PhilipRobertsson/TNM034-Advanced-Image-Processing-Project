function [id] = searchForMatch(im, weightsDB1, meanFace, eigenFaces)
% searchForMatch is 

imageRGB = imread(im); % Read image
imgLC = lightCompensation(imageRGB); % Perform Light Compensation

% Test image preprocessing
cropped = cropImage(imgLC, 0.6); % Crop image same as database
cropped = rgb2gray(im2double(cropped)); % Convert to grayscale same as database
phiTestImage = cropped(:) - meanFace; % Mean-adjusted test image

% Compute weights for the test image
weigthsTestImage = eigenFaces' * phiTestImage;

% Compute Euclidean distances between test image and training images
distances = vecnorm(weightsDB1 - weigthsTestImage, 2, 1);
[minimunDist, matchIndex] = min(distances);

% Threshold for matching
threshold = 16;
if minimunDist < threshold
    id = matchIndex;
else
    id = 0;
end
