%function getAnyKey (display)
%
%Waits until any key is pressed on the HID: if keypad is present from that.
%Otherwise, if there is a forp, from that. Otherwise, from the keyboard.
%
%<display> is a struct that contains a field "keyboarddevnum" (per default)
%and can contain a field "forpnum" (if in the varian scanner) or
%"keypaddevnum" if in the psychophys setup in Minor Hall.
%
%11/20/2006 ASR wrote it
%
%

function getAnyKey (display)

keycode = 0;
while (sum(keycode)==0)
    WaitSecs(0.001);
    if isfield(display,'keypaddevnum')
        [keyIsDown,time,keycode]=PsychHID('KbCheck',display.keypaddevnum);

    elseif isfield(display,'forpnum')
        while sum(keycode)== 0 || keycode(34)
            [keyIsDown,time,keycode]=PsychHID('KbCheck',display.forpnum);
        end

    else
        [keyIsDown,time,keycode]=PsychHID('KbCheck',display.keyboarddevnum);
    end
end

