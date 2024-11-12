function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = imageInput;

% HSV images
[hueImage, satImage, valImage] = rgb2hsv(workloadImage);

subplot(1,3,1)
imshow(hueImage);
subplot(1,3,2);
imshow(satImage);
subplot(1,3,3);
imshow(valImage);

end

