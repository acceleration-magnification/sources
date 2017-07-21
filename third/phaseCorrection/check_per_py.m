
function ph_idx = check_per_py(pyr, pind, params, fig_on)

nLevels     = spyrHt(pind);            % Number of pyramid levels
nBands      = spyrNumBands(pind);       % Number of orientations per pyramid level
ph_idx     = zeros(length(pyr),1);

for level = 1:nLevels
    % Magnitude threshold for each pyramid level
    phase_thres = params.lambda/2;   %params.lambda;
    % Get level size (i.e. [18,23])
    dims = pind((2+nBands*(level-1)),:);
    % Total number of pixels for one pyramid level
    Pix_per_py = dims(1,1)*dims(1,2)*nBands;
    if level == 1   % For the first level
        start_idx   = 1;
        end_idx     = Pix_per_py;
    else
        start_idx   = end_idx+1;
        end_idx     = start_idx+Pix_per_py-1;
    end
    
    pyr_per_level = pyr(start_idx:end_idx);
    ph_idx(start_idx:end_idx) = abs(pyr_per_level)>=phase_thres;
    
    if fig_on == 1
        % First we are interested the variation of magnitude difference under different pyramid level  
        figure; 
        hist(pyr_per_level,500)
        xlabel(['magnitude threshold ', num2str(phase_thres) ,' in pyramid level ', num2str(level)])
        ylabel('frequency')
        % Next, we try to see which pixels are eliminated
        for ij = 1:nBands
            im2show = zeros(dims(1,1), dims(1,2));
            ph_idx_im = ph_idx(start_idx+(ij-1)*dims(1,1)*dims(1,2):start_idx+ij*dims(1,1)*dims(1,2)-1);
            ph_idx_im = reshape(ph_idx_im, [dims(1,1), dims(1,2)]);
            im2show   = im2show + ph_idx_im;
        end
        im2show (im2show>1) = 1;
        figure, imshow(im2show)
        title(['magnitude/phase difference in pyramid level ', num2str(level),':[', num2str(dims(1,1)), ',', num2str(dims(1,2)),']'] )
    end
    
    
    

end