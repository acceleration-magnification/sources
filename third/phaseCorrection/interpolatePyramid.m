%% Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!! 

% Interpolate the pyramid given a specific alpha value
function out_pyr = interpolatePyramid(L, R, phase_diff, alpha)

nlevel_h = L.nlevel_h;
nlevel_l = L.nlevel_l;
nOrientations = L.nOrientations;
pind = L.pind;
% Compute new phase
new_phase =  R.phase + (alpha-1)*phase_diff;

% Blend amplitude and lowpass
new_amplitude = (1-alpha)*L.amplitude + alpha*R.amplitude;
new_lowpass = (1-alpha)*L.low_pass + alpha*R.low_pass;

% Compute new pyramid
new_pyr = new_amplitude.*exp(1i*new_phase);
res = [];

if nlevel_h > 0
    band = nlevel_h*nOrientations;
    ind = 1;
    for l=2:band+1
        ind = ind + prod(pind(l,:));
    end
    res = 1: ind-1;
end
if nlevel_l > 0
    band = nlevel_l*nOrientations;
    ind = 1;
    for l=size(pind,1)-1:-1:size(pind,1)-band
        ind = ind + prod(pind(l,:));
    end
    res = [res, length(pyr)-ind: length(pyr)];
end

if isempty(res) == 0
    new_pyr(res,:) = [];
end

% Using either left or right highpass
if alpha < 0.5
    high_pass = L.high_pass;
else
    high_pass = R.high_pass;
end

out_pyr = [high_pass;new_pyr;new_lowpass];

end

