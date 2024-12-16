function [res, centroid] = findMouth(inputMask, inputImage)

workloadMask = inputMask; % Load mask from faceMask
workloadImage = im2double(inputImage); % Load image from faceMask

% Create an image containing only the face with the face mask
faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

% Convert to YCbCr colour space and extract relevant channels
YCbCr = im2double(rgb2ycbcr(workloadImage));
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% Compute relevant images from Cb and, Cr channels
Cr2 = rescale(Cr.^2);
CrCb = rescale(Cr./Cb);

% Create the colour map for the mouth
n = size(workloadImage,1) * size(workloadImage,2);
n_ = 0.95 * ((sum(Cr2(:))/n) /(sum(CrCb(:))/n));

mouthMap = rescale(Cr2 .* (Cr2 - (n_*CrCb)).^2) .*workloadMask;

% Create a smaller face mask to remove unneccesary parts of the face
SE=strel('disk',10,8);
smallerFaceMask = imerode(workloadMask, SE);
smallerFaceMask([1:floor(size(smallerFaceMask,1)*0.55)],:) = 0;
smallerFaceMask([floor(size(smallerFaceMask,1)*0.85):end],:) = 0;
mouthMap = (mouthMap .* smallerFaceMask); % Combine mouth map with the smaller face mask

% Morpholigical operation to increase size of mouth and remove other parts
% of the image
SE1=strel('disk',25);
mouthMap = imdilate(mouthMap, SE1);

mouthMap(mouthMap < 0.65 * max(mouthMap(:))) = 0;

% Make sure the mask is a binary image
mouthMap = imbinarize(mouthMap);

% Remove all but the largest object which is the mouth
mouthMap = bwareafilt(mouthMap,1);

% Morpholigical operation to increase size of mouth and make sure both lips
% are part of the mouth
SE3 = strel('disk', 10);
mouthMap = imclose(mouthMap, SE3);
SE4 = strel('disk', 2);
mouthMap = imdilate(mouthMap, SE4);

% Assign the mouth mask as the output mask and find centroid for the mouth
res = mouthMap;
s = regionprops(mouthMap, 'centroid');
centroid = cat(1, s.Centroid);


end

