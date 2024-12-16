function prepareDatabase
% prepareDatabase - Read all images and store in a .mat-file

imageFiles = {
    "db1_01.jpg", "db1_05.jpg", "db1_09.jpg", "db1_13.jpg";
    "db1_02.jpg", "db1_06.jpg", "db1_10.jpg", "db1_14.jpg";
    "db1_03.jpg", "db1_07.jpg", "db1_11.jpg", "db1_15.jpg";
    "db1_04.jpg", "db1_08.jpg", "db1_12.jpg", "db1_16.jpg"
    };

flatFiles = imageFiles(:); % This makes it a 16x1 cell array

% Images as vectors
imagesAsVectors = [];

for i = 1:length(flatFiles)
    img = imread(flatFiles{i}); % Read image

    imgLC = lightCompensation(img); % Preform light compensation to assure all images are simmilar
    imgCr = cropImage(imgLC, 0.8); % Crop all images to be the same sizes and only contain relavant features
    imgGray = rgb2gray(im2double(imgCr)); % Convert image to gray for computational simplificationS

    imagesAsVectors = [imagesAsVectors, imgGray(:)]; % Store in matrix
end

% Save all images as matrix in a .mat-file
save('all_images', 'imagesAsVectors');
end
