%%% Author: Dr. Seyran Khademi.
%%% Code rewritten from Yichao Zhang.
%%% Date: July 2017.

% This function set the required parameters for motion magnification inputs are:
% 1) name of the video  e.g. 'baby' 
% 2) foramt of the video e.g. '.avi' or '.mp4'
% 3) the path to the raw video e.g. '/data/raw_vid'
% 3) the path to the result video to be stored e.g. '/data/result'
% 4) estimated motion frequency to be amplified 
% 5) the amplification factor.
function [vid_in , params] = setparameters(vid_in_name,vid_format,rawvidfilepath,resultvidfilepath,fm,alpha,kernel)

    %% Read video
    fullfile(rawvidfilepath,[vid_in_name,vid_format])
    vid_in = VideoReader(fullfile(rawvidfilepath,[vid_in_name,vid_format]));

    % Extract video info
    vidHeight = vid_in.Height;
    vidWidth  = vid_in.Width; 
    nChannels = 3;
    fr        = vid_in.FrameRate;   
    fr_num    = vid_in.NumberOfFrames;

    % Basic infomation of input videos
    params.vid_in_name = vid_in_name; % the input video name without video extension       
    params.vidHeight   = vidHeight;   % Height of video
    params.vidWidth    = vidWidth;    % Weight of video
    params.fr          = fr;          % frame rate
    params.fr_num      = fr_num;      % Number of frames of video
 
    % Parameters for spacial processing used in the paper.  
    % (Comment: Normally, no need to change the parameters below)
    params.nOrientations = 8;   % Number of orientations in the steerable pyramid
    params.tWidth         = 1;   % Width of transition region
    params.limit         = 0.2; % Maximum allowed shift in radians
    params.min_size      = 15;  % Number of levels of the pyramid
    params.max_levels    = 23;

    % Steepness of the pyramid (turn 1/4 into 1/2 or 1 if you think too slow).
    %(Lower the value, larger operation time, and less blurring in video after processing).
    params.py_level = 4;                                               
    params.scale    = 0.5^(1/params.py_level );
    params.nScales  = min(ceil(log2(min([vidHeight vidWidth]))/log2(1/params.scale) - ...
        (log2(params.min_size)/log2(1/params.scale))),params.max_levels);

    %% Video parameters to be set by the user.
    % Here one needs to fill in the estimated frequency of the motion to be amplitude.
    % (Comment: For example, we estimate the baby breathing frequency as 1Hz)
    motion_freq_es = fm;

    % We select a real frame, then estimate frame before and after 'time_interval' sec. 
    % (Comment: Imagine a sine wave, with x axis time [t] and y axis magnitude [M]. 
    % Resolution of this sine wave is 'motion_freq_es'.
    % Now we try to estimate the time interval of one-quarter of this sine wave.)

    params.time_interval = 1/4 * 1/motion_freq_es; % in sec. one quarter of sine wave.
    % params.chromAttenuation = 1;        % For intensity Magnification, ref. in paper 'Eulerian Mag....2012' 
    % params.level            = 4;        % For Gaussian Pyramid
    % params.motion_thres     = 0.3;

    params.amp_factor = alpha; % Small motion amplification factor.

    % (Comment: Larger the value of 'amp_factor', more blurrings appears. 
    %  If you want to attenuate motions, I suggest 'amp_factor=-1')
    params.kernel        = kernel; % DOG, LOG, INT, FIR
    params.vid_out_name  = fullfile(resultvidfilepath,[vid_in_name,'_fm_',num2str(motion_freq_es),'_alpha_',num2str(params.amp_factor),...
        '_pylevel_',num2str(params.py_level ),'_kernel_',params.kernel,'.avi']);
    params.vid_out_frames = fullfile(resultvidfilepath,vid_in_name,'im_write');
    mkdir(params.vid_out_frames)
end

% parameters:
    % (1) Basic infomation of input videos
    %       params.vidHeight;   Hright of video
    %       params.vidWidth ;   Width of video
    %       params.fr       ;   Frame rate
    %       params.fr_num   ;   Total frame number
    % (2) Parameters used in the paper
    %       params.nFrames  ;   Number of frames to interpolate
    %       params.nOrientations; Number of orientations in the steerable pyramid
    %       params.tWidth   ;   Width of transition region
    %       params.scale    ;   Steepness of the pyramid
    %       params.limit    ;   Maximum allowed shift in radians
    %       params.min_size ;   Minimum pyramid levels
    %       params.max_levels;  Maximum pyramid levels
    %       params.nScales  ;   Number of levels of the pyramid
