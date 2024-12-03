function [id] = searchForMatch(im, weightsDB1, meanFace, eigenFaces)
% searchForMatch is 

imageRGB = imread(im);

% Test image preprocessing
gray = rgb2gray(imageRGB);
normalizedImage = double(gray) / 255;
cropped = normalizedImage(170:460, 70:320); %REPLACE
phiTestImage = cropped(:) - meanFace; % Mean-adjusted test image

% Compute weights for the test image
weigthsTestImage = eigenFaces' * phiTestImage;

% Compute Euclidean distances between test image and training images
distances = vecnorm(weightsDB1 - weigthsTestImage, 2, 1);
[minimunDist, matchIndex] = min(distances);

% Threshold for matching
threshold = 10; % Adjust if needed
if minimunDist < threshold
    %disp([num2str(matchIndex)]);
    %matchedImage = imread(imagesDB1{matchIndex});
    %figure;
    %imshow(matchedImage); % REMOVE BEFORE HANDING IN
    %title('Matched Image');
    id = matchIndex;
else
    id = 0;

end
