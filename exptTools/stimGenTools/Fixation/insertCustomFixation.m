function img = insertCustomFixation(display,img,fixParams)% % AUTHOR:  Wandell% DATE:    04.16.98% PURPOSE:% % if isempty(fixParams.colors(1))  lo = display.reservedColor(findName(display.reservedColor,'black')).fbVal;else  lo = fixParams.colors(1);endif isempty(fixParams.colors(2))  hi = display.reservedColor(findName(display.reservedColor,'white')).fbVal;else  hi = fixParams.colors(2);enddummy = zeros(size(img(:,:,1) ));fixImage = fixParams.image;if size(fixImage) ~= size(dummy)  error('insertCustomFixation: fixation image and stimulus image size mis-match');endidLO = find(fixImage == -1);imgLO = ones(size(idLO))*lo;idHI = find(fixImage == -2);imgHI = ones(size(idHI))*hi;numImages = size(img,3);fprintf('Copying fixation to %.0f images\n',numImages);for ii=1:numImages  tmp = img(:,:,ii);   tmp(idLO) = imgLO; tmp(idHI) = imgHI;  img(:,:,ii) = tmp;end% checkStimulusImage(img(:,:,1),stimulus.cmap(:,:,1),1,1);return;