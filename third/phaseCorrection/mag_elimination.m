

function mag_idx = mag_elimination(pyr, pind, params, fig_on)

params.tau_mag      = 0.02;
params.lambda_mag   = 1.8;
nLevels     =  spyrHt(pind);            % Number of pyramid levels
nBands      = spyrNumBands(pind);       % Number of orientations per pyramid level
tau_mag     = params.tau_mag;
lambda_mag  = params.lambda_mag;
mag_idx     = zeros(length(pyr),1);

% Start at the biggest/finest level
for level = 1:nLevels
    % Get level size (i.e. [18,23])
    dims = pind((2+nBands*(level-1)),:);
    % Total number of pixels for one pyramid level
    Pix_per_py = dims(1,1)*dims(1,2)*nBands;
    if level == 1   % For the first level
        start_idx = 1;
        end_idx = Pix_per_py;
    else
        start_idx = end_idx+1;
        end_idx = start_idx+Pix_per_py-1;
    end
    
    pyr_per_level = pyr(start_idx:end_idx);
    % Magnitude threshold for each pyramid level
    Mag_thres = tau_mag*lambda_mag^(level-1);
    Mag_thres = 2;
    mag_idx(start_idx:end_idx) = pyr_per_level>Mag_thres;
    
    if fig_on == 1
        % First we are interested the variation of magnitude difference under different pyramid level  
        figure; 
        hist(pyr_per_level,500)
        xlabel(['magnitude threshold ', num2str(Mag_thres) ,' in pyramid level ', num2str(level)])
        ylabel('frequency')
        % Next, we try to see which pixels are eliminated
        for ij = 1:nBands
            im2show = zeros(dims(1,1), dims(1,2));
            mag_idx_im = mag_idx(start_idx+(ij-1)*dims(1,1)*dims(1,2):start_idx+ij*dims(1,1)*dims(1,2)-1);
            mag_idx_im = reshape(mag_idx_im, [dims(1,1), dims(1,2)]);
            im2show = im2show + mag_idx_im;
        end
        im2show (im2show>1) = 1;
        figure, imshow(im2show)
        title(['magnitude difference in pyramid level ', num2str(level),':[', num2str(dims(1,1)), ',', num2str(dims(1,2)),']'] )
    end
    
    
    

end
    
    
    
    
    
    
    
    
    
    