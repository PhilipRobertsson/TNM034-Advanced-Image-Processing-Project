%%%%%%%%%%%%%%%%%%%%%%%%%%
function id = findFace(im)

%
% im: Image of unknown face, RGB-image in uint8 format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’
% and ‘0’ for all other faces.
%

% Load the database with db1
temp = load('all_images.mat'); % temp is a struct with a field 'imagesAsVectors'
imagesDB1 = temp.imagesAsVectors; % imagesDB1 is a numeric matrix

% Extract eigenfaces for DB1 and weights are returned
[weightsDB1, meanFace, eigenFaces] = eigenfaces(imagesDB1);

% Search for match in DB1
id = searchForMatch(im, weightsDB1, meanFace, eigenFaces);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%