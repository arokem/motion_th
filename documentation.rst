===========================
 Motion Threshold Learning
===========================

:author:`Ariel Rokem`

Dependencies
============

The program runs on MatlabR2007b, with Psychtoolbox 3.0.8 (beta) installed, on
Mac OS 10.5. It should run on OS 10.4 as well and with other versions of Matlab
and Psychtoolbox.

Operation
=========

In order to run the program, type::

   motion_th

At the matlab prompt. You will be then prompted to enter the subject ID. After
a couple of moments (during which the stimuli are produced), a text should
appear in the center of the screen, prompting the subject to press a button to
proceed. Once a button is pressed, 50 trials should start. Each trial requires
a speeded response. The subjects are asked to press the '1' button for trials
in which the two motions were in different directions and to press the '2'
button, when the motions were in the same direction. If they do not respond
within the alloted response period, they receive an auditory 'no press'
feedback and the next trial is presented. If they respond, they receive an
auditory 'correct'/'incorrect' feedback. At the end of each block of 50 trials,
a text appears prompting subjects to continue to the next block. When 4 blocks
are over, the desktop will reappear on the screen on which the stimulus was
displayed.

Parameters
==========

The parameters of the experiment are set in the file 'motion_th_params.m'. The
first few lines of this file contain the parameters which most often are
changed. The stimParams.locat can be set to '1', or to '2', which will
determine which in which of two possible locations (upper left and bottom
right, OR upper right and bottom left) the coherent dot motion, on which the
subjects perform a judgment, is presented. The stimParams.dotDirections can be
set to linspace(45,315,4), which will then contain all 4 oblique
directions. Alternatively, it can be set to linspace (some_direction,
some_direction, 4), which will repeat the same direction four times in the four
blocks of the experiment. In the pre- and post-testing, use both locations and
the four oblique directions. During training, comment this line and uncomment
the line in which the directions are set to just one direction. Also - in
training, use only one of the two locations.


Data
====
In each block of 50 trials, the difference between the two motions is set
according to a QUEST staircase. The parameters determining the setting of this
staircase (initial guess, initial uncertainty and maximal allowed offset) are
set at the bottom of the parameters file. The data will be saved under the
'Results' directory, as '.mat' files, which contain the events of each of the
trials and a q struct, which records the progress of the staircase algorithm.    

