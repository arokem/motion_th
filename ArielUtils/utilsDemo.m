%utilsDemo.m
%This script demonstrates the use of the utility scripts in:
%Applications/MATLAB71/toolbox/matlab/michael_silver/OSX/Ariel/ArielUtils
%The task performed here is a discrimination of circles from squares.
%
%11/22/2006 ASR wrote it

clear all; close all;
AssertOpenGL; %Makes sure that OpenGL is working
Priority(9); %Make sure to run this at highest priority
Screen('Preference','VisualDebugLevel',0); %Suppress various bells and whistles
Screen('Preference','SkipSyncTests',1);

[params]=demoParams; %Load parameters from parameter file

bkColor='black'; %sets the background color
txtColor='white'; %sets the color of the text
message = 'press any key to begin'; %message to be shown

%getScannerDisplay.m is a function that gets the valaues of the display
%struct. Primarily it retrieves information about the display from:
%/Applications/MATLAB71/MRI/Displays
[display]=getScannerDisplay; %getScannerDisplay called with default values

%setBkColor sets the background color of the display:
setBkColor(display.windowPtr,display.reservedColor,bkColor); %setBkColor called with the value of bkColor set above

%putMessage can display a simple message to the screen, for example in
%order to prompt a response from the subject:
putMessage(display.windowPtr,message,display.reservedColor,txtColor)%putMessage called with the values of txtColor and message set above.

%getAnyKey gets a key press from the fORP, the keypad or a keyboard,
%depending on the location (the scanner or the psychophysics rooms)
getAnyKey(display);

%%Screen flips again to indicate that the subject has pressed the key
Screen('Flip',display.windowPtr);

%timeToEndTrial keeps track of the time and makes sure that when waitTill
%is called it exits at the right time:
timeToEndTrial = 0;		% Total time from beginning of scan at which the current trial must end

%getStartScan sets the time of beginning the scan to the time of the first
%ttl pulse (if in the scanner) and sets the time of the beginning of the
%scan (or session) to this function call otherwise:
time=getStartScan (params.scanner);


%%The stimulus is presented in the center of the screen:
center=[display.numPixels(1)/2; display.numPixels(2)/2];

%loop through the trials
for trial=1:params.numOfTrials

    is_square=round(rand);
    if is_square
        Screen('DrawDots', display.windowPtr,center,10,[],[],0);  % change 1 to 0 to draw square dots
    else
        Screen('DrawDots', display.windowPtr,center,10,[],[],1);  % change 1 to 0 to draw square dots
    end

    Screen('Flip', display.windowPtr);
    WaitSecs(params.trialDuration)
    Screen('Flip', display.windowPtr);
    
    %Update timeToEndTrial:
    timeToEndTrial = timeToEndTrial+params.trialDuration;
    
    %and wait until timeToEndTrial:
    waitTill_OSX(timeToEndTrial,display,time);

    %getResponse gets a keypress from the fORP (if in the scanner) or from
    %the keypad or keyboard otherwise. It records the value of the keypress
    %as well as the RT.
    %Also, it waits the appropriate time (responseDuration) before exiting
    %with an empty keyHit:

    [keyHit RT timeToEndTrial]=getResponse(display, params.responseDuration,time,timeToEndTrial)

    %The following lines of code determine whether the response was
    %correct.
    %First, set the responses that are collected according to whether this
    %is the scanner or not:

    if isfield(display,'forpnum')
        key_square=['r' 'y'];
    else
        key_square=['1' '2'] ;
    end
    
    %Then call judgeResponse, which can flexibly determine whether a 2AFC
    %response was the correct response:
    correct = judgeResponse (is_square,keyHit,key_square)

    %Again wait until the appropriate time:
    timeToEndTrial=timeToEndTrial+params.interTrialDuration;
    waitTill_OSX(timeToEndTrial,display,time);

end

%postSessOps makes sure that the time the behaviroal task took was correct
%and gets ttl pulses from the scanner (if in the scanner) in order to
%verify that there is synchronmization between the behavioral code and the
%scanning:
postSessOps(params.scanner,display,params.numOfTrials,params.responseDuration+params.trialDuration+params.interTrialDuration,time)

%Close all the screens and lower to minimal priority:
Screen('CloseAll')
Priority(0);
ShowCursor;