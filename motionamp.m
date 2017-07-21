%%% Authors: Dr. Seyran Khademi.
%%% Code rewritten from Yichao Zhang.
%%% Date: July 2017.


% This function takes the parameters of the video and magnifies the small local motions by factor alpha.
% Spatial Decomposition -> Kernel Generation -> Convolution -> Phase Correction -> Motion Magnification.
function motionamp(vid, params)

    %% Parameters
    amp_factor = params.amp_factor; % alpha
    frameRate  = params.fr;         % frame rate
    fr_num     = params.fr_num;     % number of frames

    % We select a real frame, then estimate frame before and after 'time_interval' sec. 
    % (Comment: Imagine a sine wave, with x axis time [t] and y axis magnitude [M]. 
    %      Resolution of this sine wave is 'motion_freq_es'.
    %      Now we try to estimate the time interval of one-quarter of this sine wave.)

    % Find out frame interval.
    time_interval  = params.time_interval;           
    frame_interval = ceil(frameRate*time_interval);

    % Window size of our method (original one)  
    windowSize = 2*frame_interval; 

    % Size of DOG kernel. In DOG kernel, we want the peak and two bottom value match our first method. So the length of DOG is set twice as the original window.     
    norder = (windowSize*2);                 

    %% Build the convolution kernel
    kernel = tempkernel(params);
    %figure, plot(kernel, 'r')
    
    %% Create new video(s) to write.
    vidOut_1           = VideoWriter(params.vid_out_name);
    vidOut_1.FrameRate = frameRate;
    open(vidOut_1)
    
    %% For the first frame       
    im         = read(vid, 1);
    im_stru    = decompose(im,params,0,0,0);
    phase_im_1 = reshape(im_stru.phase,[],1); % Phase of first frame in vector 
    phase_im   = repmat(phase_im_1,1,norder+1); 
    imwrite(im,fullfile(params.vid_out_frames,['fr', num2str(1),'.png']))

    %% Spatial Decomposition
    fprintf('\n %d frames to process \n',fr_num);
    fprintf('*****************************************\n');

    % We first need to collect phase information of frames, where number of frames should be equal to length of temporal kernel.
    % Frame index to be magnified, initialization.
    for ii = 2:50 %fr_num
        fprintf('spatial procesing frame %d\n',ii);
        % Read each frame (we start from the second frame), steerable decomposition
        im      = read(vid, ii);
        im_stru = decompose(im,params,0,0,0);

        % Contains phase, magnitude and scale per pyramid of image.  
         %% Unraaping the phase
        fac           = 1.5; % Parameter for phase correction.
        phase_im      = [phase_im reshape(im_stru.phase,[],1)];
        phase_im(:,1) = [];
        phase_im((phase_im(:,end) - phase_im(:,end-1))>fac*pi,end) = phase_im((phase_im(:,end) - phase_im(:,end-1))>fac*pi, end) - 2*pi; 
        phase_im((phase_im(:,end-1) - phase_im(:,end))>fac*pi,end) = phase_im((phase_im(:,end-1) - phase_im(:,end))>fac*pi,end) + 2*pi; 

        fprintf('temporal procesing frame %d\n',ii);
        %% Temporal filtering      
        % Convolution: we only need the result of convolution of middle frame.
        phase_im_conv = phase_im.*fliplr(kernel);
        phase_filt    = sum(phase_im_conv,2); % Phase difference

        ph2Mag  = im_stru.phase;
        amp_im2 = im_stru.amplitude; % Magnitude of im2
        pind    = im_stru.pind;
 
        %% Compute phase difference (from paper: 'Phase-based frame interpolation for video')
        phaseDiff = reshape(phase_filt,[],3);

        % Save the original phase difference for the last step.
        phaseDiffOriginal = phaseDiff;

        for ic = 1:size(phaseDiff,2)
            % compute shift correction (Eq. 10,11)
            phaseDiff(:,ic) =  shiftCorrection(phaseDiff(:,ic), pind, params);

            % unwrap phase difference to allow a smooth interpolation (Eq. 13)
            unrappedPhaseDifference = myUnwrap([phaseDiff(:,ic),phaseDiffOriginal(:,ic)], [], 2);

            % save and go to next level
            phaseDiff(:,ic) = unrappedPhaseDifference(:,2);
        end

        %% Motion magnification
        fprintf('motion magnification frame %d\n',ii);
        if amp_factor >= 1
            new_pyrv = amp_im2.*exp(1i*(ph2Mag+ amp_factor*phaseDiff));
        else
            new_pyrv = amp_im2.*exp(1i*(ph2Mag+ (amp_factor-1)*phaseDiff));
        end
        new_pyr = reshape(new_pyrv,[],3);
        out_pyr = [im_stru.high_pass;new_pyr;im_stru.low_pass];

        recon_im_amp = reconstructImage(out_pyr,params,im_stru.pind);
        writeVideo(vidOut_1,recon_im_amp);

        imwrite(recon_im_amp,fullfile(params.vid_out_frames, ['fr', num2str(ii),'.png']))
        fprintf('*****************************************\n');
    end
    close(vidOut_1);
end
    

    

    
    
    







