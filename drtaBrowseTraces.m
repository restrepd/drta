function varargout = drtaBrowseTraces(varargin)
% DRTABROWSETRACES M-file for drtaBrowseTraces.fig
%      DRTABROWSETRACES, by itself, creates a new DRTABROWSETRACES or raises the existing
%      singleton*.
%
%      H = DRTABROWSETRACES returns the handle to a new DRTABROWSETRACES or the handle to
%      the existing singleton*.
%
%      DRTABROWSETRACES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRTABROWSETRACES.M with the given input arguments.
%
%      DRTABROWSETRACES('Property','Value',...) creates a new DRTABROWSETRACES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drtaBrowseTraces_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drtaBrowseTraces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drtaBrowseTraces

% Last Modified by GUIDE v2.5 04-Jun-2017 12:07:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drtaBrowseTraces_OpeningFcn, ...
                   'gui_OutputFcn',  @drtaBrowseTraces_OutputFcn, ...
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


% --- Executes just before drtaBrowseTraces is made visible.
function drtaBrowseTraces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drtaBrowseTraces (see VARARGIN)

% Choose default command line output for drtaBrowseTraces
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);



% UIWAIT makes drtaBrowseTraces wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drtaBrowseTraces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
handles.w.drtaBrowseTraces=hObject;
%handles.p.which_channel=1;
%handles.p.which_display=1;
%handles.p.do_filter=1;
handles.w.trialOutcome=handles.trialOutcome;
% handles.p.doSubtract=0;
% handles.p.low_filter=1000;
% handles.p.high_filter=5000;
% handles.p.subtractCh=[1 8 11 15];



% Setup popup strings
popstr={'all','1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Digital'};
set(handles.drtaPSWhichChan,'String',popstr);
set(handles.drtaWhichDisplay,'String',popstr);
set(handles.drtaEditYRange,'String',num2str(handles.draq_p.prev_ylim(1)));
set(handles.drtaTrialPush,'String',drta('getTrialNo',handles.w.drta));
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time));
set(handles.drtaEditTimeInterval,'String',num2str(handles.p.display_interval));
set(handles.drtaRadioFilter,'Value',handles.p.do_filter);
set(handles.drtaLFPmax,'String',num2str(handles.p.lfp.maxLFP))
set(handles.drtaLFPmin,'String',num2str(handles.p.lfp.minLFP))
%set(handles.drtaBrTr3xSD,'Value',handles.p.do_3xSD);

%Please note that in the old files there is no handles.p.doSubtract
if ~isfield(handles.p,'doSubtract')
   handles.p.doSubtract=0;
   handles.p.subtractCh=zeros(1,16);
end

set(handles.drtaDiff,'Value', handles.p.doSubtract);

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub1,'String',popstr);
set(handles.drtaSub1,'Value',handles.p.subtractCh(1));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub2,'String',popstr);
set(handles.drtaSub2,'Value',handles.p.subtractCh(2));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub3,'String',popstr);
set(handles.drtaSub3,'Value',handles.p.subtractCh(3));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub4,'String',popstr);
set(handles.drtaSub4,'Value',handles.p.subtractCh(4));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub5,'String',popstr);
set(handles.drtaSub5,'Value',handles.p.subtractCh(5));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub6,'String',popstr);
set(handles.drtaSub6,'Value',handles.p.subtractCh(6));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub7,'String',popstr);
set(handles.drtaSub7,'Value',handles.p.subtractCh(7));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub8,'String',popstr);
set(handles.drtaSub8,'Value',handles.p.subtractCh(8));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub9,'String',popstr);
set(handles.drtaSub9,'Value',handles.p.subtractCh(9));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub10,'String',popstr);
set(handles.drtaSub10,'Value',handles.p.subtractCh(10));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub11,'String',popstr);
set(handles.drtaSub11,'Value',handles.p.subtractCh(11));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub12,'String',popstr);
set(handles.drtaSub12,'Value',handles.p.subtractCh(12));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub13,'String',popstr);
set(handles.drtaSub13,'Value',handles.p.subtractCh(13));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub14,'String',popstr);
set(handles.drtaSub14,'Value',handles.p.subtractCh(14));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub15,'String',popstr);
set(handles.drtaSub15,'Value',handles.p.subtractCh(15));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub16,'String',popstr);
set(handles.drtaSub16,'Value',handles.p.subtractCh(16));

popstr={'Raw','Raw -mean','High Theta 6-10','Theta 2-12','Beta 15-36','Gamma1 35-65',...
    'Gamma2 65-95','Gamma 35-95','Spikes 1000-5000','Spike var', 'digital'};
set(handles.drtaRadioFilter,'String',popstr);
set(handles.drtaRadioFilter,'Value',1);
if isfield(handles.p,'exc_sn')
   set(handles.drtaRadioExclSn,'Value',handles.p.exc_sn);
else
    handles.p.exc_sn=0;
end

handles.draq_p.auto_thr_sign=1;


toc

% Update the handles structure
guidata(hObject, handles);

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


% --- Executes during object creation, after setting all properties.
function drtaEditYRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEditYRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function drtaEditYRange_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditYRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditYRange as text
%        str2double(get(hObject,'String')) returns contents of drtaEditYRange as a double

y_range=str2double(get(hObject,'String'));

v_range=y_range*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000;

% if v_range>handles.draq_p.inp_max
%     set(hObject,'String',num2str(1000000*handles.draq_p.inp_max/(handles.draq_p.pre_gain*handles.draq_p.daq_gain)));
% end
            
if (handles.p.which_channel==1)
   %Change for all channels
    for ii=1:handles.draq_p.no_spike_ch
%         if v_range>handles.draq_p.inp_max
%             handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
%         else
            handles.draq_p.prev_ylim(ii)=y_range;
%         end
    end
else
    ii=handles.p.which_channel-1;
%     if v_range>handles.draq_p.inp_max
%         handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max(2)/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
%     else
        handles.draq_p.prev_ylim(ii)=y_range;
%     end
end

% Update all handles structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes on button press in drtaBackPush.
function drtaBackPush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaBackPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newTrial=drta('getTrialNo',handles.w.drta)-1;
handles.p.trialNo=drta('setTrialNo',handles.w.drta,newTrial);
set(handles.drtaTrialPush,'String', num2str(handles.p.trialNo));
%updateBrowseTraces(hObject);
% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);

% --- Executes on button press in drtaForwardPush.
function drtaForwardPush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaForwardPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.p.trialNo=drta('getTrialNo',handles.w.drta)+1;
handles.p.trialNo=drta('setTrialNo',handles.w.drta, handles.p.trialNo);
set(handles.drtaTrialPush,'String',num2str(handles.p.trialNo));
%updateBrowseTraces(hObject); 
% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


function drtaTrialPush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaTrialPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaTrialPush as text
%        str2double(get(hObject,'String')) returns contents of drtaTrialPush as a double

handles.p.trialNo=str2double(get(hObject,'String'));
handles.p.trialNo=drta('setTrialNo',handles.w.drta, handles.p.trialNo);
set(handles.drtaTrialPush,'String',num2str(handles.p.trialNo));
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaTrialPush_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaTrialPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Should be called by parent window
function updateBrowseTraces(hObject)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles=guidata(gcbo);

drtaPlotBrowseTraces(handles);
% Update the handles structure
% if handles.w.drtaThresholdSnips~=0
%     drtaThresholdSnips('updateBrowseTraces',handles.w.drtaThresholdSnips);
% end


% --- Executes on selection change in drtaPSWhichChan.
function drtaPSWhichChan_Callback(hObject, eventdata, handles)
% hObject    handle to drtaPSWhichChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drtaPSWhichChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaPSWhichChan

handles.p.which_channel=get(hObject,'Value');

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


function drtaEditTimeInterval_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditTimeInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditTimeInterval as text
%        str2double(get(hObject,'String')) returns contents of drtaEditTimeInterval as a double

time_interval=str2num(get(hObject,'String'));

if(handles.p.start_display_time+time_interval)>handles.draq_p.sec_per_trigger
   time_interval= handles.draq_p.sec_per_trigger-handles.p.start_display_time;
end
    
handles.p.display_interval=time_interval;
set(hObject,'String',num2str(handles.p.display_interval));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaEditTimeInterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEditTimeInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaEditTimeStart_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditTimeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditTimeStart as text
%        str2double(get(hObject,'String')) returns contents of drtaEditTimeStart as a double

start_time=str2num(get(hObject,'String'));
if start_time<handles.draq_p.acquire_display_start
   start_time= handles.draq_p.acquire_display_start;
end

if (start_time+handles.p.display_interval)>handles.draq_p.sec_per_trigger
   start_time= handles.draq_p.sec_per_trigger-handles.p.display_interval;
end
handles.p.start_display_time=start_time;
set(hObject,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaEditTimeStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEditTimeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in drtaFwdStartTimePush.
function drtaFwdStartTimePush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaFwdStartTimePush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.p.start_display_time+handles.p.display_interval)<handles.draq_p.sec_per_trigger
   handles.p.start_display_time= handles.p.start_display_time+handles.p.display_interval;
end
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes on button press in drtaBackStartTimePush.
function drtaBackStartTimePush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaBackStartTimePush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.p.start_display_time-handles.p.display_interval)>handles.draq_p.acquire_display_start
   handles.p.start_display_time= handles.p.start_display_time-handles.p.display_interval;
end
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function sets a threshold at the voltage clicked by the user
% 
% set(hObject,'Units','normalized');
% mouse_loc=get(hObject,'CurrentPoint');
% scaling = handles.draq_p.scaling;
% offset = handles.draq_p.offset;
% 
% if handles.p.which_display==1
%     for (ii=1:handles.draq_p.no_spike_ch)
%         if ((mouse_loc(2)<handles.draq_p.fig_max(ii))&&(mouse_loc(2)>handles.draq_p.fig_min(ii)))
%             handles.p.threshold(ii)=((mouse_loc(2)-handles.draq_p.fig_min(ii))/(handles.draq_p.fig_max(ii)...
%                 -handles.draq_p.fig_min(ii)))*(2*handles.draq_p.prev_ylim(ii))-handles.draq_p.prev_ylim(ii);  
%         end
%     end
% else
%    ii=handles.p.which_display-1;
%    handles.p.threshold(ii)=((mouse_loc(2)-handles.draq_p.fig_min(ii))/(handles.draq_p.fig_max(ii)-...
%        handles.draq_p.fig_min(ii)))*(2*handles.draq_p.prev_ylim(ii))-handles.draq_p.prev_ylim(ii);
% 
% end
% 
% % Update all handles.p structures
% handles.p.set2p5SD=0;
% handles.p.setm2p5SD=0;
% handles.p.setThr=0;
% handles.p.thrToSet=0;
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
% drtaPlotBrowseTraces(handles);


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in drtaWhichDisplay.
function drtaWhichDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to drtaWhichDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drtaWhichDisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaWhichDisplay
handles.p.which_display=get(hObject,'Value');

if handles.p.which_display==1
   for (ii=1:handles.draq_p.no_spike_ch) 
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
   end
else
   ii=handles.p.which_display-1;
   handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(handles.draq_p.no_spike_ch-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
   handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(1-0.5);
end

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaWhichDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaWhichDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drtaRadioFilter.
function drtaRadioFilter_Callback(hObject, eventdata, handles)
% hObject    handle to drtaRadioFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaRadioFilter

%This one allows changing the plot
handles.p.whichPlot=get(hObject,'Value');


% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on button press in drtaBrTr3xSD.
function drtaBrTr3xSD_Callback(hObject, eventdata, handles)
% hObject    handle to drtaBrTr3xSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaBrTr3xSD

handles.p.do_3xSD=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);



% --- Executes on button press in drtaRadioExclSn.
function drtaRadioExclSn_Callback(hObject, eventdata, handles)
% hObject    handle to drtaRadioExclSn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaRadioExclSn
handles.p.exc_sn=get(hObject,'Value');
%set(hObject,'String',num2str(handles.p.display_interval));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


function drtaEditExcSn_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditExcSn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditExcSn as text
%        str2double(get(hObject,'String')) returns contents of drtaEditExcSn as a double
handles.p.exc_sn_thr=str2num(get(hObject,'String'));
%set(hObject,'String',num2str(handles.p.display_interval));

if ~isfield(handles.p,'exc_sn_ch')
    handles.p.exc_sn_ch=1;
    set(handles.drtaEditExCh,'String',num2str(handles.p.exc_sn_ch));
end

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaEditExcSn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEditExcSn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaEditExCh_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditExCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditExCh as text
%        str2double(get(hObject,'String')) returns contents of drtaEditExCh as a double
handles.p.exc_sn_ch=str2num(get(hObject,'String'));
%set(hObject,'String',num2str(handles.p.exc_sn_thr_9to16));

if handles.p.exc_sn_ch>16
    handles.p.exc_sn_ch=16;
end

if handles.p.exc_sn_ch<1
    handles.p.exc_sn_ch=1;
end



% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);


% --- Executes during object creation, after setting all properties.
function drtaEditExCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaEditExCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function trialOutcome_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialOutcome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in drtaBrowseDraPush.
function setTrialsOutcome(hObject,trialsOutcome)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
handlesb=guidata(handles.w.drtaBrowseTraces);
try
set(handlesb.trialOutcome,'String',trialsOutcome);
catch
end

% Update handles structure
%guidata(hObject, handles);




% --- Executes on button press in drtaMClust.
function drtaMClust_Callback(hObject, eventdata, handles)
% hObject    handle to drtaMClust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drtaGenerateMClust(hObject, handles);


% --- Executes on selection change in drtaSub1.
function drtaSub1_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub1

handles.p.subtractCh(1)=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub5.
function drtaSub5_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub5

handles.p.subtractCh(5)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub9.
function drtaSub9_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub9
handles.p.subtractCh(9)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes during object creation, after setting all properties.
function drtaSub9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub13.
function drtaSub13_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub13

handles.p.subtractCh(13)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drtaDiff.
function drtaDiff_Callback(hObject, eventdata, handles)
% hObject    handle to drtaDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaDiff

if get(hObject,'Value')==1
    handles.p.doSubtract=1;
else
    handles.p.doSubtract=0;
end
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub2.
function drtaSub2_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub2
handles.p.subtractCh(2)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub3.
function drtaSub3_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub3
handles.p.subtractCh(3)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub4.
function drtaSub4_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub4
handles.p.subtractCh(4)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub6.
function drtaSub6_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub6
handles.p.subtractCh(6)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub7.
function drtaSub7_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub7
handles.p.subtractCh(7)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub8.
function drtaSub8_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub8
handles.p.subtractCh(8)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub10.
function drtaSub10_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub10
handles.p.subtractCh(10)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub11.
function drtaSub11_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub11
handles.p.subtractCh(11)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub12.
function drtaSub12_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub12
handles.p.subtractCh(12)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub14.
function drtaSub14_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub14
handles.p.subtractCh(14)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes during object creation, after setting all properties.
function drtaSub14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub15.
function drtaSub15_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub15
handles.p.subtractCh(15)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drtaSub16.
function drtaSub16_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub16
handles.p.subtractCh(16)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes during object creation, after setting all properties.
function drtaSub16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSub16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_thr.
function auto_thr_Callback(hObject, eventdata, handles)
% hObject    handle to auto_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of auto_thr






function drtaLFPmin_Callback(hObject, eventdata, handles)
% hObject    handle to drtaLFPmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaLFPmin as text
%        str2double(get(hObject,'String')) returns contents of drtaLFPmin as a double
handles.p.lfp.minLFP=str2num(get(hObject,'String'));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);



% --- Executes during object creation, after setting all properties.
function drtaLFPmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaLFPmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaLFPmax_Callback(hObject, eventdata, handles)
% hObject    handle to drtaLFPmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaLFPmax as text
%        str2double(get(hObject,'String')) returns contents of drtaLFPmax as a double
handles.p.lfp.maxLFP=str2num(get(hObject,'String'));

% Update all handles.p structures
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes during object creation, after setting all properties.
function drtaLFPmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaLFPmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaSetnxSD_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSetnxSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaSetnxSD as text
%        str2double(get(hObject,'String')) returns contents of drtaSetnxSD as a double
 
handles.p.setnxSD=1;
handles.p.nxSD=str2double(get(hObject,'String'));
% Update handles structure
handles=drtaPlotBrowseTraces(handles)
handles.p.setnxSD=0;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function drtaSetnxSD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSetnxSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function setThr_Callback(hObject, eventdata, handles)
% hObject    handle to setThr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setThr as text
%        str2double(get(hObject,'String')) returns contents of setThr as a double
handles.p.setThr=1;
handles.p.thrToSet=str2double(get(hObject,'String'));
drta('drtaUpdateAllHandlespw',handles.w.drta,handles);

% --- Executes during object creation, after setting all properties.
function setThr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setThr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pullThr.
function pullThr_Callback(hObject, eventdata, handles)
% hObject    handle to pullThr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fullName=handles.p.fullName;
FileName=handles.p.FileName;
PathName=handles.p.PathName;
trialNo=handles.p.trialNo;
start_display_time=handles.p.start_display_time;
display_interval=handles.p.display_interval;
which_channel=handles.p.which_channel;
which_display=handles.p.which_display;
trial_ch_processed=handles.p.trial_ch_processed;
trial_allch_processed=handles.p.trial_allch_processed;
if isfield(handles.p,'tetr_processed')
    tetr_processed=handles.p.tetr_processed;
else
    tetr_processed=[0 0 0 0];
end

handles.p=drtaPullThreshold;

handles.p.fullName=fullName;
handles.p.FileName=FileName;
handles.p.PathName=PathName;
handles.p.trialNo=trialNo;
handles.p.start_display_time=start_display_time;
handles.p.display_interval=display_interval;
handles.p.which_channel=which_channel;
handles.p.which_display=which_display;
handles.p.trial_ch_processed=trial_ch_processed;
handles.p.trial_allch_processed=trial_allch_processed;
handles.p.tetr_processed=tetr_processed;


drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaPlotBrowseTraces(handles);