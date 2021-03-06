%function correct=judgeResponse(afc_real,keyHit,afc_press)
%
%judges whether a keypress response is the right keypress in a 2AFC trial
%and outupts 1 if correct, 0 otherwise. If no key was pressed output is NaN
%
%<afc_real> 1 if the correct answer is afc_press(1); anything else
%otherwise. 
%
%<keyHit> a char with the keypress value
%
%<afc_press> a char array with 2 values. One for each possibility of
%afc_real. afc_press(1) is correct if ac_real==1, otherwise correct=0
%
%EXAMPLE:
%correct = judgeResponse (1,'1',['1' '2']);%correct=1
%correct = judgeResponse (1,'2',['1' '2']); %correct=0
%correct = judgeResponse (1,'',['1' '2']); %correct=-1
%
%11/22/2006 ASR wrote it



function correct=judgeResponse(afc_real,keyHit,afc_press)

if strcmp(keyHit,afc_press(1)) == 1
    if afc_real
        correct = 1;
    else
        correct = 0;
    end

elseif strcmp(keyHit,afc_press(2)) == 1
    if afc_real
        correct = 0;
    else
        correct = 1;
    end

else
    correct= NaN;
end
