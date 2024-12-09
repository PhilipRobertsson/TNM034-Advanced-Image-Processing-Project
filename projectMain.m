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



