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

%prepareDatabase;

for i = 1:16
    if(i > 9)
        img = imread((sprintf('db1_%d.jpg',i)));
    else
        img = imread((sprintf('db1_0%d.jpg',i)));
    end
      img = img * 1.1;
      imgLC = lightCompensation(img);
      [imgFM, imgT] = faceMask(imgLC);
      [imgE, centroidsEyes] = findEyes(imgFM,imgT);

      subplot(4,4,i)
      imshow(imgE.*imgT);

    if(i >9)
        title(sprintf('db1-%d',i));
    else
        title(sprintf('db1-0%d',i));
    end
end



