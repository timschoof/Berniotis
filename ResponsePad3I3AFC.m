function varargout = ResponsePad3I3AFC(varargin)
% RESPONSEPAD3I3AFC MATLAB code for ResponsePad3I3AFC.fig
%      RESPONSEPAD3I3AFC, by itself, creates a new RESPONSEPAD3I3AFC or raises the existing
%      singleton*.
%
%      H = RESPONSEPAD3I3AFC returns the handle to a new RESPONSEPAD3I3AFC or the handle to
%      the existing singleton*.
%
%      RESPONSEPAD3I3AFC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSEPAD3I3AFC.M with the given input arguments.
%
%      RESPONSEPAD3I3AFC('Property','Value',...) creates a new RESPONSEPAD3I3AFC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResponsePad3I3AFC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResponsePad3I3AFC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResponsePad3I3AFC

% Last Modified by GUIDE v2.5 20-Jul-2018 18:09:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResponsePad3I3AFC_OpeningFcn, ...
                   'gui_OutputFcn',  @ResponsePad3I3AFC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ResponsePad3I3AFC is made visible.
function ResponsePad3I3AFC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResponsePad3I3AFC (see VARARGIN)

movegui('center'); 

% Choose default command line output for ResponsePad3I3AFC
handles.output = hObject;
handles.FeedbackDurationSec=.6;
OneSoundDuration=varargin{1};
ISI=varargin{2};
handles.CorrectAnswer=varargin{3};
handles.CorrectImage=varargin{4};
handles.WrongImage=varargin{5};

% Update handles structure
guidata(hObject, handles);

% if varargin{8}==1 % the first trial
%     pause(2)
% end

% playEm = audioplayer(varargin{1},varargin{2});
% play(playEm);

% UIWAIT makes ResponsePad3I3AFC wait for user response (see UIRESUME)
if varargin{6}==0 % the first trial
    uiresume(handles.figure1)
else
    uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ResponsePad3I3AFC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
if isempty(handles)
    varargout{1}='quit';
else
    varargout{1} = handles.output;
end


% --- Executes on button press in interval1.
function interval1_Callback(hObject, eventdata, handles)
% hObject    handle to interval1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 1;
if handles.CorrectAnswer==1
   set(handles.interval1,'cdata',handles.CorrectImage);
else
    set(handles.interval1,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval1,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 


% --- Executes on button press in interval2.
function interval2_Callback(hObject, eventdata, handles)
% hObject    handle to interval2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 2;
if handles.CorrectAnswer==2
   set(handles.interval2,'cdata',handles.CorrectImage);
else
    set(handles.interval2,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval2,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 


% --- Executes on button press in interval3.
function interval3_Callback(hObject, eventdata, handles)
% hObject    handle to interval3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 3;
if handles.CorrectAnswer==3
   set(handles.interval3,'cdata',handles.CorrectImage);
else
    set(handles.interval3,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval3,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 
