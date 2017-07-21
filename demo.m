%%% Author: Dr. Seyran Khademi.
%%% Code rewritten from Yichao Zhang.
%%% Date: July 2017.

% Input:
%    video_name      - name of the input video.
%    video_extension - the video extension. 
% Output:
%    data/result_vid/video_name/im_write - motion magnified video frames
%    data/result_vid/video_name.avi      - motion magnified video file
function demo(video_name, video_extension)

    % Add project paths
    addpath(fullfile('third', 'matlabPyrTools'));
    addpath(fullfile('third', 'matlabPyrTools', 'MEX'));
    addpath(fullfile('third', 'phaseCorrection'));

    % Bulding the parameters for video to be processes
    %[vid_in,params] = setparameters(video_name, video_extension, fullfile('data','raw_vid'), fullfile('data','result_vid'), 10/3,5, 'DOG');
    [vid_in,params] = setparameters(video_name, video_extension, fullfile('data','raw_vid'), fullfile('data','result_vid'), 4, 8, 'INT');
   
    % Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification
    motionamp(vid_in,params);

    % After generating video, clean everything.
    clear all
    clc
end
