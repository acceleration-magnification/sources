
function phase_out = phaseSpatialBlur( phase_matrix, mag_matrix, sigma )
% This function blur the phase matrix for different scale and orientation.
% We use an amplitude-weighted spatial Gaussian blur on the phases. (Equation 
% is similar as phase-based motion magnification paper, eq. 17)
% Inputs:
%   phase_matrix (N*M) phase matrix for one scale/orientation of the steerable pyramid.
%   mag_matrix   (N*M) magnitude matrix for ...
%   sigma        (scalar) std of Gaussian (blur) kernel.

    if (sigma~=0)
        kernel      = fspecial('gaussian', ceil(4*sigma), sigma);
        %sz         = size(kernel);
        mag_matrix  = mag_matrix+eps;
        phase_out   = imfilter(phase_matrix.*mag_matrix, kernel,'circular');
        weightMat   = imfilter(mag_matrix,kernel,'circular');
        phase_out   = phase_out./weightMat;
    else
        phase_out   = phase_matrix;
    end
end
