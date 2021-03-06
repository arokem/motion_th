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

choose_display = 2;

%##########################################################################

%Generic stuff:

%Add all the local utilities to the path:
addpath(genpath(pwd),'-begin')


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
        location_str = questdlg('Which location is the trained location?','location',...
            '1','2','1');

        if location_str == '1'
            t_location = 1;
            u_location = 2;
        else
            t_location = 2;
            u_location = 1;
        end

        d(1).dir = '45';
        d(2).dir = '135';
        d(3).dir = '225';
        d(4).dir = '315';

        which = listdlg('PromptString','Which direction is the trained direction?',...
            'SelectionMode','single',...
            'ListString',{d.dir});

        switch d(which).dir
            case '45'
                t_direction = 45;
            case '135'
                t_direction = 135;
            case '225'
                t_direction = 225;
            case '315'
                t_direction = 315;
        end
        u_direction = mod(t_direction+180,360);

        counter_balance_string = questdlg('Which counter-balance group is this subject','counterbalance','1','2','1');

        if counter_balance_string == '1'
            direction = [t_direction u_direction t_direction u_direction];
            location = [t_location t_location t_location t_location];
        else
            direction = [u_direction t_direction u_direction t_direction];
            location = [t_location t_location t_location t_location];
        end


        params = motion_th_params_test(location,direction,ID);
        params.scanner = choose_display;
        motion_th_test

    case 'Train'

        location_str = questdlg('Which location to train?','location',...
            '1','2','1');

        if location_str == '1'
            location = 1*ones(1,4);
        else
            location = 2*ones(1,4);
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
                direction = 45*ones(1,4);
            case '135'
                direction = 135*ones(1,4);
            case '225'
                direction = 225*ones(1,4);
            case '315'
                direction = 315*ones(1,4);
        end

        params = motion_th_params_train(location,direction,ID);
        params.scanner = choose_display;
        motion_th_test
end

%Screen('Resolution', display.screenNumber,display.oldResolution.width,display.oldResolution.height,display.oldResolution.hz);
