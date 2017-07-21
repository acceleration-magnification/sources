% RES = spyrHigh(PYR, INDICES)
%
% Access the highpass residual band from a steerable pyramid.

% Eero Simoncelli, 6/96.

function res =  spyrHigh(pyr,pind,nlevel,orientation)
% nlevel is number of pyramid level kept. 

if nlevel == 0
    %res  = pyrBand(pyr, pind, 1);
    res  = reshape( pyr(pyrBandIndices(pind,1)), pind(1,1), pind(1,2) );
    res  = res(:);
else 
    band = nlevel*orientation;
    ind = 1;
    for l=1:band+1
        ind = ind + prod(pind(l,:));
    end
    res = pyr(1:ind-1);
end
        
