%function putMessage(windowPtr,[message],[reservedColor],[txtColor],[flip],[height])
%
%Displays a one line message in the center if the screen that the subject
%is looking at. This function is probably not good if you care about where
%exactly the text appears or what size it is
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
%<txtColor> is a string with name of the text color name
%according to the structure of reservedColor. Defaults to 'black'.
%
%<flip> 0/1 of whether to show the text in mirror reversal. Defaults to 0
%
%<height> is a double containing the height (in pixels) where to put the
%message. Defualts to the middle of the screen.
%
%EXAMPLE:
%putMessage(display.windowPtr, 'Hello World!", display.reservedColor,'red', 1)
%putmessage(display.windowPtr)
%
%11/20/2006 ASR wrote it

function putMessage(windowPtr,message,reservedColor,txtColor,flip,height)


[numPixelsWidth numPixelsHeight]=Screen('WindowSize',windowPtr);
textSize=numPixelsWidth/16;

if nargin<6
    height=numPixelsHeight/2;
    if nargin<5
        flip=0;
        if nargin<4
            txtColor='black';
            if nargin<3
                reservedColor=makeReservedColor;
                if nargin<2
                    message='press any key';
                end
            end
        end
    end
end

screenRect = Screen ('Rect',windowPtr);
Screen('TextFont', windowPtr, 'Arial');


txtColorNum = findName(reservedColor,txtColor);
Screen('TextSize', windowPtr, textSize);
[normRect, offsetRect] = Screen('TextBounds', windowPtr, message);
textRect=CenterRect(normRect, screenRect);
x=textRect(1);
y=height;

if flip

    textbox = Screen('TextBounds',windowPtr , message);
    textbox = OffsetRect(textbox, x, y);
    [xc, yc] = RectCenter(textbox);
    Screen('glPushMatrix', windowPtr);
    Screen('glTranslate', windowPtr, xc, 0, 0);
    Screen('glScale', windowPtr, -1, 1, 1);
    Screen('glTranslate', windowPtr, -xc, 0, 0);
    Screen('DrawText', windowPtr, message, x, y,reservedColor(txtColorNum).gunVal);
    Screen('glPopMatrix', windowPtr);
else
    Screen('DrawText', windowPtr, message, x, y,reservedColor(txtColorNum).gunVal);
end
Screen('Flip',windowPtr);
