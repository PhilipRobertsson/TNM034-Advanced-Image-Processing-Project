function [maskOutput, translatedImage] = faceMask(imageInput)

% Image to work on
workloadImage = im2double(imageInput);

% Color space change with image
YCbCr = rgb2ycbcr(workloadImage);

% Split RGB into separate channels
R = workloadImage(:,:,1);
G = workloadImage(:,:,2);
B = workloadImage(:,:,3);

% Split YCbCr image into separate channels
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cg = (128/255) - (81.085/255)*R + (122/255)*G - (30.915/255)*B;
Cr = YCbCr(:,:,3);

% skin mask
skinMask = (Cr./Cg);
skinMask(skinMask <= 0.95) = 0;
skinMask = imbinarize(skinMask);

% hair mask
hairMask = Cg ./ Y;
hairMask = imbinarize(hairMask);

shadowMask =1.5 * ((1-Cr) - Cb);
shadowMask = imbinarize(shadowMask);

maskComb =(skinMask - hairMask) - shadowMask;

% Morpholigical Operations
SE1=strel("rectangle",[1 1]);
maskComb = imerode(maskComb,SE1);

SE2 = strel('disk',5);
maskComb = imclose(maskComb, SE2);

% Save largest element which is the face
cropped = bwareafilt(imbinarize(maskComb),1);

SE2=strel("rectangle", [150,180]);
cropped = imclose(cropped,SE2);

% Find centroid of face
s = regionprops(cropped, 'centroid');
centroid = cat(1, s.Centroid);

% Translate face to center of image
centroidX = centroid(:,1);
centroidY = centroid(:,2);
imageCenterY = floor(size(workloadImage,1)/2);
imageCenterX = floor(size(workloadImage,2)/2);

diffX = imageCenterX - centroidX;
diffY = imageCenterY - centroidY;

% Return the finalized mask and the translated image
maskOutput = imtranslate(cropped,[diffX, diffY],'FillValues',0,OutputView='full');
translatedImage = imtranslate(workloadImage,[diffX, diffY],'FillValues',0,OutputView='full');

end