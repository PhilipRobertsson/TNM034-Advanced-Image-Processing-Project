function [maskOutput] = faceMask(imageInput)
%   FACEMASK Summary of this function goes here
%   Function to create a mask of the face in the image.
%   Based on Skin Detection and Segmentation of Human Face in Color Images
%   written by Baozhu Wang, Xiuying Chang, Cuixiang Liu.

% Image to work on
workloadImage = imageInput;

% Avrage of the color channels
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);
AR = double(0);
AG = double(0);
AB = double(0);

subplot(1,3,1);
imshow(R);

subplot(1,3,2);
imshow(G);

subplot(1,3,3);
imshow(B);

for i = 1 : size(workloadImage,1)
    for j = 1 : size(workloadImage,2)
        AR = double(AR + R(i,j));
        AG = double(AG + G(i,j));
        AB = double(AB + B(i,j));
    end
end

AR = double(AR / (i*j))
AG = double(AG / (i*j))
AB = double(AB / (i*j))

end

