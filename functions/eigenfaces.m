function [weightsEigenfaces, meanFace, eigenFaces] = eigenfaces(imagesDB1)
% EIGENFACES - A MATLAB implementation of face recognition using eigenfaces.
% This script computes eigenfaces using PCA. The weights from DB1 are
% returned

% Compute mean face
meanFace = mean(imagesDB1, 2);

% Subtract mean face from each image vector
bigPhi = imagesDB1 - meanFace;

% Compute eigenvectors of the covariance matrix
transposeOfA = bigPhi'; % Transpose of the matrix
B = transposeOfA * bigPhi; % Covariance matrix
[eigenVectors, eigenValues] = eig(B); % Eigen decomposition

% Compute eigenfaces
eigenFaces = zeros(size(bigPhi, 1), size(bigPhi, 2));
for i = 1:size(bigPhi, 2)
    eigenface = bigPhi * eigenVectors(:, i);
    eigenFaces(:, i) = eigenface / norm(eigenface); % Normalize eigenfaces
end

% Display the mean face
% figure;
%mean_face_img = reshape(mean_face, size(cropped));
%imshow(mean_face_img, []);
%title('Mean Face');

% Compute weights for training images
weightsEigenfaces = eigenFaces' * bigPhi;

end
