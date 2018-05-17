function Berniotis(varargin)
% Run an experiment

% Version 1.0 -- March 2018
% Version 1.5 
%   add fixed background noise
% Version 2.0 
%   allow masker to be continuous throughout the triple observation intervals

%% initialisation and fixed parameter values
VERSION=2.0;
rng('shuffle')
levitts_index = 1;
'isrme';

%% get control parameters by picking up defaults and specified values from args
if ~rem(nargin,2)
    error('You should not have an even number of input arguments');
end
p=BerniotisParseArgs(varargin{1},varargin{2:end});

%% Settings for level
if ispc && p.usePlayrec == 0
    [~, OutRMS]=SetLevels(p.VolumeSettingsFile);
elseif ismac
    !osascript set_volume_applescript.scpt
    % VolumeSettingsFile='VolumeSettingsMac.txt';
end

%% Set RME Slider if necessary
if strcmp(p.RMEslider,'TRUE')
    PrepareRMEslider('RMEsettings.csv', p.dBSPL);
end

%% further initialisations
LEVITTS_CONSTANT = [1 p.LevittsK];

% for fixed level testing
if p.START_change_dB==0 || p.MIN_change_dB == 0
    p.MIN_change_dB = 0;
    p.START_change_dB=0;
    p.INITIAL_TURNS = 99;
    p.FINAL_TURNS = 99;
    LEVITTS_CONSTANT = [1 1];
    MaxBumps=99;
end

%%	setup a few starting values for adaptive track
% the original code was in a situation where SNR was specified in CCRM
previous_change = -1; % assume track is initially moving from easy to hard
num_turns = 0;
num_final_trials = 0;
change = p.START_change_dB;
inc = (p.START_change_dB-p.MIN_change_dB)/p.INITIAL_TURNS;
limit = 0;
% response_count = 0;
trial = 0;

if ~exist(p.OutputDir, 'dir')
    status = mkdir(p.OutputDir);
    if status==0
        error('Cannot create new output directory for results: %s.\n', p.OutputDir);
    end
end

%% determine a code for the feedback type to put in the file name
if strcmp(p.FeedBack,'None')
    FeedBackCode = '0';
elseif strcmp(p.FeedBack,'Neutral')
    FeedBackCode = 'N';
elseif strcmp(p.FeedBack,'Corrective')
    FeedBackCode = 'C';
elseif strcmp(p.FeedBack,'AlwaysGood')
    FeedBackCode = 'G';
else
    error('Illegal type of Feedback specified');
end

%% get start time and date
StartTime=fix(clock);
StartTimeString=sprintf('%02d:%02d:%02d',...
    StartTime(4),StartTime(5),StartTime(6));
StartDate=date;

%% construct the output data file name
% get the root name of the target and noise files
% put masker, date and time on filenames so as to ensure a single file per test
FileNamingStartTime = sprintf('%02d-%02d-%02d',StartTime(4),StartTime(5),StartTime(6));
if p.outputAllWavs % make a directory for all the output waves
    % p.wavOutputDir=['wavsOut-' FileNamingStartTime];
    p.wavOutputDir=['0-wavsOut'];
    ClearAndMakeDir(p.wavOutputDir)
end

% Construct a condition code
if p.InterauralTonePhase==0
    phz='00';
else
    phz='pi';
end
if strcmp(p.fixed,'signal')
    fx='Sig';
else
    fx='Nz';
end

CondCode=sprintf('%dHzS-S%s-%03drms-Fix%s-%dP',p.ToneFreq,phz,round(p.rms2use*1000),fx,p.NumSignalPulses);
FileListenerName=[p.ListenerName '_' CondCode '_' StartDate '_' FileNamingStartTime];
OutFile = fullfile(p.OutputDir, [FileListenerName '.csv']);
SummaryOutFile = fullfile(p.OutputDir, [FileListenerName '_sum.csv']);


%% write some headings and preliminary information to the output file
fout = fopen(OutFile, 'at');
fprintf(fout, 'listener,CondCode,date,time,trial,SNR,correct,order,response,step,rTime,rev');
fclose(fout);

%% wait to start
if ~p.DEBUG
    GoOrMessageButton('String', p.StartMessage)
end

%%	do adaptive tracking until stop criterion */
while (num_turns<p.FINAL_TURNS  && limit<=p.MaxBumps && trial<(p.MAX_TRIALS-1))
    num_correct = 0; num_wrong = 0;
    % present same level until change criterion reached */
    while ((num_correct < LEVITTS_CONSTANT(levitts_index)) && (num_wrong==0))
        trial=trial+1;
        % choose a random interval of 3
        p.Order=randi(3);
        
        % generate the appropriate sounds
        [w, Nz, Tn]=GenerateSxNxTonalTriple(p);
        %% ensure no overload
        % function [OutWave, flag] = NoClipStereo(InWave,message)
        [w, flag] = NoClipStereo(w, sprintf('Trial %d',trial));
        if p.outputAllWavs
            audiowrite(fullfile(p.wavOutputDir,sprintf('T%02d%+02d-o%d.wav',trial,round(p.SNR_dB),p.Order)),w,p.SampFreq);
            [Nz, flag] = NoClipStereo(Nz, 'noise file');
            [Tn, flag] = NoClipStereo(Tn, 'target file');
            audiowrite(fullfile(p.wavOutputDir,sprintf('T%02d%+02dTn.wav',trial,round(p.SNR_dB))),Tn,p.SampFreq);
            audiowrite(fullfile(p.wavOutputDir,sprintf('T%02d%+02dNz.wav',trial,round(p.SNR_dB))),Nz,p.SampFreq);           
        end
        %% play it out and score it.
        if ~p.DEBUG
            [response,p] = PlayAndReturnResponse3I3AFC(w,trial,p);
        %% stat rat section for output format, etc.
        else 
            % get 2 right at the start of session, and then make
            % performance depend upon the SNR in a reasonable way
            % The two incorrect responses are chosen randomly
            if trial<=2 || (rand(1)<MyLogistic(p.SNR_dB,10,1))
                response=p.Order;
            else
                xx=(1:3);
                xx(p.Order)=[];
                response=xx(randi(2));
            end
        end
        correct = p.Order==response;
        TimeOfResponse = clock;
        
        % test for quitting
        if strcmp(response,'quit')
            break
        end
                
        fout = fopen(OutFile, 'at');
        % print out relevant information
        % 'listener,CondCode,date,time,trial,SNR,correct,order,response,steprTime,rev');
        
        fprintf(fout, '\n%s,%s,%s,%s,%3d,%+5.1f,%d,%d,%d,%g,', ...
            p.ListenerName,CondCode,StartDate,StartTimeString,trial,...
            p.SNR_dB,correct,p.Order,response,change);
        fprintf(fout, '%02d:%02d:%05.2f',...
            TimeOfResponse(4),TimeOfResponse(5),TimeOfResponse(6));
        % close file for safety
        fclose(fout);
        
        % ignore initial errors
        if ((trial>p.IgnoreTrials) || correct) % do the normal thing
            % score the response as correct or wrong */
            if correct
                num_correct=num_correct+1;
            else
                num_wrong=num_wrong+1;
            end
            
            % also keep track of levels visited: perhaps better
            if ((change-0.001) <= p.MIN_change_dB) % allow for rounding error
                % we're in the final stretch
                num_final_trials = num_final_trials + 1;
                final_trials(num_final_trials) = p.SNR_dB;
            end
        end
        
    end % end of Levitt 'while' loop
    
    % test for quitting
    if strcmp(response,'quit')
        break
    end
    
    % decide in which direction to change levels
    if (num_correct == LEVITTS_CONSTANT(levitts_index))
        current_change = -1;
    else
        current_change = 1;
    end
    
    % are we at a turnaround? (defined here as any change in direction) If so, do a few things
    if (previous_change ~= current_change)
        % move to next value of Levitt's constant if not already done
        if (levitts_index==1)
            levitts_index=2;
        end
        % reduce step proportion if not minimum */
        if ((change-0.001) > p.MIN_change_dB) % allow for rounding error
            change = change-inc;
        else % final turnarounds, so start keeping a tally
            num_turns = num_turns + 1;
            reversals(num_turns)=p.SNR_dB;
            fout = fopen(OutFile, 'at');fprintf(fout,',*');fclose(fout);
        end
        % reset change indicator
        previous_change = current_change;
    end
    
    % change stimulus level
    p.SNR_dB = p.SNR_dB +  change*current_change;
    
    % if still on initial descent, change rules if SNR too low & change step size
    if (levitts_index==1 && p.SNR_dB<=p.InitialDescentMinimum)
        levitts_index=2;
        % change = change-inc;
    end
    
    % ensure that the current stimulus level is within the possible range
    % keep track of hitting the endpoints
    if (p.SNR_dB > p.MAX_SNR_dB)
        p.SNR_dB = p.MAX_SNR_dB;
        limit = limit+1;
    end
end  % end of a single run */

EndTime=fix(clock);
EndTimeString=sprintf('%02d:%02d:%02d',EndTime(4),EndTime(5),EndTime(6));

%% output a summary file, including all the control paramters
[varNames, varValues] = outputSummaryFromStructure(p);
fout = fopen(SummaryOutFile, 'at');

%                  1      2      3     4    5     6        7     8      9    10           11
fprintf(fout,'listener,CondCode,date,start,end,version,feedback,');
fprintf(fout,'nTrials,finish,uRevs,sdRevs,nRevs,uLevs,sdLevs,nLevs');
%               8        9    10    11     12     13    14    15
% add all the extra information
fprintf(fout,',%s',varNames);
fprintf(fout, '\n%s,%s,%s,%s,%s,%4.1f,%s,%d,', ...
    p.ListenerName,CondCode,StartDate,StartTimeString,EndTimeString,VERSION,p.FeedBack,trial);


%% print out summary statistics -- how did we get here?
if (limit>=3) % bumped up against the limits
    fprintf(fout,'BUMPED,,,,,,');
else
    if strcmp(response,'quit')  % test for quitting
        fprintf(fout, 'QUIT,');
    elseif (num_turns<p.FINAL_TURNS)
        fprintf(fout, 'RanOut,');
    else
        fprintf(fout, 'Normal,');
    end
    if num_turns>1
        fprintf(fout, '%5.2f,%5.2f,%d,', ...
            mean(reversals), std(reversals), num_turns);
    else
        fprintf(fout, '0,0,%d,',num_turns);
    end
    if num_final_trials>1
        fprintf(fout, '%5.2f,%5.2f,%d', ...
            mean(final_trials), std(final_trials), num_final_trials);
    else
        fprintf(fout, '0,0,%d',num_final_trials);
    end
end
fprintf(fout,',%s\n',varValues);
fclose('all');

%% clean up
set(0,'ShowHiddenHandles','on');
delete(findobj('Type','figure'));
if ~p.DEBUG && ~p.PlotTrackFile
    FinishButton; % indicate test is over
elseif p.PlotTrackFile
    plotTrackFile(OutFile, FileListenerName); %strrep(strrep(OutFile, '.csv', ''))
end

if p.usePlayrec==1
    if playrec('isInitialised')
        playrec('reset');
    end
end

