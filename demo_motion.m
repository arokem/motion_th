%demo_motion
%
%A 'demo' function for demonstrating the motion_th paradigm

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

%Set the subject ID, just in case the demo does run all the way
subjectID='demo';

t_location = 1;
u_location = 2;
t_direction = 45;
u_direction = mod(t_direction+180,360);

direction = [t_direction u_direction t_direction u_direction];
location = [t_location t_location t_location t_location];

params = motion_th_params_test(location,direction,ID);
params.scanner = choose_display;
motion_th_test

