%doScan_motion_th.m
%Uses new version of move_dots_new.m in order to display block-design
%motion stimuli for oblique effect experiments.
%Directions presented ARE the major directions - so either
%[dir/dir] or [dir+diff/dir or dir-diff/dir or dir/dir+diff or
%dir/dir-diff], in equal probabilties (same or different in eq. prob.), where the number of different
%angle trials and same angle trials is set to be the same.
%Difference for each trial is calculated using Pelli's Quest algorithm

function scanHistory = doScan_motion_th6(display, image_sta_xy, a, b, params, session,q);


%Make the whiteindex for the visual feedback
white = WhiteIndex(display.windowPtr);

% Make auditory feedback sounds:
soundFeedback=makeSoundFeedback_G4;
play(soundFeedback.noSound);
play(soundFeedback.noSound);

putMessage(display.windowPtr,'Press any key to start',display.reservedColor,'white', display.flip);
getAnyKey(display);

%%Screen flips again to indicate that the subject has pressed the key
Screen('Flip',display.windowPtr);


timeToEndTrial = 0;	% Total time from beginning of scan at which the current trial must end
time=getStartScan(params.scanner);

coh=params.dotCoherenceDiscrimination;

locat = params.locat(session);

dir=params.dotDirections(session);

non_zero_angles=params.diff(find(params.diff~=0));

for trialCounter = 1:params.numOfTrials

    this_trial_diff=round(rand);
    is_clockwise=sign(randn);


    trialTheta=QuestQuantile(q);
    theta=params.maxTheta*10^trialTheta;
    tTest=min(theta,params.maxTheta);

    if this_trial_diff
        if rand>0.5
            dir1=dir;
            dir2=dir+tTest*is_clockwise;
        else
            dir1=dir+tTest*is_clockwise;
            dir2=dir;
        end
    else
        dir1=dir;
        dir2=dir;
    end

    %move_dots(window, fram, a, b, dens, vel, coh, siz, dir, how_many_frames, display, params, image_sta)
    move_dots_new(display.windowPtr, floor(display.frameRate * params.stimulusDuration)-7, a{locat} , b{locat} , angle2pix(display,params.dotDensity), ...
        angle2pix(display,params.dotVelocity), coh, angle2pix(display,params.dotSize), dir1, params.dotLifeTime, display, params, image_sta_xy);

    WaitSecs(params.interStimulusDuration);
    
    % ################# 
    % For making movies:
    % screen_grab(display.windowPtr)
    % ################# 

    move_dots_new(display.windowPtr, floor(display.frameRate * params.stimulusDuration)-7, a{locat} , b{locat} , angle2pix(display,params.dotDensity), ...
        angle2pix(display,params.dotVelocity), coh, angle2pix(display,params.dotSize), dir2, params.dotLifeTime, display, params, image_sta_xy);

    timeToEndTrial = timeToEndTrial+2*params.stimulusDuration+params.interStimulusDuration;
    %waitTill_OSX(timeToEndTrial,display,time);

    scanHistory.dir1(trialCounter)=dir1;
    scanHistory.dir2(trialCounter)=dir2;
    %              Snd('Play',soundFeedback.startStimulusSound,8000);
    play(soundFeedback.startStimulusSound);
    [keyHit RT]=getResponse(display, params.responseDuration);

    if isfield(display,'forpnum')
        key_diff=['r' 'y'];
    else
        key_diff=['1' '2'] ;
    end

    correct = judgeResponse (this_trial_diff,keyHit,key_diff);
    if correct == 0 %wrong answer

        Screen('DrawDots', display.windowPtr, image_sta_xy, angle2pix(display,params.dotSize),white*[1 0 0],[],1) %Red for incorrect
        Screen('Flip', display.windowPtr);

        scanHistory.response(trialCounter)=str2num(keyHit);
        scanHistory.RT(trialCounter)=RT;
        scanHistory.correct(trialCounter)=correct;

        if params.feedback == 1
            %  Snd('Play',soundFeedback.incorrectResponseSound,8000);
            play(soundFeedback.incorrectResponseSound);
        end

        q=QuestUpdate(q,log10(tTest/params.maxTheta),correct);
        scanHistory.q=q;


    elseif correct == 1 %right answer

        Screen('DrawDots', display.windowPtr, image_sta_xy, angle2pix(display,params.dotSize),white*[0 1 0],[],1) %Red for incorrect
        Screen('Flip', display.windowPtr);
        
        scanHistory.response(trialCounter)=str2num(keyHit);
        scanHistory.RT(trialCounter)=RT;
        scanHistory.correct(trialCounter)=correct;

        if params.feedback == 1
            %Snd('Play',soundFeedback.correctResponseSound,8000);
            play(soundFeedback.correctResponseSound);
        end

        q=QuestUpdate(q,log10(tTest/params.maxTheta),correct);
        scanHistory.q=q;

    else

        scanHistory.response(trialCounter)=-1;
        scanHistory.RT(trialCounter)=NaN;
        scanHistory.correct(trialCounter)=correct;
        if params.feedback == 1
            %         Snd('Play',soundFeedback.noResponseSound,8000);
            play(soundFeedback.noResponseSound);
        end

    end


    if correct==1
        response=1;
    else
        response=0;
    end


    timeToEndTrial = timeToEndTrial + params.feedbackDuration+params.responseDuration;
    waitTill_OSX(timeToEndTrial,display,time);

    Screen('DrawDots', display.windowPtr, image_sta_xy, angle2pix(display,params.dotSize),white*[1 1 1],[],1) %Red for incorrect
    Screen('Flip', display.windowPtr);

end %trialcounter

scanHistory.t=QuestMean(q);
scanHistory.sd=QuestSd(q);

trialDur=2*params.stimulusDuration+params.interStimulusDuration+params.responseDuration+params.feedbackDuration;
numOfTrials=params.numOfTrials;

postSessOps(params.scanner,display,numOfTrials,trialDur,time)


