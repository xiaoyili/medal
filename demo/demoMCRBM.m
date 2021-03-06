fprintf('\nHere we train a Mean-Covariance RBM on a dataset of\nwhitened 16x16 color image patches.\n\n');

load ('patchDataSmallRGB.mat','data','invXForm');

%  arch = [105 100 256 256]; % SHORTHAND [#Vis #hidMean #hidCov #Factors];

% REQUIRED ARCHITECTURE ARGUMENTS
arch = struct('nVis',105, ...
		      'nHidMean', 100, ...
              'nHidCov', 256, ...
              'nFactors', 256);
% GLOBAL OPTIONS
arch.opts = {'eta0',.175, ...
			 'wPenalty', .01, ...
			 'batchSz',128, ...
			 'nEpoch', 50, ...
			 'displayEvery',100, ...
			 'beginAnneal', 10, ...
			 'beginWeightDecay',20, ...
			 'beginPUpdates', 40, ...
			 'useGPU', 0}; %, ...
%  			 'visFun',@visMCRBMPatchLearning};
	
mcr = mcrbm(arch);
mcr.auxVars.invXForm = single(invXForm); % FOR VISUALIZATIONS
mcr = mcr.train(data');  % DATA SHOULD BE [#VIS X #OBS]

% DISPLAY LEARNED FEATURES
close(gcf)
figure
subplottight(1,2,1,.15);
visPatchesRGB(mcr.C,invXForm);
title(sprintf('Learned Coviariance\nFeatures'))

subplottight(1,2,2,.15);
visPatchesRGB(mcr.W,invXForm);
title(sprintf('Learned Mean\nFeatures'))
