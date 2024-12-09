function [res, centroid] = findMouth(inputMask, inputImage)

workloadMask = inputMask; % Load mask from faceMask
workloadImage = im2double(inputImage); % Load image from faceMask

% Create an image containing only the face with the face mask
faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

% Convert to YCbCr colour space and extract relevant channels
YCbCr = im2double(rgb2ycbcr(faceOnly));
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
Cg = (128/255) - (81.085/255)*faceOnly(:,:,1) + (122/255)*faceOnly(:,:,2) - (30.915/255)*faceOnly(:,:,3);

% Compute relevant images from Cb and, Cr channels
Cb2 = Cb.^2;

% Create the colour map for the mouth
mouthMap = rescale(1/3*(Cb2 + rescale(Cr) + (Cr./Cb))) .*workloadMask;
mouthMap = mouthMap - rescale((Cg./Cb).^2);
mouthMap = (mouthMap > 0.5);


% Create a smaller face mask to remove unneccesary parts of the face
SE=strel('disk',15,8);
smallerFaceMask = imerode(workloadMask, SE);
smallerFaceMask([1:floor(size(smallerFaceMask,2)*0.50)],:) = 0;
mouthMap = (mouthMap .* smallerFaceMask); % Combine mouth map with the smaller face mask

% Morpholigical operation to increase size of mouth and remove other parts
% of the image
SE1=strel('disk',1);
mouthMap = imopen(mouthMap, SE1);
SE2 = strel('disk', 8);
mouthMap = imclose(mouthMap, SE2);

% Make sure the mask is a binary image
mouthMap = imbinarize(mouthMap);

% Remove all but the largest object which is the mouth
mouthMap = bwareafilt(mouthMap,1);

% Morpholigical operation to increase size of mouth and make sure both lips
% are part of the mouth
SE3 = strel('disk', 15);
mouthMap = imclose(mouthMap, SE3);
SE4 = strel('disk', 1);
mouthMap = imdilate(mouthMap, SE4);

% Assign the mouth mask as the output mask and find centroid for the mouth
res = mouthMap;
s = regionprops(mouthMap, 'centroid');
centroid = cat(1, s.Centroid);


end

