%%% Authors: Dr. Seyran Khademi.
%%% Code rewritten from Yichao Zhang.
%%% Date: July 2017.

% This function is used to build the convolution kernel for the temporal processing.
% The function takes the video parameters and genrated 1D kernel     
function [kernel] = tempkernel(params)

    %% Parameters
    frameRate     = params.fr;
    time_interval = params.time_interval;

    % Find out frame interval.
    frame_interval = ceil(frameRate*time_interval);

    % Window size of our method (original one)  
    windowSize = 2*frame_interval;                          
    signalLen  = (windowSize*2);                            
    sigma      = frame_interval/2;
    x          = linspace(-signalLen / 2, signalLen / 2, signalLen+1);
    mode       = params.kernel;
    kernel     = zeros(size(x));

    if mode == 'DOG'
        sigma1 = sigma/2; % Gaussian kernel size  
        sigma2 = sigma*2;

        % build DOG kernel
        % (Comment: kernel generated should meet two requirements    :
        %    (1) sum(DOG_kernel) = 0
        %    (2) sum(abs(DOG_kernel)) = 1

        gaussFilter1 = exp(-x .^ 2 / (2 * sigma1 ^ 2));
        gaussFilter1 = gaussFilter1 / sum (gaussFilter1); % normalize
        gaussFilter2 = exp(-x .^ 2 / (2 * sigma2 ^ 2));
        gaussFilter2 = gaussFilter2 / sum (gaussFilter2); % normalize
        DOG_kernel   = gaussFilter1-gaussFilter2; % DOG

        % normalization so that maximum value of the kernel is 1.
        DOG_kernel = DOG_kernel./sum(abs(DOG_kernel)); % 'Normalization'
        %figure, plot(DOG_kernel, 'r')
        kernel = DOG_kernel;

    % build INT kernel     
    elseif mode == 'INT'        
        INT_kernel = kernel;  
        INT_kernel(1+frame_interval)=0.5;
        INT_kernel(1+2*frame_interval)=-1;
        INT_kernel(1+3*frame_interval)=0.5;
        kernel = -INT_kernel./sum(abs(INT_kernel));
    end
end
