function [weightsEigenfaces, meanFace, eigenFaces] = eigenfaces(imagesDB1)
% EIGENFACES - A MATLAB implementation of face recognition using eigenfaces.
% This script computes eigenfaces using PCA. The weights from DB1 are
% returned.

% Compute mean face
meanFace = mean(imagesDB1, 2);

% Subtract mean face from each image vector
bigPhi = imagesDB1 - meanFace;

% Compute eigenvectors of the covariance matrix
transposeOfA = bigPhi'; % Transpose of the matrix
B = transposeOfA * bigPhi; % Covariance matrix
[eigenVectors, eigenValues] = eig(B); % Eigen decomposition

% Sort eigenvalues in descending order and rearrange eigenvectors accordingly
[eigenValuesSorted, indices] = sort(diag(eigenValues), 'descend');
eigenVectors = eigenVectors(:, indices);

% Select the 5 most important eigenfaces
numImportantEigenfaces = 5;
selectedEigenVectors = eigenVectors(:, 1:numImportantEigenfaces);

% Compute the top 5 eigenfaces
eigenFaces = zeros(size(bigPhi, 1), numImportantEigenfaces);
for i = 1:numImportantEigenfaces
    eigenface = bigPhi * selectedEigenVectors(:, i);
    eigenFaces(:, i) = eigenface / norm(eigenface); % Normalize eigenfaces
end

% Compute weights for training images using the selected eigenfaces
weightsEigenfaces = eigenFaces' * bigPhi;

end
