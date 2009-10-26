function [answer,trialHistory] = doTrial(display,trial,runPriority, showTimingFlag,returnHistory)%[response,trialHistory] = doTrial(display,trial [,runPriority,showTimingFlag,returnHistory])%%	This still needs alot more commenting, but I will tell you this: if you want%	to return keyHit, things around here have changed a bit.  You set returnHistory%	to one to return trialHistory.  keyHit will now be a field of said struct.%%   98.12.15 RFD: added material.sampRate option for soundEvent%% NEEDS MORE COMMENTING HEREanswer = NaN;trialHistory.keyHit = [];if ~exist('runPriority', 'var')	runPriority = 0;  					%use the nicest priority by defaultendif ~exist('showTimingFlag', 'var')	showTimingFlag = 0;endif ~exist('returnHistory', 'var')	returnHistory = 0;endbackgroundColor = findName(display.reservedColor,'background');for eventNum = 1:size(trial,1)		material = trial{eventNum,2};		% The stuff to act upon for any given event		switch trial{eventNum,1}			case 'stimulusEvent',			showStimulus(display,material.stimulus,runPriority);					case 'randomizeStimulusEvent',	% An example randomizeFunction: randomizePeriodicStimulus				if ~isfield(material,'stimulus') | ~isfield(material,'params') | ~isfield(material,'randomizeTable') | ~isfield(material,'randomizeFunction')				disp('randomizeStimulusEvent needs four fields:');				error('stimulus, params, randomizeTable, and randomizeFunction.');			end						functionCall = ['[newStimulus,valuesUsed] = ' material.randomizeFunction '(display, material.stimulus, material.params, material.randomizeTable);'];			eval(functionCall);			showStimulus(display,newStimulus,runPriority);						if returnHistory				for ii = 1:size(material.randomizeTable,1)					disp('Setting a field.');					trialHistory = setfield(trialHistory,material.randomizeTable{ii,1},valuesUsed{ii});				end			end			disp('Here it comes...');			trialHistory						case 'ISIEvent'						if isfield(material,'stimulus')				showStimulus(display,material.stimulus,runPriority);				if isfield(material,'duration')					waitTill(material.duration);				end			elseif isfield(material,'duration')				SCREEN(display.windowPtr,'SetClut',greyCmap(display));				waitTill(material.duration);			else				error('ISI has to have at least a duration or stimulus field!');			end						case 'soundEvent',    			if isfield(material, 'sampRate')				sound(material.sound, material.sampRate);            else				sound(material.sound);            end		case 'responseEvent',				if isfield(material,'stimulus')  % There's a stimulus to show during the response period				showStimulus(display,material.stimulus,runPriority);			end						trialHistory.keyHit = waitTill(material.duration);			if isempty(trialHistory.keyHit)  % No key was hit during response interval								responseIndex = NaN;							else  				% A key was hit								responseIndex = findstr(material.responseSet, trialHistory.keyHit);   % Find which response was made				if isempty(responseIndex)	% Invalid response (was not in responseSet)					answer = NaN;				elseif isfield(material,'answerType')   % answerType was specified								switch material.answerType						case 'binary',							answer = (responseIndex==1);						case '1toN',							answer = responseIndex;						case 'none',							answer = [];						otherwise,							error('Not a valid answerType (just leave it out for binary).');					end								else			% assume answerType is the default (i.e., binary)										answer = (responseIndex==1); % Default answerType is binary				end			end					case 'feedbackEvent',	% Remember to check whether various feedback strings even exist				if ~exist('responseIndex','var')				feedbackText = material.noResponseText;				feedbackColor = material.noResponseColor;			elseif isnan(responseIndex)				feedbackText = material.noResponseText;				feedbackColor = material.noResponseColor;			elseif isempty(responseIndex)				feedbackText = material.invalidResponseText;				feedbackColor = material.invalidResponseColor;			else				feedbackText = material.validResponsesText{responseIndex};				feedbackColor = material.validResponsesColor{responseIndex};			end			vLoc=material.feedbackVerticalLocation;			timeRightNow = getSecs;			dispStringInCenterFast(display,feedbackText,vLoc,display.reservedColor(feedbackColor).fbVal,32);			waitTill(material.duration, timeRightNow);			dispStringInCenterFast(display,feedbackText,vLoc,display.reservedColor(backgroundColor).fbVal,32);					case 'soundFeedbackEvent',	% Remember to check whether various feedback strings even exist				if ~exist('responseIndex','var')				feedbackSound = material.noResponseSound;			elseif isnan(responseIndex)				feedbackSound = material.noResponseSound;			elseif isempty(responseIndex)				feedbackSound = material.invalidResponseSound;			else				feedbackSound = material.validResponseSound{responseIndex};			end			sound(feedbackSound);					otherwise,			error([trial{eventNum,1} ' is not a valid event type.']);	endend