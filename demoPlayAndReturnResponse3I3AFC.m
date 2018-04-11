% function PlayAndReturnResponse3I3AFC(Wave2Play,trial,p)
clear
InterauralTonePhase=0;
ToneFreq=500;
TranspositionFreq = 000;

NumSignalPulses= 3;
ToneDuration=200;
WithinPulseISI=30;
ISI=300;
signalInterval = NumSignalPulses*ToneDuration + (NumSignalPulses-1) * WithinPulseISI;
NoiseDuration=signalInterval;
LongMaskerNoise= 600 + 3 * NoiseDuration + 2 * ISI;
p=BerniotisParseArgs('SR','fixed','noise','rms2use', 0.07,'NoiseBandWidth',100,...
    'InterauralTonePhase', InterauralTonePhase, 'TranspositionFreq', TranspositionFreq,'ToneFreq', ToneFreq, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'NumSignalPulses', NumSignalPulses,'ToneDuration', ToneDuration, 'WithinPulseISI', WithinPulseISI,...
    'NoiseDuration', NoiseDuration,'ISI', ISI, ...
    'starting_SNR',10,...
    'BackNzPulsed', 0, 'BackNzLoPass', 1300, 'BackNzHiPass', 50, 'BackNzLevel', .01, ...
    'LongMaskerNoise', LongMaskerNoise, ...
    'outputAllWavs', 0, 'DEBUG',0);

% p=BerniotisParseArgs('L01');
FacesDir = fullfile('Faces',p.FacePixDir,'');
SmileyFace = imread(fullfile(FacesDir,'smile24.bmp'),'bmp');
WinkingFace = imread(fullfile(FacesDir,'wink24.bmp'),'bmp');
FrownyFace = imread(fullfile(FacesDir,'frown24.bmp'),'bmp');
%ClosedFace = imread(fullfile(FacesDir,'closed24.bmp'),'bmp');
%OpenFace = imread(fullfile(FacesDir,'open24.bmp'),'bmp');
%BlankFace = imread(fullfile(FacesDir,'blank24.bmp'),'bmp');
p.CorrectImage=SmileyFace;
p.IncorrectImage=FrownyFace;
p.Order=1;
% generate the appropriate sounds
w=GenerateSxNxTonalTriple(p);
%% ensure no overload
% function [OutWave, flag] = NoClipStereo(InWave,message)
[w, flag] = NoClipStereo(w);
audiowrite('demoPRR3I.wav',w,p.SampFreq);

trial=1;
[response1,p] = PlayAndReturnResponse3I3AFC(w,trial,p);

pause(1)

trial=2;
[response2,p]  = PlayAndReturnResponse3I3AFC(w,trial,p);

pause(1)
set(0,'ShowHiddenHandles','on');
delete(findobj('Type','figure'));

return


PlayAndReturnResponse3I3AFC(Wave2Play,trial,p)

