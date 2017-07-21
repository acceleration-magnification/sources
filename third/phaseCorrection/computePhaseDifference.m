% [1] Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!!

% [2] Acceleration Video Magnification
% This is a personal reimplementation by Yichao Zhang: zyctime@live.cn
% V 1.0: Yichao Zhang, Feb.26.2017

% compute shift corrected phase differences (interpolating unreliable phase
% estimates from the previous levels)
function phaseDiff = computePhaseDifference(phaseL, phaseR, pind, params)

% compute phase difference
phaseDiff = atan2(sin(phaseR-phaseL),cos(phaseR-phaseL));

% save the original phase difference for the last step
phaseDiffOriginal = phaseDiff;

% for each channel
for i=1:size(phaseL,2)
    
    %% compute shift correction (Eq. 10,11)
    phaseDiff(:,i) =  shiftCorrection(phaseDiff(:,i), pind, params);
    
    %% unwrap phase difference to allow a smooth interpolation (Eq. 13)
    unrappedPhaseDifference = myUnwrap([phaseDiff(:,i),phaseDiffOriginal(:,i)], [], 2);
    
    %% save and go to next channel
    phaseDiff(:,i) = unrappedPhaseDifference(:,2);
end

end

