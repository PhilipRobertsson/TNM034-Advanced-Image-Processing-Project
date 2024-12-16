function [res, centroids] = findEyes(inputMask, inputImage)

workloadMask = inputMask; % Load mask from faceMask
workloadImage = im2double(inputImage); % Load image from faceMask

% Create an image containing only the face with the face mask
faceOnly = bsxfun(@times, workloadImage, cast(workloadMask, 'like', workloadImage));

% Convert to YCbCr colour space and extract relevant channels
YCbCr = im2double(rgb2ycbcr(workloadImage));
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

GB = G.*B;
GB = imgaussfilt(GB,2);

% Compute relevant images from Cb, Cr and, S channels
Cb2 = rescale(Cb .^2);
Cr2=rescale((1-Cr).^2);
CbCr=rescale(Cb2./Cr);

% Create the colour map for the eyes
g=1./3;
l=rescale(g*Cb2);
m=rescale(g*Cr2);
n=rescale(g*CbCr);
EyeMapC=rescale(l+m+n);

% Create the dilated luminance map for the eyes
imgGray=rgb2gray(workloadImage);
SE=strel('disk',6,8);
o=imdilate(imgGray,SE);
p=1+imerode(imgGray,SE);
EyeMapL=(o./p);

% Create a smaller face mask to remove unneccesary parts of the face
SE=strel('disk',10);
smallerFaceMask = imerode(workloadMask, SE);
smallerFaceMask(([floor(size(smallerFaceMask,1)*0.55)]:end),:) = 0;
smallerFaceMask((1:[floor(size(smallerFaceMask,1)*0.25)]),:) = 0;

smallerFaceMask(:,([floor(size(smallerFaceMask,2)*0.80)]:end)) = 0;
smallerFaceMask(:,(1:[floor(size(smallerFaceMask,2)*0.10)])) = 0;

% Apply the smaller face mask to the dilated face mask
EyeMapL = EyeMapL .* smallerFaceMask;

EyeMapRes = rescale(EyeMapC .* EyeMapL); % Combine both eye maps

% Filter out to dark areas based on the max value in the eye map
EyeMapRes(EyeMapRes <= 0.70 * max(EyeMapRes(:))) = 0;

% Morpholigical operation to increase size of the eyes
SE1 = strel("disk", 8);
EyeMapRes = imdilate(EyeMapRes, SE1);
SE2 = strel("line",10, 0);
EyeMapRes = imclose(EyeMapRes, SE2);

EyeMapRes = EyeMapRes .* GB;

EyeMapRes = imbinarize(EyeMapRes);

SE3 = strel("line", 25,0);
EyeMapRes = imclose(EyeMapRes,SE3);

EyeMapRes = bwareafilt(EyeMapRes, 2, 'largest');

SE3 = strel("disk", 2);
EyeMapRes = imdilate(EyeMapRes, SE3);

% Assign the eye mask as the output mask and find centroids for the eyes
res = EyeMapRes;
s = regionprops(EyeMapRes, 'centroid');
centroids = cat(1, s.Centroid);

end

