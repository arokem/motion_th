function pressKey2Begin(display,dispString)% pressKey2Begin(display,[dispString])%%   Displays 'please click mouse any key to begin' on the SCREEN%   just below the center of the screen and waits for the %   user to press a key.%%   Optional string 'dispString' is displayed just above the%   center of the screen.%% SEE ALSO clickMouse2Begin dispStringInCenter% 1/20/97 gmb wrote it.pressString = 'please press any key to begin.';dispStringInCenter(display,pressString,0.55,'white');if exist('dispString')	dispStringInCenter(display,dispString,0.45,'white');endgetChar;dispStringInCenter(display,pressString,0.55,'background');if exist('dispString')	dispStringInCenter(display,dispString,0.45,'background');end