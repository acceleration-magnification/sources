
% Build matlabPyrTools
fprintf('Building matlabPyrTools...\n');
addpath('third');
run(fullfile('third', 'matlabPyrTools', 'MEX', 'compilePyrTools.m'));

