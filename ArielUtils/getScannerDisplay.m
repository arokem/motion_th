%function [display bkColor]=getScannerDisplay ([scanner],[numPixels],[distance],[flip])
%
%Gets the display params for the "scanner" you are using, opens the screen
%and sets the background color.
%
%<scanner> is a double, where:
% 1 is ASR laptop with built in lcd
% 2 is
%The default is 1
%
%
%<numPixels> is a 1x2 matrix describing the desired resolution, if
%different from the default for that display
%
%<distance> is a double with desired distance if different from the default
%for that display
%
%<flip> is 1/0 is a double determining whether the image presented should
%be l/r flipped due to projection through a mirror or for testing purposes
%if different than default
%
%EXAMPLE:
% myDisplay=getScannerDisplay(params.scanner,[800 600],125,1)
% myDisplay=getScannerDisplay
%

function display=getScannerDisplay (scanner,numPixels,distance,flip)

if nargin<1
    scanner=1; %default scanner to 1
end

%Load the display params from: /Applications/MATLAB71/MRI/Displays

switch scanner

    case 1
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','ASR_laptop_testing');
        display.flip = 0;
    case 2
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','Display2077b');
        display.flip = 0;

end

%Set optional variables
if nargin>1
    display.numPixels=numPixels;
    if nargin>2
        display.distance=distance;
        if nargin>3
            display.flip=flip;
        end
    end
end

display = openScreen_OSX(display);
