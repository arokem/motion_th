%function soundFeedback=makeSoundFeedback
%
%Makes a struct with standard sound feedback:  
%soundFeedback.{noResponseSound,correctResponseSound,incorrectResponseSound
%,startStimulusSound}
%
%1/18/07 ASR wrote it

function soundFeedback=makeSoundFeedback

soundFeedback.noResponseSound = soundFreqSweep(200, 300, .1) * 3;
soundFeedback.correctResponseSound = soundFreqSweep(300, 800, .1);
soundFeedback.incorrectResponseSound = soundFreqSweep(8000, 200, .1);
soundFeedback.startStimulusSound = soundFreqSweep(1, 10000, 200, .1);
