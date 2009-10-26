% DATE:  	02.13.98% AUTHOR: 	Heidi Baseler, modified by William Press% PURPOSE:	Measures the GAMMA function of a display device%			Uses "cmeter" function written by D. Brainard for Matlab 5.1.%			Steps through calibration targets, reading data from the SpectraScan % 			PR650 colorimeter.% % HISTORY:	This script was modified from Xuemei Zhang's script "cmeterCalib.m" %			written in August, 1997 on Turquoise.% 			Adapted by HAB to calibrate NEC Flat Panel LCD Monitor with either %			vermillion in Jordan Hall or with ochre in the Lucas Center%%			Modified by WAP, 07.10.98.  Fixed bugs.  Separated testing%			routines and adjustable parameters to facilitate use.clear all%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET THESE PARAMETERSgammaFile = 'NEC3TRadius-10bit';% To check monitor numbering, go to "Monitors & Sound" under Control Panels, select% "Arrange" and click on "Identify the monitors"% Generally, for NEC (2nd) monitor, use monitor = 1; % for Mac console monitor AND FOR LUCAS CENTER, use monitor = 0monitor = 1;synchFreq = 200/3;		% Low res  - standard for NEC MultiSync LCD2000targetSize = [640 480];% Decide beforehand whether will test for linearity after calibration.testLinearity = 1;% Specify which colors to step through and calibrategunColors = [1 0 0; 0 1 0; 0 0 1];% Specify framebuffer values to measurenSteps = 32;p = 1.7;	% slope of the power functionfbValues = round(1023*linspace(0,1,nSteps).^(1/p));%fbValues = 0:31:1023;	% Use 0:93:1023 for testing, as it's faster%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN MEASUREMENTSdisp('Make sure the NEC LCD2000 monitor is plugged into the left-most video card slot')disp('To select the spatial and temporal parameters on the NEC MultiSync LCD2000,')disp('monitor, push the PROCEED button on monitor and scroll down to Display Mode.')disp('Be sure they match the selected parameters in the current calibration.')pause;% Measure the gamma curves for each selected colorrawGammaValues = cmeterNECgamma(targetSize, gunColors, fbValues, monitor, synchFreq);% Allen suggests subtracting the minimum measured output values to frame buffer% value [0 0 0] from all values, to remove the offset (rather than prepending % zeroes, as Mei did, which introduces a discontinuity and causes Matlab % (interp1) to complain that the function is nonmonotonic.%gammaValues = rawGammaValues-(ones(size(rawGammaValues,1),1)*min(rawGammaValues));% Normalize gammaTable to 1gammaValues = gammaValues * diag(1./max(gammaValues));% Interpolate to full size (1023)fb = [0:1023]';%[gamma10,fitParam,fitComment] = FitGamma(fbValues', gammaValues', fb);gamma10 = interp1(fbValues, gammaValues, fb);% I'm not sure why Mei interpolates further to 4095 - perhaps% to avoid some rounding errors?  Changed it back to 1023 - HAB, 02.16.98%n = 4095;n = 1023;levels = ([0:n]/n)';invGamma10 = zeros(n+1, 3);invGamma10(:,1) = interp1(gamma10(:,1), fb/1023, levels);invGamma10(:,2) = interp1(gamma10(:,2), fb/1023, levels);invGamma10(:,3) = interp1(gamma10(:,3), fb/1023, levels);invGamma10 = round(invGamma10*1023)/1023;% Replace NaNs with 1.0 - HAB, 02.16.98%boo  =  isnan(invGamma10);inds = find(boo);invGamma10(inds) = 1.0 * ones(size(inds));gammaTable = invGamma10*1023;% Save the results in an output filesave(gammaFile, 'gunColors', 'gamma10', 'invGamma10', 'rawGammaValues', 'gammaValues', ...				'fbValues', 'levels', 'monitor', 'synchFreq', 'targetSize', 'gammaTable');if (testLinearity==1)	testGamma(gammaFile);end