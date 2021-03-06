%function setBkColor(windowPtr,reservedColor,[bkColor])
%
%Sets the background color for an opened window.
%
%<windowPtr> is a double which is the ptr to the opened window on
%which the background is to be set
%
%<reservedColor> is a struct with fields:
%<reservedColor.name> which has the names of the colors
%<reservedColor.fbVal> which has serial numbers 0=>numOfColors
%<reservedColor.gunVal> is the [r g b] value for that color
%defaults to following values:'background' (which is grey),'black',
%'red', 'white', 'green'
%
%<bkColor> is a string with name of the background color to fill the screen
%with according to the structure of reservedColor. Defaults to 'background'.
%
%EXAMPLE: 
%setBkColor(display.windowPtr, display.reservedColor, 'black')
%
%11/20/2006 ASR wrote it
%


function setBkColor(windowPtr,reservedColor,bkColor)

if nargin<3
    bkColor='background';
    if nargin<2
        reservedColor=makeReservedColor;
    end
end

bkColorNum = findName(reservedColor,bkColor);
Screen('FillRect',windowPtr,reservedColor(bkColorNum).gunVal);
Screen('Flip',windowPtr);
Screen('FillRect',windowPtr,reservedColor(bkColorNum).gunVal);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
