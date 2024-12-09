function [cIM] = cropImage(inputImage, edgeMargin)
%CROPIMAGE - Crop the faces to a standardized format.
%   The purpose of this function is to crop the image to a standardized
%   format. 
%   First, the position of the eyes are used to straighten the image. The
%   image is thus rotated with the negative angle between the eyes.
%   Then, the position of the mouth together with recalculated positions
%   for the eyes are used to enclose the face. The eyes define the upper
%   corners of the crop, while the mouth defines the lower boundary. An
%   edgeMargin is used to give some space.
%   Finally, the cropped image is resized to a 250x250 square.

IM = inputImage; % Read input image
[FM,IT] = faceMask(IM); % Generate face mask and a translated image

% Get eye positions to find the rotation of the image.
[eres ecent] = findEyes(FM, IT); % Find eyes in image, used for rotation

leftEye = ecent(1,:); % The left eye from findEyes centroids
rightEye = ecent(2,:); % The right eye from findEyes centroids
x1 = leftEye(1); % X coordinate of left eye
y1 = leftEye(2); % Y coordinate of left eye
x2 = rightEye(1); % X coordinate of right eye
y2 = rightEye(2); % Y coordinate of right eye

% The angle needed to straighten the image.
angle = atand(abs(y2-y1) / abs(x2-x1));
if (y1 > y2) 
    angle = -angle;
end

% Rotate the image.
nIM = imrotate(IT, angle,'crop');

% Redefine eye positions for the crop.
[nFM,nIT] = faceMask(nIM); % New face mask after rotation
[neres necent] = findEyes(nFM, nIT); % New eye mask and centroids after rotation
leftEye = necent(1,:); % The left eye from findEyes centroids
rightEye = necent(2,:); % The right eye from findEyes centroids
eyeLine = rightEye - leftEye; % The now straight line between the eyes
x1 = leftEye(1); % X coordinate of left eye used to find where to place the corner of the image
y1 = leftEye(2); % Y coordinate of left eye used to find where to place the corner of the image

% The mouth is needed to find lower edge of the crop.
[mres mcent] = findMouth(nFM, nIT);

% Upper Left corner of the cropped image.
upLx = x1 - (eyeLine(1) * edgeMargin);
upLy = y1 - (eyeLine(1) * edgeMargin);

% Distance from UPLEFT to LOWRIGHT.
lowRx = eyeLine(1) + (eyeLine(1) * edgeMargin) * 2;
lowRy = (mcent(2) - upLy) * 1.2;

% Cropping...
cIM = imcrop(nIM, [upLx upLy lowRx lowRy]);

% Make square
cIM = imresize(cIM, [250 250]);


end