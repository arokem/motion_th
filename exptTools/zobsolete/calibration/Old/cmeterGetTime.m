function integrationTime = cmeterGetTime(synchFreq)% integrationTime = cmeterGetTime(synchFreq)%% find out the integration time needed for a particular synch frequency% by measuring the integration time with no synch and return an % integration time that is multiple of the synch period but closest to the% adaptive integration time.%% (couldn't use automatic synch because sometimes it fails to synch to% to monitor at measurement time, especially when target is uniform. % So setting integration time manually)% cmeter('SetParams', 0, 0, 1);       %% set synch,integration time,avgcnts = cmeter('Measure');a = cmeter('Cmd', 'D130');a = sscanf(a, '%f,%f');integrationTime = a(1);clear a;integrationTime = floor(integrationTime*synchFreq)/synchFreq;