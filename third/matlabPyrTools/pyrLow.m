% RES = pyrLow(PYR, INDICES)
%
% Access the lowpass subband from a pyramid 
%   (gaussian, laplacian, QMF/wavelet, steerable).

% Eero Simoncelli, 6/96.

function res =  pyrLow(pyr,pind,nlevel,norientation)
% nlevel is number of pyramid level kept. 


if nlevel == 0
    band = size(pind,1);
    res = reshape( pyr(pyrBandIndices(pind,band)), pind(band,1), pind(band,2) );
else
    band = nlevel*norientation;
    ind = 1;
    for l=size(pind,1):-1:size(pind,1)-band
        ind = ind + prod(pind(l,:));
    end
    res = pyr(end-ind:end);
end

