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


% Cr/Cg Mask skin mask
maskCrCg =Cr - Cg;
maskCrCg(maskCrCg<0) = 0;
maskCrCg = 1.5 * sqrt(maskCrCg);
maskCrCg = (maskCrCg >= 0.005);

% Hair mask used to remove hair from image
hairMask =1.5 * (sqrt(Cg - Y));
hairMask(hairMask<=0) = 0;
hairMask = (hairMask >= 0.7);

% Shadow mask used to remove shadows in the background
shadowMask =0.9 *  sqrt(Cr - Cb);
shadowMask = 1.2 * (shadowMask - sqrt(Cr-Cg));
shadowMask(shadowMask<=0) = 0;
shadowMask = (shadowMask >= 0.15);

% Edge mask
workloadImageGray = im2gray(workloadImage);
Sobx = [-1,-2,-1;0,0,0;1, 2, 1];
Soby = [-1,0,1;-2,0,2;-1, 0, 1];

imgSobx =filter2(Sobx,workloadImageGray,'same');
imgSoby = filter2(Soby,workloadImageGray,'same');

maskEdge = sqrt(imgSobx.^2+ imgSoby.^2);
maskEdge = (maskEdge > 0.6);

% Combine color mask, edge mask, hair mask and shadow mask
maskComb = (maskCrCg == 1) & (maskEdge == 0);
maskComb = maskComb - hairMask - shadowMask;
maskComb = imbinarize(maskComb);

% Morpholigical Operations
SE1=strel("line",40,90);
maskComb = imclose(maskComb,SE1);
SE2=strel("line",54,90);
maskComb = imclose(maskComb,SE2);

% Save largest element which is the face
cropped = bwareafilt(maskComb,1);

% Morpholigical Operations
SE3=strel("rectangle", [110,100]);
cropped = imclose(cropped,SE3);

SE4=strel("disk", 15);
cropped = imerode(cropped,SE4);

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

