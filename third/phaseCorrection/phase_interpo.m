
function middle_frame = phase_interpo(params, im1, im2)

fig_on = 0;
nlevel_h = params.nlevel_h;       % Levels of large scales (contain high frequency) to keep 
nlevel_l = params.nlevel_l;       % Levels of small scales (contain low frequency) to keep 
%% Decompose images using steerable pyramid
L = decompose(im1,params,nlevel_h,nlevel_l,fig_on);
R = decompose(im2,params,nlevel_h,nlevel_l,fig_on);

%% Compute shift corrected phase difference
phase_diff = computePhaseDifference(L.phase, R.phase, L.pind, params);

%% Generate inbetween images
step = 1/(params.nFrames+1);
for f=1:params.nFrames
    alpha = step*f;
    
    % interpolate the pyramid
    inter_pyr = interpolatePyramid(L, R, phase_diff, alpha);
    
    % reconstruct the image from steerable pyramid
    recon_image = reconstructImage(inter_pyr,params,L.pind);
    
    if f == 1
        middle_frame = recon_image;
    else
        middle_frame(:,:,:,f) = recon_image;
    end

end


