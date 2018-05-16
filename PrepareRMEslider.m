function PrepareRMEslider(RMEsettingsFile,dBSPL)
%% Set RME Slider if necessary
% read in RME settings file
RMEsetting=robustcsvread(RMEsettingsFile);
% select columns with relevant info
LevelCol=strmatch('dBSPL',strvcat(RMEsetting{1,:}));
SliderCol=strmatch('slider',strvcat(RMEsetting{1,:}));
% find index of dBSPL level
index = find(strcmp({RMEsetting{:,LevelCol}}, num2str(dBSPL)));
% find the corresponding RME slider setting
RMEattn = RMEsetting{index,SliderCol};
% set RME slider
SetRMESlider(str2double(RMEattn))
