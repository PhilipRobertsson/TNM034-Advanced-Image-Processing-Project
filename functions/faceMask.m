function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on sSkin Detection and Segmentation of Human Face in Color
%   Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = imageInput;

% Avrage of the color channels
AR = workloadImage(:,:,1);
AG = workloadImage(:,:,2);
AB = workloadImage(:,:,3);

for i = 1 : size(workloadImage,1)
    for j = 1 : size(workloadImage,2)

    end
end

end

