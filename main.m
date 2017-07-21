%%% Authors: Dr. Seyran Khademi.
%%% Code rewritten from Yichao Zhang. 
%%% Date: July 2017.

addpath(fullfile('third', 'matlabPyrTools'));
addpath(fullfile('third', 'matlabPyrTools', 'MEX'));
addpath(fullfile('third', 'phaseCorrection'));

%%% Synehtic ball video %%%%%%%%%%%%%%%%%%%%%%%%%%
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('syn_ball', '.avi', fullfile('data','raw_vid'), fullfile('data','result_vid'),10/3,5,'DOG');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc


%%% Cat toy video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('cat_toy','.mp4', fullfile('data','raw_vid'), fullfile('data','result_vid'),4,8,'INT');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

%%% Gun shot video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('gun_shot','.mp4',fullfile('data','raw_vid'),fullfile('data','result_vid'),8,8,'DOG');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

%%% Parkinson I video %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('parkinson1','.mp4',fullfile('data','raw_vid'),fullfile('data','result_vid'),3,8,'INT');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

%%% Parkinson II video %%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('parkinson2','.mp4',fullfile('data','raw_vid'),fullfile('data','result_vid'),3,8,'INT');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

%%% Bottle video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('bottle_moving','.mp4',fullfile('data','raw_vid'),fullfile('data','result_vid'),4,8,'INT');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

%%% Eye video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bulding the parameters for video to be processes
[vid_in,params] = setparameters('eye_raw','.mp4',fullfile('data','raw_vid'),fullfile('data','result_vid'),2.5,15,'DOG');
   
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
motionamp(vid_in,params);

% After generating video, clean everything.
clear all
clc

