%% Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!! 

function decomposition = decompose(im,params,nlevel_h,nlevel_l,fig_on)
    % params.nFrames: Number of frames to interpolate;
    % params.nOrientations: Number of orientations in the steerable pyramid;
    % params.tWidth: Width of transition region;
    % params.scale: Steepness of the pyramid;
    % params.limit: Maximum allowed shift in radians;
    % params.nScales: Number of levels of the pyramid.
%% convert image to LAB
cform = makecform('srgb2lab');
im = applycform(im,cform);
im = im2single(im);
im_dims = size(im);

%% for each color channel
for i=1:size(im,3)
    % Build the pyramid
    [pyr, pind] = buildSCFpyr_scale(im(:,:,i),params.nScales,...
         params.nOrientations-1,params.tWidth,params.scale,...
         params.nScales,im_dims);
     
    if fig_on == 1
        [pyr, pind] = buildSCFpyr(im(:,:,i));
        showSpyr(pyr,pind);
    end
    
    % Store decomposition residuals
    high_pass = spyrHigh(pyr,pind,nlevel_h,params.nOrientations);
    low_pass = pyrLow(pyr,pind,nlevel_l,params.nOrientations);
    decomposition.high_pass(:,i) = high_pass(:);
    decomposition.low_pass(:,i) = low_pass(:);
    
    % Used in decomposition phase and magnitudes
    high_pass_ph_mag = spyrHigh(pyr,pind,0,params.nOrientations);
    low_pass_ph_mag = pyrLow(pyr,pind,0,params.nOrientations);
    
    % Store decomposition phase and magnitudes
    pyr_levels = pyr(numel(high_pass_ph_mag)+1:numel(pyr)-numel(low_pass_ph_mag));        
    decomposition.phase(:,i) = angle(pyr_levels);
    decomposition.amplitude(:,i) = abs(pyr_levels);  
    
end

    % Store indices (same every channel)
    decomposition.pind = pind;
    decomposition.nlevel_h = nlevel_h;
    decomposition.nlevel_l = nlevel_l;
    decomposition.nOrientations = params.nOrientations;

end

