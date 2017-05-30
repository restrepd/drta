function varargout = drtaThresholdSnips(varargin)
% DRTATHRESHOLDSNIPS M-file for drtaThresholdSnips.fig
%      DRTATHRESHOLDSNIPS, by itself, creates a new DRTATHRESHOLDSNIPS or raises the existing
%      singleton*.
%
%      H = DRTATHRESHOLDSNIPS returns the handle to a new DRTATHRESHOLDSNIPS or the handle to
%      the existing singleton*.
%
%      DRTATHRESHOLDSNIPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRTATHRESHOLDSNIPS.M with the given input arguments.
%
%      DRTATHRESHOLDSNIPS('Property','Value',...) creates a new DRTATHRESHOLDSNIPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drtaThresholdSnips_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drtaThresholdSnips_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drtaThresholdSnips

% Last Modified by GUIDE v2.5 07-Sep-2014 17:40:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drtaThresholdSnips_OpeningFcn, ...
                   'gui_OutputFcn',  @drtaThresholdSnips_OutputFcn, ...
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


% --- Executes just before drtaThresholdSnips is made visible.
function drtaThresholdSnips_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drtaThresholdSnips (see VARARGIN)

% Choose default command line output for drtaThresholdSnips
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);



% UIWAIT makes drtaThresholdSnips wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drtaThresholdSnips_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in draqPSWhichChan.
function draqPSWhichChan_Callback(hObject, eventdata, handles)
% hObject    handle to draqPSWhichChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns draqPSWhichChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from draqPSWhichChan
handles.p.which_channel=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function draqPSWhichChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to draqPSWhichChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Should be called by parent window
function update_p(hObject, handdrta)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


handles=guidata(hObject);
handles.p=handdrta.p;
% Update the handles structure
guidata(hObject, handles);

% --- Should be called by parent window
function updateHandles(hObject, eventdata, handdrta)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

tic
handles=guidata(hObject);
handles.p=handdrta.p;
handles.w=handdrta.w;
handles.draq_p=handdrta.draq_p;
handles.draq_d=handdrta.draq_d;
handles.w.drtaThresholdSnips=hObject;
%handles.p.which_channel=1;


% Setup popup strings
% popstr={'all','1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16'};
% set(handles.drtaPSWhichChan,'String',popstr);
popstr={'Pileup','Features','Mean-Value'};
set(handles.drtaThWhatDisplay,'String',popstr);
popstr={'dropcnsampler','dropcspm','background','spmult','mspy','osampler',...
    'spm2mult','lighton1','lighton5','dropcspm_conc','Laser-triggered'};
set(handles.drtaThCProgram,'String',popstr);,
popstr={'p_v','pc1','pc2','pc3','w1','w2','w3','w4','w5','w6','w7','w8','w9','w10','w11',...
    'w12','w13','w14','w15','w16','w17','w18','w19','w20','w21','w22','w23','w24','w25'};
set(handles.feature1,'String',popstr)
handles.draq_p.feature1=1;
popstr={'p_v','pc1','pc2','pc3','w1','w2','w3','w4','w5','w6','w7','w8','w9','w10','w11',...
    'w12','w13','w14','w15','w16','w17','w18','w19','w20','w21','w22','w23','w24','w25'};
set(handles.feature2,'String',popstr)
handles.draq_p.feature2=2;
if handles.p.which_channel_th==1
    %set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(1)));
    set(handles.drtaThrEnterUpperLimit,'String',num2str(handles.p.upper_limit(1)));
    set(handles.drtaThrEnterLowerLimit,'String',num2str(handles.p.lower_limit(1)));
else
   set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(handles.p.which_channel_th-1)));
   set(handles.drtaThrEnterUpperLimit,'String',num2str(handles.p.which_channel_th-1));
   set(handles.drtaThrEnterLowerLimit,'String',num2str(handles.p.which_channel_th-1));
end

% set(handles.drtaThCh1,'Value',handles.p.ch_processed(1));
% set(handles.drtaThCh2,'Value',handles.p.ch_processed(2));
% set(handles.drtaThCh3,'Value',handles.p.ch_processed(3));
% set(handles.drtaThCh4,'Value',handles.p.ch_processed(4));
% set(handles.drtaThCh5,'Value',handles.p.ch_processed(5));
% set(handles.drtaThCh6,'Value',handles.p.ch_processed(6));
% set(handles.drtaThCh7,'Value',handles.p.ch_processed(7));
% set(handles.drtaThCh8,'Value',handles.p.ch_processed(8));
% set(handles.drtaThCh9,'Value',handles.p.ch_processed(9));
% set(handles.drtaThCh10,'Value',handles.p.ch_processed(10));
% set(handles.drtaThCh11,'Value',handles.p.ch_processed(11));
% set(handles.drtaThCh12,'Value',handles.p.ch_processed(12));
% set(handles.drtaThCh13,'Value',handles.p.ch_processed(13));
% set(handles.drtaThCh14,'Value',handles.p.ch_processed(14));
% set(handles.drtaThCh15,'Value',handles.p.ch_processed(15));
% set(handles.drtaThCh16,'Value',handles.p.ch_processed(16));



set(handles.drtaTrialCh1,'Value',handles.p.trial_ch_processed(1,handles.p.trialNo));
set(handles.drtaTrialCh2,'Value',handles.p.trial_ch_processed(2,handles.p.trialNo));
set(handles.drtaTrialCh3,'Value',handles.p.trial_ch_processed(3,handles.p.trialNo));
set(handles.drtaTrialCh4,'Value',handles.p.trial_ch_processed(4,handles.p.trialNo));
set(handles.drtaTrialCh5,'Value',handles.p.trial_ch_processed(5,handles.p.trialNo));
set(handles.drtaTrialCh6,'Value',handles.p.trial_ch_processed(6,handles.p.trialNo));
set(handles.drtaTrialCh7,'Value',handles.p.trial_ch_processed(7,handles.p.trialNo));
set(handles.drtaTrialCh8,'Value',handles.p.trial_ch_processed(8,handles.p.trialNo));
set(handles.drtaTrialCh9,'Value',handles.p.trial_ch_processed(9,handles.p.trialNo));
set(handles.drtaTrialCh10,'Value',handles.p.trial_ch_processed(10,handles.p.trialNo));
set(handles.drtaTrialCh11,'Value',handles.p.trial_ch_processed(11,handles.p.trialNo));
set(handles.drtaTrialCh12,'Value',handles.p.trial_ch_processed(12,handles.p.trialNo));
set(handles.drtaTrialCh13,'Value',handles.p.trial_ch_processed(13,handles.p.trialNo));
set(handles.drtaTrialCh14,'Value',handles.p.trial_ch_processed(14,handles.p.trialNo));
set(handles.drtaTrialCh15,'Value',handles.p.trial_ch_processed(15,handles.p.trialNo));
set(handles.drtaTrialCh16,'Value',handles.p.trial_ch_processed(16,handles.p.trialNo));


set(handles.drtaTrialAll,'Value',handles.p.trial_allch_processed(1,handles.p.trialNo));
toc

% Update the handles structure
guidata(hObject, handles);
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

%drtaThresholdAndPlot(hObject, handles);

% --- Should be called by parent window
function up = getUpdatePreview(hObject)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles=guidata(hObject);
up = handles.p.update_preview;

% --- Should be called by parent window
function ylim = getYlim(hObject)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles=guidata(hObject);
ylim = handles.p.prev_ylim;

% --- Should be called by parent window
function setUpdatePreview(hObject,up)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles=guidata(hObject);
handles.p.update_preview=up;

% Update the handles structure
guidata(hObject, handles);

% % --- Should be called by parent window
% function updateBrowseTraces(hObject)
% % hObject    handle to drsDisplaySingle
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% handles=guidata(gcbo);
% drtaGenerateSnips(gcbo, handles);
% handles=guidata(gcbo);
% drtaPlotPileup(handles);


% --- Executes on selection change in drtaPSWhichChan.
function drtaPSWhichChan_Callback(hObject, eventdata, handles)
% hObject    handle to drtaPSWhichChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drtaPSWhichChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaPSWhichChan

old_which=handles.p.which_channel_th;
handles.p.which_channel_th=get(hObject,'Value');
if (handles.p.which_channel_th==1)
    if (old_which~=1)
       old_thr=handles.p.threshold(old_which-1);
       for ii=1:handles.draq_p.no_spike_ch-1
          handles.p.threshold(ii) = old_thr;
       end
    end
else
    set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(handles.p.which_channel_th-1)));
end
% Update handles structure
guidata(hObject, handles);



function drtaEnterThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEnterThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEnterThreshold as text
%        str2double(get(hObject,'String')) returns contents of drtaEnterThreshold as a double

if handles.p.which_channel_th==1
    for ii=1:handles.draq_p.no_spike_ch-1
        handles.p.threshold(ii)=str2double(get(hObject,'String'));
    end
else
    handles.p.threshold(handles.p.which_channel_th-1)=str2double(get(hObject,'String'));
end

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 
%drtaThresholdAndPlot(hObject, handles);


% --- Executes during object creation, after setting all properties.
function drtaEnterThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEnterThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drtaThresholdPush.
function drtaThresholdAndPlot(hObject, handles)
% hObject    handle to drtaThresholdPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


drtaGenerateSnips(hObject, handles);
handles=guidata(hObject);

switch handles.p.which_display_th
    
    case 1
        drtaPlotPileup(handles);
    case 2
        drtaPlotFeatures(handles);
        %drtaPlotSnips(handles);
    otherwise
        drtaPlotMV(handles);
end


% --- Executes on button press in drtaThresholdSnipsSet25.
function drtaThresholdSnipsSet25_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThresholdSnipsSet25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

drtaSetThreshold25(hObject, handles);
handles=guidata(hObject);
if handles.p.which_channel_th==1
   set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(1)));
else
   set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(handles.p.which_channel_th-1)));
end
%drtaThresholdAndPlot(hObject, handles);
% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 

% % --- Executes on button press in drtaThGeneratePlx.
% function drtaThGeneratePlx_Callback(hObject, eventdata, handles)
% % hObject    handle to drtaThGeneratePlx (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% if (isfield(handles.draq_d,'snip_samp'))
%    rmfield(handles.draq_d,'snip_samp');
%    rmfield(handles.draq_d,'snip_index');
%    rmfield(handles.draq_d,'snips');
% end
% 
% if (isfield(handles.draq_d,'noEvents'))
%    rmfield(handles.draq_d,'noEvents');
%    rmfield(handles.draq_d,'nEvPerType');
%    rmfield(handles.draq_d,'nEventTypes');
%    rmfield(handles.draq_d,'eventlabels');
%    rmfield(handles.draq_d,'events');
%    rmfield(handles.draq_d,'eventType');
%    rmfield(handles.draq_d,'blocks');
% end
% drtaGenerateEvents(handles);
% %drtaGenerateEventsOld(handles); %This will process old Splusminus events
% drtaGenerateSpikesAndSavePlx(handles);
% 
% % drtaGenerateAllSnips(hObject, handles);
% % handles=guidata(hObject);
% % drtaSavePlx(handles);



function drtaThrEnterUpperLimit_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThrEnterUpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaThrEnterUpperLimit as text
%        str2double(get(hObject,'String')) returns contents of drtaThrEnterUpperLimit as a double

if handles.p.which_channel_th==1
    for ii=1:handles.draq_p.no_spike_ch-1
        handles.p.upper_limit(ii)=str2double(get(hObject,'String'));
    end
else
    handles.p.upper_limit(handles.p.which_channel_th-1)=str2double(get(hObject,'String'));
end

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 
%drtaThresholdAndPlot(hObject, handles);


% --- Executes during object creation, after setting all properties.
function drtaThrEnterUpperLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaThrEnterUpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaThrEnterLowerLimit_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThrEnterLowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaThrEnterLowerLimit as text
%        str2double(get(hObject,'String')) returns contents of drtaThrEnterLowerLimit as a double

if handles.p.which_channel_th==1
    for ii=1:handles.draq_p.no_spike_ch-1
        handles.p.lower_limit(ii)=str2double(get(hObject,'String'));
    end
else
    handles.p.lower_limit(handles.p.which_channel_th-1)=str2double(get(hObject,'String'));
end

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 
%drtaThresholdAndPlot(hObject, handles);

% --- Executes during object creation, after setting all properties.
function drtaThrEnterLowerLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaThrEnterLowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in drtaThrPreview.
function drtaThrPreview_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThrPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 
drtaThresholdAndPlot(hObject, handles);


% --- Executes on selection change in drtaThWhatDisplay.
function drtaThWhatDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThWhatDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drtaThWhatDisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaThWhatDisplay

handles.p.which_display_th=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 

% --- Executes during object creation, after setting all properties.
function drtaThWhatDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaThWhatDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in drtaThCProgram.
function drtaThCProgram_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drtaThCProgram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaThCProgram


handles.p.which_c_program=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles); 

% --- Executes during object creation, after setting all properties.
function drtaThCProgram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaThCProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in drtaThCh1.
function drtaThCh1_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh1
handles.p.ch_processed(1)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


% --- Executes on button press in drtaThCh16.
function drtaThCh16_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh16
handles.p.ch_processed(16)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);



% --- Executes on button press in drtaThCh3.
function drtaThCh3_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh3
handles.p.ch_processed(3)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh4.
function drtaThCh4_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh4
handles.p.ch_processed(4)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh5.
function drtaThCh5_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh5
handles.p.ch_processed(5)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh6.
function drtaThCh6_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh6
handles.p.ch_processed(6)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh7.
function drtaThCh7_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh7
handles.p.ch_processed(7)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh8.
function drtaThCh8_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh8
handles.p.ch_processed(8)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh9.
function drtaThCh9_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh9
handles.p.ch_processed(9)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh10.
function drtaThCh10_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh10
handles.p.ch_processed(10)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh11.
function drtaThCh11_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh11
handles.p.ch_processed(11)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh12.
function drtaThCh12_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh12
handles.p.ch_processed(12)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh13.
function drtaThCh13_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh13

handles.p.ch_processed(13)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh14.
function drtaThCh14_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh14
handles.p.ch_processed(14)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaThCh15.
function drtaThCh15_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh15

handles.p.ch_processed(15)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


% --- Executes on button press in drtaThCh2.
function drtaThCh2_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaThCh2

handles.p.ch_processed(2)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


% --- Executes on button press in drtaThrSaveMat.
function drtaThrSaveMat_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThrSaveMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (isfield(handles.draq_d,'snip_samp'))
    try
   rmfield(handles.draq_d,'snip_samp');
    catch
        
    end
    try
   rmfield(handles.draq_d,'snip_index');
    catch
    end
    try
   rmfield(handles.draq_d,'snips');
    catch
    end
end

if (isfield(handles.draq_d,'noEvents'))
   rmfield(handles.draq_d,'noEvents');
   rmfield(handles.draq_d,'nEvPerType');
   rmfield(handles.draq_d,'nEventTypes');
   rmfield(handles.draq_d,'eventlabels');
   
   try
   rmfield(handles.draq_d,'events');
   rmfield(handles.draq_d,'eventType');
   catch
   end
   
   
   try
   rmfield(handles.draq_d,'blocks');
   catch   
   end
end

drtaGenerateEvents(handles);



% --- Executes on button press in drtaTrialCh1.
function drtaTrialCh1_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh1

handles.p.trial_ch_processed(1,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh2.
function drtaTrialCh2_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh2

handles.p.trial_ch_processed(2,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh3.
function drtaTrialCh3_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh3

handles.p.trial_ch_processed(3,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh4.
function drtaTrialCh4_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh4

handles.p.trial_ch_processed(4,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh5.
function drtaTrialCh5_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh5

handles.p.trial_ch_processed(5,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh6.
function drtaTrialCh6_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh6

handles.p.trial_ch_processed(6,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh7.
function drtaTrialCh7_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh7

handles.p.trial_ch_processed(7,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh8.
function drtaTrialCh8_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh8

handles.p.trial_ch_processed(8,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh9.
function drtaTrialCh9_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh9

handles.p.trial_ch_processed(9,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh10.
function drtaTrialCh10_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh10

handles.p.trial_ch_processed(10,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh11.
function drtaTrialCh11_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh11

handles.p.trial_ch_processed(11,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh12.
function drtaTrialCh12_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh12

handles.p.trial_ch_processed(12,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures

drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
% --- Executes on button press in drtaTrialCh13.
function drtaTrialCh13_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh13

handles.p.trial_ch_processed(13,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh14.
function drtaTrialCh14_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh14

handles.p.trial_ch_processed(14,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh15.
function drtaTrialCh15_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh15

handles.p.trial_ch_processed(15,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialCh16.
function drtaTrialCh16_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialCh16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialCh16

handles.p.trial_ch_processed(16,handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes on button press in drtaTrialAll.
function drtaTrialAll_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaTrialAll

handles.p.trial_ch_processed(1:16,handles.p.trialNo)=ones(16,1)*get(hObject,'Value');
set(handles.drtaTrialCh1,'Value',handles.p.trial_ch_processed(1,handles.p.trialNo));
set(handles.drtaTrialCh2,'Value',handles.p.trial_ch_processed(2,handles.p.trialNo));
set(handles.drtaTrialCh3,'Value',handles.p.trial_ch_processed(3,handles.p.trialNo));
set(handles.drtaTrialCh4,'Value',handles.p.trial_ch_processed(4,handles.p.trialNo));
set(handles.drtaTrialCh5,'Value',handles.p.trial_ch_processed(5,handles.p.trialNo));
set(handles.drtaTrialCh6,'Value',handles.p.trial_ch_processed(6,handles.p.trialNo));
set(handles.drtaTrialCh7,'Value',handles.p.trial_ch_processed(7,handles.p.trialNo));
set(handles.drtaTrialCh8,'Value',handles.p.trial_ch_processed(8,handles.p.trialNo));
set(handles.drtaTrialCh9,'Value',handles.p.trial_ch_processed(9,handles.p.trialNo));
set(handles.drtaTrialCh10,'Value',handles.p.trial_ch_processed(10,handles.p.trialNo));
set(handles.drtaTrialCh11,'Value',handles.p.trial_ch_processed(11,handles.p.trialNo));
set(handles.drtaTrialCh12,'Value',handles.p.trial_ch_processed(12,handles.p.trialNo));
set(handles.drtaTrialCh13,'Value',handles.p.trial_ch_processed(13,handles.p.trialNo));
set(handles.drtaTrialCh14,'Value',handles.p.trial_ch_processed(14,handles.p.trialNo));
set(handles.drtaTrialCh15,'Value',handles.p.trial_ch_processed(15,handles.p.trialNo));
set(handles.drtaTrialCh16,'Value',handles.p.trial_ch_processed(16,handles.p.trialNo));

handles.p.trial_allch_processed(handles.p.trialNo)=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

function drtaThSnSetTrials(hObject,handles)
% hObject    handle to drtaTrialAll (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

set(handles.drtaTrialCh1,'Value',handles.p.trial_ch_processed(1,handles.p.trialNo));
set(handles.drtaTrialCh2,'Value',handles.p.trial_ch_processed(2,handles.p.trialNo));
set(handles.drtaTrialCh3,'Value',handles.p.trial_ch_processed(3,handles.p.trialNo));
set(handles.drtaTrialCh4,'Value',handles.p.trial_ch_processed(4,handles.p.trialNo));
set(handles.drtaTrialCh5,'Value',handles.p.trial_ch_processed(5,handles.p.trialNo));
set(handles.drtaTrialCh6,'Value',handles.p.trial_ch_processed(6,handles.p.trialNo));
set(handles.drtaTrialCh7,'Value',handles.p.trial_ch_processed(7,handles.p.trialNo));
set(handles.drtaTrialCh8,'Value',handles.p.trial_ch_processed(8,handles.p.trialNo));
set(handles.drtaTrialCh9,'Value',handles.p.trial_ch_processed(9,handles.p.trialNo));
set(handles.drtaTrialCh10,'Value',handles.p.trial_ch_processed(10,handles.p.trialNo));
set(handles.drtaTrialCh11,'Value',handles.p.trial_ch_processed(11,handles.p.trialNo));
set(handles.drtaTrialCh12,'Value',handles.p.trial_ch_processed(12,handles.p.trialNo));
set(handles.drtaTrialCh13,'Value',handles.p.trial_ch_processed(13,handles.p.trialNo));
set(handles.drtaTrialCh14,'Value',handles.p.trial_ch_processed(14,handles.p.trialNo));
set(handles.drtaTrialCh15,'Value',handles.p.trial_ch_processed(15,handles.p.trialNo));
set(handles.drtaTrialCh16,'Value',handles.p.trial_ch_processed(16,handles.p.trialNo));


set(handles.drtaTrialAll,'Value',handles.p.trial_allch_processed(1,handles.p.trialNo));


% --- Executes on button press in drtaLoadTh.
function drtaLoadTh_Callback(hObject, eventdata, handles)
% hObject    handle to drtaLoadTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.*','Select . mat file to open');
handles.p.loadThName=[PathName,FileName];
load(handles.p.loadThName);
handles.p.threshold=drta_p.threshold;
handles.p.upper_limit=drta_p.upper_limit;
handles.p.lower_limit=drta_p.lower_limit;

if handles.p.which_channel_th==1
    set(handles.drtaThrEnterLowerLimit,'String',num2str(handles.p.lower_limit(1)));
    set(handles.drtaThrEnterUpperLimit,'String',num2str(handles.p.upper_limit(1)));
    set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(1)));
else
    set(handles.drtaThrEnterLowerLimit,'String',num2str(handles.p.lower_limit(handles.p.which_channel_th-1)));
    set(handles.drtaThrEnterUpperLimit,'String',num2str(handles.p.upper_limit(handles.p.which_channel_th-1)));
    set(handles.drtaEnterThreshold,'String',num2str(handles.p.threshold(handles.p.which_channel_th-1)));
end


handles.p.ch_processed=drta_p.ch_processed;
set(handles.drtaThCh1,'Value',handles.p.ch_processed(1));
set(handles.drtaThCh2,'Value',handles.p.ch_processed(2));
set(handles.drtaThCh3,'Value',handles.p.ch_processed(3));
set(handles.drtaThCh4,'Value',handles.p.ch_processed(4));
set(handles.drtaThCh5,'Value',handles.p.ch_processed(5));
set(handles.drtaThCh6,'Value',handles.p.ch_processed(6));
set(handles.drtaThCh7,'Value',handles.p.ch_processed(7));
set(handles.drtaThCh8,'Value',handles.p.ch_processed(8));
set(handles.drtaThCh9,'Value',handles.p.ch_processed(9));
set(handles.drtaThCh10,'Value',handles.p.ch_processed(10));
set(handles.drtaThCh11,'Value',handles.p.ch_processed(11));
set(handles.drtaThCh12,'Value',handles.p.ch_processed(12));
set(handles.drtaThCh13,'Value',handles.p.ch_processed(13));
set(handles.drtaThCh14,'Value',handles.p.ch_processed(14));
set(handles.drtaThCh15,'Value',handles.p.ch_processed(15));
set(handles.drtaThCh16,'Value',handles.p.ch_processed(16));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


% --- Executes on selection change in feature1.
function feature1_Callback(hObject, eventdata, handles)
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns feature1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from feature1
handles.draq_p.feature1=get(hObject,'Value');
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


% --- Executes during object creation, after setting all properties.
function feature1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in feature2.
function feature2_Callback(hObject, eventdata, handles)
% hObject    handle to feature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns feature2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from feature2

handles.draq_p.feature2=get(hObject,'Value');
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes during object creation, after setting all properties.
function feature2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeBeforeFV_Callback(hObject, eventdata, handles)
% hObject    handle to timeBeforeFV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeBeforeFV as text
%        str2double(get(hObject,'String')) returns contents of timeBeforeFV as a double


% --- Executes during object creation, after setting all properties.
function timeBeforeFV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBeforeFV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in allOn.
function allOn_Callback(hObject, eventdata, handles)
% hObject    handle to allOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.p.trial_ch_processed(1:16,1:handles.draq_d.noTrials)=ones(16,handles.draq_d.noTrials);
handles.p.trial_allch_processed(1,1:handles.draq_d.noTrials)=ones(1,handles.draq_d.noTrials);

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
