function eigenfaces
    % EIGENFACES - A MATLAB implementation of face recognition using eigenfaces.
    % This script performs the following:
    % 1. Reads and preprocesses a set of face images.
    % 2. Computes eigenfaces using PCA.
    % 3. Searches for a match for a given input image in the training database.

    %STEP 1 and 2 should maybe be done differently, beacuse
    %guidelines where to store the imanges in a mat-file?? (Daniel)

    % Define the image file paths
    %image_files = {
     %   "db1_01.jpg", "db1_05.jpg", "db1_09.jpg", "db1_13.jpg"; 
     %   "db1_02.jpg", "db1_06.jpg", "db1_10.jpg", "db1_14.jpg"; 
     %   "db1_03.jpg", "db1_07.jpg", "db1_11.jpg", "db1_15.jpg"; 
     %   "db1_04.jpg", "db1_08.jpg", "db1_12.jpg", "db1_16.jpg"
    %};

    %save('all_images.mat', 'image_files');
    
    load('all_images.mat', 'im_as_vec'); % Load the matrix with images
    
    num_images = size(im_as_vec, 2);

    image_files = reshape(all_images, 1, 16); % Reshape into a 1D array
    im_as_vec = []; % Initialize vectorized image storage

    % Preprocess images: convert to grayscale, normalize, and crop
    for i = 1:16
        img = imread(image_files{i}); % Read image
        gray = rgb2gray(img); % Convert to grayscale
        norm_img = double(gray) / 255; % Normalize pixel values
        
        % Replace with the normalization for when eyes are found.
        cropped = norm_img(170:460, 70:320); % Crop region of interest REPLACE
        
        
        im_as_vec = [im_as_vec, cropped(:)]; % Convert to vector and store

    end

    % Compute mean face
    mean_face = mean(im_as_vec, 2);

    % Subtract mean face from each image vector
    big_phi = im_as_vec - mean_face;

    % Compute eigenvectors of the covariance matrix
    A_transpose = big_phi'; % Transpose of the matrix
    B = A_transpose * big_phi; % Covariance matrix
    [eig_vectors, eig_values] = eig(B); % Eigen decomposition

    % Compute eigenfaces
    eig_faces = zeros(size(big_phi, 1), size(big_phi, 2));
    for i = 1:size(big_phi, 2)
        eigenface = big_phi * eig_vectors(:, i);
        eig_faces(:, i) = eigenface / norm(eigenface); % Normalize eigenfaces
    end

    % Display the mean face
    % figure;
    %mean_face_img = reshape(mean_face, size(cropped));
    %imshow(mean_face_img, []);
    %title('Mean Face');

    % Compute weights for training images
    weights_train = eig_faces' * big_phi;

    % Test image preprocessing
    test_img = imread('db1_01.jpg'); % Replace with the test image path
    gray = rgb2gray(test_img);
    norm_img = double(gray) / 255;
    cropped = norm_img(170:460, 70:320); %REPLACE
    phi_test = cropped(:) - mean_face; % Mean-adjusted test image

    % Compute weights for the test image
    weights_test = eig_faces' * phi_test;

    % Compute Euclidean distances between test image and training images
    distances = vecnorm(weights_train - weights_test, 2, 1);
    [min_distance, match_index] = min(distances);

    % Threshold for matching
    threshold = 10; % Adjust if needed
    if min_distance < threshold
        disp([num2str(match_index)]);
        matched_image = imread(image_files{match_index});
        figure;
        imshow(matched_image); % REMOVE BEFORE HANDING IN
        title('Matched Image');
    else
        disp('0');
    end
end