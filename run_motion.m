%run_motion
%
%A 'main' function for running all the different options of the motion_th
%experiment.

%Get rid of previous variables, figures:
clear all; close all;

%##########################################################################
% This needs to be set only once for each display, so I put it here
% This is equivalent to the variable 'scanner' in getScannerDisplay and
% determines from which directory under Displays the displayParams will be
% read:

choose_display = 1;

%##########################################################################

%Generic stuff:

%Add all the local utilities to the path:
addpath(genpath(pwd))


%Set Psychtoolbox preferences:
AssertOpenGL;
Priority(9);
Screen('Preference','VisualDebugLevel',0);
Screen('Preference','SkipSyncTests',1);


%Experiment specific stuff:

%Get the subject ID:
subjectID= inputdlg('What is the subject ID?');
ID=subjectID{1};

%Set the mode of this run, with a GUI:
mode = questdlg('Choose program mode', 'Mode', 'Teach', 'Test', 'Train', 'Teach');

%Depending on the mode, call different programs:
switch mode

    case 'Teach'
        params = motion_th_params_teach(ID);
        params.scanner = choose_display;
        motion_th_teach
    case 'Test'

        location_str = questdlg('Which location to test?','location',...
            '1','2','1');

        if location_str == '1'
            location = 1;
        else
            location = 2;
        end

        params = motion_th_params_test(location,ID);
        params.scanner = choose_display;
        motion_th_test

    case 'Train'

        location_str = questdlg('Which location to train?','location',...
            '1','2','1');

        if location_str == '1'
            location = 1;
        else
            location = 2;
        end

        d(1).dir = '45';
        d(2).dir = '135';
        d(3).dir = '225';
        d(4).dir = '315';

        which = listdlg('PromptString','Choose direction to train:',...
            'SelectionMode','single',...
            'ListString',{d.dir});

        switch d(which).dir
            case '45'
                direction = 45;
            case '135'
                direction = 135;
            case '225'
                direction = 225;
            case '315'
                direction = 315;
        end

        params = motion_th_params_train(location,direction,ID);
        params.scanner = choose_display;
        motion_th_test
end

%Screen('Resolution', display.screenNumber,display.oldResolution.width,display.oldResolution.height,display.oldResolution.hz);
