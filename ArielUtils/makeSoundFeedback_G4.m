%function soundFeedback=makeSoundFeedback_G4
%
%Makes a struct with standard sound feedback:  
%soundFeedback.{noResponseSound,correctResponseSound,incorrectResponseSound
%,startStimulusSound}
%
%1/18/07 ASR wrote it
%1/18/07 New version for the G4 using soundplayer instead of Snd

function soundFeedback=makeSoundFeedback_G4

soundFeedback.noResponseSound = audioplayer(soundFreqSweep(200, 300, .1) * 3,8000);
soundFeedback.correctResponseSound = audioplayer(soundFreqSweep(300, 800, .1),8000);
soundFeedback.incorrectResponseSound = audioplayer(soundFreqSweep(8000, 200, .1),8000);
soundFeedback.startStimulusSound = audioplayer(soundFreqSweep(1, 10000, 200, .1),8000);

soundFeedback.noSound = audioplayer(soundFreqSweep(200, 300, 0) * 3,8000);

