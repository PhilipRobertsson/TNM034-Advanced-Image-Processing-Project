%%%%%%%%%%%%%%%%%%%%%%%%%%
function id = tnm034(im)

%
% im: Image of unknown face, RGB-image in uint8 format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’
% and ‘0’ for all other faces.
%

% Load the database with db1
load('database.mat', 'mean_face', 'eig_faces', 'weights_train');




%%%%%%%%%%%%%%%%%%%%%%%%%%