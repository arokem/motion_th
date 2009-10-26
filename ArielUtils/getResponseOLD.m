%function [keyHit RT timeToEndTrial]=getResponse(display,responseDuration,time, timeToEndTrial)
%
%This function gets a response from a user. The function waits for a keypress
%and outputs the identity of the keypress, as well as the RT of the keypress
%relative to the function call.
%
%<display> is a struct that contains a field "keyboarddevnum" (per default)
%and can contain a field "forpnum" (if in the varian scanner) or
%"keypaddevnum" (if in the psychophys setup in Minor Hall.)
%
%<responseDuration> The time within which a response needs to be made,
%before the program goes on to the next trial
%
%Example:
%[keyHit RT]=getResponse(display, params.responseDuration);
%
%11/22/2006 ASR wrote it
%03/02/2007 ASR:THIS IS AN OUTDATED VERSION RELEVANT FOR motion_th{1,2,4} and texture_discrimination{1-5} 
%

function [keyHit RT timeToEndTrial]=getResponseOLD(display,responseDuration,time,timeToEndTrial)

keyIsDown=0; keyCode = 0; rtime = GetSecs; keyHit = '';
correct=0; RT=-1;
while (GetSecs < (rtime + responseDuration) & keyCode == 0)
    keyCode = 0; WaitSecs(0.001);
    if isfield(display,'keypaddevnum')
        [keyIsDown,secs,keyCode]=PsychHID('KbCheck',display.keypaddevnum);
    elseif isfield(display,'forpnum')
        [keyIsDown,secs,keyCode]=PsychHID('KbCheck',display.forpnum);
    else
        [keyIsDown,secs,keyCode]=PsychHID('KbCheck',display.keyboarddevnum);
    end

    if (keyIsDown & (find(keyCode) ~= 23)) %this prevents TTL pulses from being registered as responses
        break
    end
    keyCode = 0;
end



timeToEndTrial = timeToEndTrial + responseDuration;
waitTill_OSX(timeToEndTrial,display,time);




if find(keyCode) ~= 0 %some kind of keypress
    RT = secs - rtime;
    keyHit = KbName(find(keyCode));
    if length(keyHit) == 2
        keyHit = keyHit{2};
    end
end
