%function out = analyze_run(subject, date, session)
%
%Analyze the results of the run_motion program
%
%Example: 
%
%   analyze_run('ASR','102809',1)
%
%   Where 'ASR' is the subject ID, '102809' is the date in which this was
%   run, and '1' is the serial number of this run on that day.
%
%The result ("out") contains: 
%
%   out.loc = the location in this run (1 or 2)
%   out.dir = the direction in this tun
%   out.th = the estimate of the threshold
%   out.lb = lower bound on the 95% CI of the threshold
%   out.lub = upper bound on the 95% CI of the threshold
%   out.error = the size of the CI of the threshold



function out = analyze_run(subject, date, session)

load (['Results/motion_th' subject date '_' num2str(session) '.mat'])

out.loc = results(1).stimParams.locat;
out.dir = results(1).stimParams.dotDirections;


out.th = [];
out.ub = [];
out.lb = [];
out.error = []; 

for i=1:length(out.dir)
    out.th = [out.th results(1).stimParams.QuestTGuess*10^QuestQuantile(results(i).scanHistory.q)];
    out.ub = [out.ub results(1).stimParams.QuestTGuess*10^QuestQuantile(results(i).scanHistory.q,0.95)];
    out.lb = [out.lb results(1).stimParams.QuestTGuess*10^QuestQuantile(results(i).scanHistory.q,0.05)];
    
end

out.error = out.ub-out.lb;
