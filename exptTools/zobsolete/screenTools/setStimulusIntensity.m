function stimulus = setStimulusIntensity(display,staircase,intensity)% stimulus = setStimulusIntensity(display,staircase,intensity)%% edits stimulus to show at a new intensity.%1/23/97 gmb wrote it, updated 2/10/98 DJFparams = staircase.stimParams;%update staircase.stimulus attributeevalstr = (['params.',staircase.intensityParamName,'= ',num2str(intensity),';']);eval(evalstr);%call stimFunction to update stimulus matricesevalstr = (['stimulus = ',staircase.stimFunction,'(display,params);']);eval(evalstr);