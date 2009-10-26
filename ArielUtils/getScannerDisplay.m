%function [display bkColor]=getScannerDisplay ([scanner],[numPixels],[distance],[flip])
%
%Gets the display params for the "scanner" you are using, opens the screen
%and sets the background color.
%
%<scanner> is a double, where:
% 1 is Minor Hall Room 582D (the LCD)
% 2 is the Varian Scanner LCD display
% 3 is Minor Hall Room 582J (the CRT)
% 4 is NIC lcd
% 5 is BIC 3T Avotec projector
% 6 is the Davis scanner projector (?)
% 7 is the LCD monitor in the BIC3T
% 8 is ASR laptop with built in lcd
%
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
%11/20/06 ASR wrote it
%021508 ASR - added NIC lcd and BIC 3T Avotec
%102308 ASR - added Davis lcd

function display=getScannerDisplay (scanner,numPixels,distance,flip)

if nargin<1
    scanner=1; %default scanner to 1
end

%Load the display params from: /Applications/MATLAB71/MRI/Displays

switch scanner

    case 1
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','Minor_582D');
        display.flip = 0;
    case 2
        display = loadDisplayParams_OSX('cmapDepth', 8, 'displayName', 'Varian_scanner');
        display.flip = 1;
    case 3
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','Minor_582J');
        display.flip = 0;
    case 4
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','NIC_lcd');
        display.flip = 1;
    case 5
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','BIC3T_Avotec');
        display.flip = 0;
    case 6
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','Davis_scanner');
        display.flip = 0;
    case 7
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','LCD_monitor_3T');
        display.flip = 0;
    case 8
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','ASR_laptop_testing');
        display.flip = 0;
        case 10
        display = loadDisplayParams_OSX('cmapDepth', 8,'displayName','NNL');
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
