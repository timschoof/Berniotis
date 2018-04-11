function IntervalIndicators(responseGUI, OneSoundDuration, ISI, initialDelay)

OnColour='red';
pause(initialDelay/1000);
originalColour = get(responseGUI.Children(1),'BackgroundColor');
set(responseGUI.Children(3),'BackgroundColor',OnColour)
pause(OneSoundDuration/1000);
set(responseGUI.Children(3),'BackgroundColor',originalColour)
pause(ISI/1000);
set(responseGUI.Children(2),'BackgroundColor',OnColour)
pause(OneSoundDuration/1000);
set(responseGUI.Children(2),'BackgroundColor',originalColour)
pause(ISI/1000);
set(responseGUI.Children(1),'BackgroundColor',OnColour)
pause(OneSoundDuration/1000);
set(responseGUI.Children(1),'BackgroundColor',originalColour)
