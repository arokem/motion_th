%function postSessOps(scanner,display,numOfTrials,trialDur,time)
%
%After each session the following operations are executed: the time it
%took to run the session is compared to the time it actually took. 
%If the run is occuring in the scanner, two post-session ttl pulses are
%collected and their times are note (in order to make sure that the
%run-time for the scan was as long as the run-time for the behavioral
%code). 
%
%<scanner> is a double, where:
% 1 is Minor Hall Room 582D (the LCD)
% 2 is the Varian Scanner LCD display
% 3 is Minor Hall Room 582J (the CRT)
%
%<display> is a struct that contains a field "keyboarddevnum" and may 
%contain a field "forpnum" (if in the varian scanner)  
%
%<numOfTrials> number of trials in the session
%
%<trialDur> The duration of all the operations in a trial
%
%<time> the time when the session began



function postSessOps(scanner,display,numOfTrials,trialDur,time)

theoreticalruntime=numOfTrials*trialDur; 

disp(['Final run time: ',num2str(round((GetSecs-time)*100)/100)]);
disp(['Should be: ', num2str(theoreticalruntime)]);
