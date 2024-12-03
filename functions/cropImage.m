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

IM = inputImage;
FM = faceMask(IM);

% Get eye positions to find the rotation of the image.
[eres ecent] = findEyes(FM, IM);
    
leftEye = ecent(1,:);
rightEye = ecent(2,:);
x1 = leftEye(1);
y1 = leftEye(2);
x2 = rightEye(1);
y2 = rightEye(2);

%{
% Visualize the line between the eyes.
abs(y2-y1)
figure(1), imshow(IM), hold on
plot([x1 x2], [y1 y2], "*-", Color="green"), hold off
%}

% The angle needed to straighten the image.
angle = atand(abs(y2-y1) / abs(x2-x1));
if (y1 > y2) 
    angle = -angle;
end

% Rotate the image.
nIM = imrotate(IM, angle);

% Redefine eye positions for the crop.
nFM = faceMask(nIM);
[neres necent] = findEyes(nFM, nIM);
leftEye = necent(1,:);
rightEye = necent(2,:);
eyeLine = rightEye - leftEye;
x1 = leftEye(1);
y1 = leftEye(2);

% The mouth is needed to find lower edge of the crop.
[mres mcent] = findMouth(nFM, nIM);

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