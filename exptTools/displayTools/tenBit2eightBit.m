function [eightbitCmap, gamma] = tenBit2eightBit(display, tenbitCmap)% function [eightbitCmap, gamma] = tenBit2eightBit(display, tenbitCmap)%%	Given a 10-bit, 256-entry cmap, this routine creates an 8-bit colormap%	and the associated 10-bit, 256-entry gamma table (properly calibrated, %   as specified in display.gammaTable).%%% 10/23/98: written by RFD and WAPnumCmaps = size(tenbitCmap,3);gamma = zeros(256, 3, numCmaps);for i=1:numCmaps	gamma(:,1,i) = display.gammaTable(tenbitCmap(:,1,i)+1, 1);	gamma(:,2,i) = display.gammaTable(tenbitCmap(:,2,i)+1, 2);	gamma(:,3,i) = display.gammaTable(tenbitCmap(:,3,i)+1, 3);end% the second argument returned by sort is the index (rank-ordered values)%[gamma,sortIndex] = sort(gamma);eightbitCmap = repmat([0:255]',[1 3 numCmaps]);