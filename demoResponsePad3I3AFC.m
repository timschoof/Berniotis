[Wave2Play,SampFreq]=audioread('GapInSecondPlace-400-500-ms.wav');

OneSoundDuration=400;
ISI=500;
CorrectAnswer=2;
trial=1;
FacePixDir='Bears';
%% read in all the necessary faces for feedback
FacesDir = fullfile('Faces',FacePixDir,'');
SmileyFace = imread(fullfile(FacesDir,'smile24.bmp'),'bmp');
WinkingFace = imread(fullfile(FacesDir,'wink24.bmp'),'bmp');
FrownyFace = imread(fullfile(FacesDir,'frown24.bmp'),'bmp');
%ClosedFace = imread(fullfile(FacesDir,'closed24.bmp'),'bmp');
%OpenFace = imread(fullfile(FacesDir,'open24.bmp'),'bmp');
%BlankFace = imread(fullfile(FacesDir,'blank24.bmp'),'bmp');
CorrectImage=SmileyFace;
IncorrectImage=FrownyFace;

trial=0;
responseGUI = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial);
pause(0.5);
playEm = audioplayer(Wave2Play,SampFreq);
play(playEm);
IntervalIndicators(responseGUI, OneSoundDuration,ISI)

trial=1;
response = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial);
pause(0.5)

trial=2;
playEm = audioplayer(Wave2Play,SampFreq);
play(playEm);
IntervalIndicators(responseGUI, OneSoundDuration,ISI)
response = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial)


return

% varargins
% 
% 1 Wave2Play
% 2 SampFreq
% 3 OneSoundDuration (ms)
% 4 ISI (ms)
% 5 CorrectAnswer
% 6 CorrectImage
% 7 IncorrectImage