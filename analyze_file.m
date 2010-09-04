%function out = analyze_file
%
%Analyze the results of the run_motion program. This program is very
%similar to analyze_run, except it allows you to choose a file to analyze
%via a GUI
%
%
%   
%The result ("out") contains: 
%
%   out.loc = the location in this run (1 or 2)
%   out.dir = the direction in this tun
%   out.th = the estimate of the threshold
%   out.lb = lower bound on the 95% CI of the threshold
%   out.lub = upper bound on the 95% CI of the threshold
%   out.error = the size of the CI of the threshold



function out = analyze_run(filename)

if nargin<1
[filename,pathname] = uigetfile('load', 'choose a file to analyze');
filename = [pathname,filename];
end
load(filename)

filename

out.loc = results(1).stimParams.locat;
out.dir = results(1).stimParams.dotDirections;


out.th = [];
out.ub = [];
out.lb = [];
out.error = []; 

for i=1:length(out.dir)
    out.th = [out.th results(1).stimParams.maxTheta*(10^QuestQuantile(results(i).scanHistory.q,0.5))];
    out.ub = [out.ub results(1).stimParams.maxTheta*(10^QuestQuantile(results(i).scanHistory.q,0.95))];
    out.lb = [out.lb results(1).stimParams.maxTheta*(10^QuestQuantile(results(i).scanHistory.q,0.05))];
    
end

out.error = out.ub-out.lb;
