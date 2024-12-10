function [res, centroids] = findEyes(inputMask, inputImage)

workloadMask = inputMask; % Load mask from faceMask
workloadImage = im2double(inputImage); % Load image from faceMask

% Create an image containing only the face with the face mask
faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

% Convert to YCbCr colour space and extract relevant channels
YCbCr = im2double(rgb2ycbcr(faceOnly));
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% Convert to HSV colour space and extract relevant channel
HSV = im2double(rgb2hsv(faceOnly));
S = HSV(:,:,2);

% Compute relevant images from Cb, Cr and, S channels
Cb2 = Cb .^2;
Cr2=(1-Cr).^2;
CbCr=Cb2./Cr;
Cr2S = Cr.*S;

% Create the colour map for the eyes
g=1./3;
l=g*Cb2;
m=g*Cr2;
n=g*CbCr;
EyeMapC=rescale(l+m+n);
J=histeq(EyeMapC);

% Create the dilated luminance map for the eyes
imgGray=rgb2gray(faceOnly);
SE=strel('disk',8,8);
o=imdilate(imgGray,SE);
p=1+imerode(imgGray,SE);
EyeMapL=o./p;

% Create a smaller face mask to remove unneccesary parts of the face
SE=strel('disk',15);
smallerFaceMask = imerode(workloadMask, SE);
smallerFaceMask(([floor(size(smallerFaceMask,1)*0.55)]:end),:) = 0;
smallerFaceMask((1:[floor(size(smallerFaceMask,1)*0.35)]),:) = 0;

smallerFaceMask(:,([floor(size(smallerFaceMask,2)*0.70)]:end)) = 0;
smallerFaceMask(:,(1:[floor(size(smallerFaceMask,2)*0.15)])) = 0;

% Apply the smaller face mask to the dilated face mask
EyeMapL = (EyeMapL .* Cr2S) .* smallerFaceMask;
EyeMapRes = J .* EyeMapL; % Combine both eye maps

% Filter out to dark areas based on the max value in the eye map
EyeMapRes(EyeMapRes <= 0.43 * max(EyeMapRes(:))) = 0;

% Morpholigical operation to increase size of the eyes
SE1 = strel("disk", 20);
EyeMapRes = imdilate(EyeMapRes, SE1);

% Make sure the mask is a binary image
EyeMapRes = imbinarize(rescale(EyeMapRes));

EyeMapRes = bwareafilt(EyeMapRes, 2, 'largest');

% Assign the eye mask as the output mask and find centroids for the eyes
res = EyeMapRes;
s = regionprops(EyeMapRes, 'centroid');
centroids = cat(1, s.Centroid);

end

