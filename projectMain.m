% The main script, used to load images and call on functions from
% the folder "functions".
%
% To include functions use the line: 
%  addpath('./functions/)
%
% Avoid creation of functions in the main script, all complex operations
% should be created in the functions folder.
%
% Code written by
% Philip Robertsson, Caitlin Wu, Oscar Berglin, and Adham Kteileh
% at Linköpings Universitet in the course Advanced Image Processing TNM034


% Function and database includes
addpath('./functions/');         % All relevant functions
addpath('./images/DB0/');     % Images from database 0
addpath('./images/DB1/');     % Images from database 1
addpath('./images/DB2/');     % Images from database 2

prepareDatabase;
tx = 0;
ty = 0;
r = 0;
s = 0.9;
l = 1.0;

fprintf('Tx: %d, Ty: %d, R: %d, L: %d', tx, ty,r,l);
disp(" ");

for i = 1:16
    if(i > 9)
        img = imread(sprintf('db1_%d.jpg',i));
        imgCopy = img * l;
        imgCopy = imrotate(imgCopy, r,'crop');
        imgCopy = imtranslate(imgCopy,[tx ty]);
        imgCopy = imresize(imgCopy,s);
        imwrite(imgCopy, sprintf('./images/DB1/db1_%d_copy.png',i));
        imgName = sprintf('db1_%d_copy.png',i);
        imgCopy = imread(sprintf('db1_%d_copy.png',i));

    else
        img = imread(sprintf('db1_0%d.jpg',i));
        imgCopy = img * l;
        imgCopy = imrotate(imgCopy, r,'crop');
        imgCopy = imtranslate(imgCopy,[t t]);
        imgCopy = imresize(imgCopy,s);
        imwrite(imgCopy, sprintf('./images/DB1/db1_0%d_copy.jpg',i));
        imgName = sprintf('db1_0%d_copy.jpg',i);
        imgCopy = imread(sprintf('db1_0%d_copy.jpg',i));
    end
    
    %values(i) = tnm034(imgName);

    %imgLC = lightCompensation(img);
    %imgLCcopy = lightCompensation(imgCopy);

    %imgCr = cropImage(imgLC, 0.6);
    %imgCrcopy = cropImage(imgLCcopy, 0.6);

    %[imgFM, imgT] = faceMask(imgLC);
    %[imgFMcopy, imgTcopy] = faceMask(imgLCcopy);

    %[imgE, centE] = findEyes(imgFM,imgT);
    %[imgEcopy, centEcopy] = findEyes(imgFMcopy,imgTcopy);

    %[imgM, centM] = findMouth(imgFM,imgT);
    %[imgMcopy, centMcopy] = findMouth(imgFMcopy,imgTcopy);


    %subplot(4,4,i)
    %imshow(imgM.*imgT);

    %montage({imgE.*imgT,imgEcopy.*imgTcopy});
    %montage({imgE,imgEcopy});
    %montage({imgLC,imgLCcopy});
    %montage({imgFM.*imgT,imgFMcopy.*imgTcopy});
    %montage({imgM.*imgT,imgMcopy.*imgTcopy});
    %montage({imgCr, imgCrcopy});
    %imshow(im2gray(imgCr) - im2gray(imgCrcopy));

    if(i>9)
        %title(sprintf('db1-0%d.jpg',i));
    else
        %title(sprintf('db1-%d.jpg',i));
    end
end

%disp(values)
