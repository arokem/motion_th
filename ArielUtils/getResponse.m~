%function [keyHit RT timeToEndTrial]=getResponse(display,responseDuration)
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
%03/02/2007 ASR: Took out the waitTillOSX - the wait needs to be added to
%                the trial loop outside the function
%021508 ASR: made it compatible with NIC (changed the ttl pulse from a 't'
%to a '5')
%110108 made it compatible with the 3T (changed the ttl pulse from a 't'
%to a '5%')

function [keyHit RT]=getResponse(display,responseDuration)

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

    if (keyIsDown & (find(keyCode) ~= 34)) %this prevents TTL pulses from being registered as responses (93 = '5'? 34='5%'!)
        break
    end
    keyCode = 0;
end


if find(keyCode) ~= 0 %some kind of keypress
    RT = secs - rtime;
    keyHit = KbName(find(keyCode));
    if length(keyHit) == 2
        keyHit = keyHit(1);
    end
end