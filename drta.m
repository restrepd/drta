function varargout = drta(varargin)
% DRTA M-file for drta.fig
%      DRTA, by itself, creates a new DRTA or raises the existing
%      singleton*.
%
%      H = DRTA returns the handle to a new DRTA or the handle to
%      the existing singleton*.
%
%      DRTA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRTA.M with the given input arguments.
%
%      DRTA('Property','Value',...) creates a new DRTA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drta_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drta_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drta

% Last Modified by GUIDE v2.5 02-Mar-2018 17:53:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drta_OpeningFcn, ...
                   'gui_OutputFcn',  @drta_OutputFcn, ...
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


% --- Executes just before drta is made visible.
function drta_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drta (see VARARGIN)

% Choose default command line output for drta
%load('C:\Awake Data\drta_preferences.mat');
prefs=drtaSetPreferences();
handles.p=prefs;
handles.output = hObject;
%handles.p.trialNo=1;
handles.w.drta=hObject;
handles.w.drtaBrowseTraces=0;
handles.w.drtaThresholdSnips=0;
handles.p.threexsdexists(1:16)=0;

%Populate string for drtaVersion modification date
if strcmp('diegorereposmbp.ucdenver.pvt',getComputerName)||strcmp('diego-restrepos-macbook-pro.local',getComputerName)
    p = mfilename('fullpath');
    fileDirectory = fileparts(p);
    moddatedir = dir(fileDirectory);
    moddatetag = moddatedir.date;
    set(handles.drtaVersion,'String',['ver ',moddatetag]);
end


handles.p.trialNo=2;
handles.p.low_filter=1000;
handles.p.high_filter=5000;
handles.p.whichPlot=1;
handles.p.lastTrace=-1;
handles.p.exclude_secs=2;
handles.p.set2p5SD=0;
handles.p.setm2p5SD=0;
handles.p.setnxSD=0;
handles.p.nxSD=2.5;
handles.p.showLicks=1;
handles.p.exc_sn=0;
handles.p.read_entire_file=0;
handles.p.setThr=0;
handles.p.thrToSet=0;
handles.p.which_protocol=1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drta wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drta_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





function drtaUpdateAllHandlespw(hObject, newhandles)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
handles.p=newhandles.p;
handles.draq_p=newhandles.draq_p;
% Update handles structure
guidata(gcbo, handles);

if handles.w.drtaBrowseTraces~=0
    hObject=handles.w.drtaBrowseTraces;
    handles=guidata(hObject);
    handles.p=newhandles.p;
    handles.w=newhandles.w;
    handles.draq_p=newhandles.draq_p;
    % Update the handles structure
    guidata(hObject, handles);
    %drtaBrowseTraces('updateBrowseTraces',hObject);
end

handles=guidata(gcbo);
if handles.w.drtaThresholdSnips~=0
    hObject=handles.w.drtaThresholdSnips;
    handles=guidata(hObject);
    handles.p=newhandles.p;
    handles.w=newhandles.w;
    handles.draq_p=newhandles.draq_p;
    % Update the handles structure
    guidata(hObject, handles);
    drtaThresholdSnips('drtaThSnSetTrials',hObject,handles);
    %drtaThresholdSnips('drtaThresholdAndPlot',hObject,handles);
end



% --- Executes on button press in drtaBrowseDraPush.
function drtaBrowseDraPush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


h=drtaBrowseTraces;
handles.w.drtaBrowseTraces=h;
% Update handles structure
guidata(hObject, handles);
% Update handles structure here and elsewhere
drtaUpdateAllHandlespw(hObject, handles);
drtaBrowseTraces('updateHandles',h,eventdata,handles);
drtaBrowseTraces('updateBrowseTraces',h);

% --- Executes on button press in drtaBrowseDraPush.
function trialNo=getTrialNo(hObject)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
trialNo=handles.p.trialNo;



function actualTrialNo=setTrialNo(hObject,trialNo)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(hObject);

sztrials=size(handles.draq_d.t_trial);
actualTrialNo=trialNo;
if (trialNo<1)
    actualTrialNo=1;
    handles.p.trialNo=1;
end

if (trialNo>sztrials(2))
    actualTrialNo=sztrials(2);
    handles.p.trialNo=sztrials(2);
end

if (trialNo>=1)&&(trialNo<=sztrials(2))
    actualTrialNo=trialNo;
    handles.p.trialNo=trialNo;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in drtaThresholdPush.
function drtaThresholdPush_Callback(hObject, eventdata, handles)
% hObject    handle to drtaThresholdPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=drtaThresholdSnips;
handles.w.drtaThresholdSnips=h;
%handles.p.trialNo=1;
% Update handles structure here and elsewhere
drtaUpdateAllHandlespw(hObject,handles);
drtaThresholdSnips('updateHandles',h,eventdata,handles);






% --- Executes on button press in drtaOpenDG.
function drtaOpenDG_Callback(hObject, eventdata, handles)
% hObject    handle to drtaOpenDG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


FileName=handles.p.FileName;
set(handles.drtaWhichFile,'String',FileName);
load([handles.p.fullName(1:end-2),'mat']);
try
    handles.draq_p=params;
    handles.draq_d=data;
catch
    handles.draq_p=draq_p;
    handles.draq_d=draq_d;
end


handles.draq_p.dgordra=2;
% sz_t_trial=size(draq_d.t_trial);
% sz_samp=size(draq_d.samplesPerTrial);
% if (sz_t_trial(2)<data.noTrials)||(sz_samp(2)<data.noTrials)
%    handles.draq_d.noTrials=min([sz_t_trial(2) sz_samp(2)]); 
% end
%handles.p.fid=fopen(handles.p.fullName,'r');

scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;

handles.draq_p.no_spike_ch=16;
handles.draq_p.daq_gain=8;
handles.draq_p.prev_ylim(1:17)=4000;
handles.draq_p.no_chans=22;
handles.draq_p.acquire_display_start=0;
handles.draq_p.inp_max=10;
% handles.p.trialNo=2;
% handles.p.low_filter=1000;
% handles.p.high_filter=5000;
% handles.p.whichPlot=1;
% handles.p.lastTrace=-1;
% handles.p.exclude_secs=2;
% handles.p.set2p5SD=0;
% handles.p.setm2p5SD=0;
% handles.p.setnxSD=0;
% handles.p.nxSD=2.5;
% handles.p.showLicks=1;
% handles.p.exc_sn=0;
% handles.p.read_entire_file=0;
% handles.p.setThr=0;
% handles.p.thrToSet=0;



if exist('drta_p')==1
    if isfield(drta_p,'doSubtract')
        handles.p.doSubtract=drta_p.doSubtract;
        handles.p.subtractCh=drta_p.subtractCh;
    else
        handles.p.doSubtract=0;
        handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
    end
else
    handles.p.doSubtract=0;
    handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
end

for (ii=1:handles.draq_p.no_spike_ch)
    try
        v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
    catch
        v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
        v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
        handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
    end

end

handles.p.trial_ch_processed=ones(16,handles.draq_d.noTrials);
handles.p.trial_allch_processed=ones(1,handles.draq_d.noTrials);

if (exist('drta_p')~=0)
    handles.p.threshold=drta_p.threshold;

    if (isfield(drta_p,'ch_processed')~=0)
        handles.p.ch_processed=drta_p.ch_processed;
    end
    if (isfield(drta_p,'trial_ch_processed')~=0)
        handles.p.trial_ch_processed=drta_p.trial_ch_processed;
    end
    if (isfield(drta_p,'trial_allch_processed')~=0)
        handles.p.trial_allch_processed=drta_p.trial_allch_processed;
    end
    if (isfield(drta_p,'upper_limit')~=0)
        handles.p.upper_limit=drta_p.upper_limit;
        handles.p.lower_limit=drta_p.lower_limit;
    end
    if isfield(drta_p,'exc_sn')
        handles.p.exc_sn=drta_p.exc_sn;
%         handles.p.exc_sn_thr=drta_p.exc_sn_thr;
%         handles.p.exc_sn_ch=drta_p.exc_sn_ch;
    end
    
end

handles.p.trialNo=1;

%Read recordings
if handles.p.read_entire_file==1
    handles.draq_d.data=drtaReadData(handles);
end

%Find the threshold for the licks
handles.p.lick_th_frac=0.3;
one_per=zeros(1,length(handles.draq_d.t_trial));
ninetynine_per=zeros(1,length(handles.draq_d.t_trial));
ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
    *handles.draq_p.ActualRate+1);
ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
    +handles.p.display_interval)*handles.draq_p.ActualRate)-2000;
ii=19; %These are licks

old_trial=handles.p.trialNo;
for trialNo=1:length(handles.draq_d.t_trial)-1
    handles.p.trialNo=trialNo;
    
    data_this_trial=drtaGetTraceData(handles);

    this_data=[];
    this_data=data_this_trial(:,ii);
    one_per(trialNo)=prctile(this_data(ii_from:ii_to),0.5);
    ninetynine_per(trialNo)=prctile(this_data(ii_from:ii_to),99.5);
end
handles.p.trialNo=old_trial;
handles.p.exc_sn_thr=handles.p.lick_th_frac*mean(ninetynine_per-one_per);

handles.p.lfp.maxLFP=4100;
handles.p.lfp.minLFP=10;

% Update handles structure
guidata(hObject, handles);


%Open threshold window
h=drtaThresholdSnips;
handles.w.drtaThresholdSnips=h;
drtaUpdateAllHandlespw(hObject,handles);
drtaThresholdSnips('updateHandles',h,eventdata,handles);

%Open browse traces
h=drtaBrowseTraces;
handles.w.drtaBrowseTraces=h;
% Update handles structure
guidata(hObject, handles);
% Update handles structure here and elsewhere
drtaUpdateAllHandlespw(hObject, handles);
drtaBrowseTraces('updateHandles',h,eventdata,handles);
drtaBrowseTraces('updateBrowseTraces',h);










% --- Executes on button press in open_rhd.
function open_rhd_Callback(hObject, eventdata, handles)
% hObject    handle to open_rhd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FileName=handles.p.FileName;
set(handles.drtaWhichFile,'String',FileName);

if exist([handles.p.fullName(1:end-3),'mat'],'file')==2
    load([handles.p.fullName(1:end-3),'mat']);
    try
        handles.draq_p=params;
        handles.draq_d=data;
    catch
        handles.draq_p=draq_p;
        handles.draq_d=draq_d;
    end
else
    %Setup the matlab header file
    [handles.draq_p,handles.draq_d]=drta_read_Intan_RHD2000_header(handles.p.fullName,handles.p.which_protocol,handles);
end


handles.draq_p.dgordra=3;  


scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;

handles.draq_p.no_spike_ch=16;
handles.draq_p.daq_gain=1;
handles.draq_p.prev_ylim(1:17)=4000;
handles.draq_p.no_chans=22;
handles.draq_p.acquire_display_start=0;
handles.draq_p.inp_max=10;
% handles.p.trialNo=2;
% handles.p.low_filter=1000;
% handles.p.high_filter=5000;
% handles.p.whichPlot=1;
% handles.p.lastTrace=-1;
% handles.p.exclude_secs=2;
% handles.p.set2p5SD=0;
% handles.p.setm2p5SD=0;
% handles.p.setnxSD=0;
% handles.p.nxSD=2.5;
% handles.p.showLicks=1;
% handles.p.exc_sn=0;
% handles.p.read_entire_file=0;
% handles.p.setThr=0;
% handles.p.thrToSet=0;
% handles.p.which_protocol=1;



if exist('drta_p')==1
    if isfield(drta_p,'doSubtract')
        handles.p.doSubtract=drta_p.doSubtract;
        handles.p.subtractCh=drta_p.subtractCh;
    else
        handles.p.doSubtract=0;
        handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
    end
else
    handles.p.doSubtract=0;
    handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
end

for (ii=1:handles.draq_p.no_spike_ch)
    try
        v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
    catch
        v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
        v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
        handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
    end

end

handles.p.trial_ch_processed=ones(16,handles.draq_d.noTrials);
handles.p.trial_allch_processed=ones(1,handles.draq_d.noTrials);

if (exist('drta_p')~=0)
    handles.p.threshold=drta_p.threshold;

    if (isfield(drta_p,'ch_processed')~=0)
        handles.p.ch_processed=drta_p.ch_processed;
    end
    if (isfield(drta_p,'trial_ch_processed')~=0)
        handles.p.trial_ch_processed=drta_p.trial_ch_processed;
    end
    if (isfield(drta_p,'trial_allch_processed')~=0)
        handles.p.trial_allch_processed=drta_p.trial_allch_processed;
    end
    if (isfield(drta_p,'upper_limit')~=0)
        handles.p.upper_limit=drta_p.upper_limit;
        handles.p.lower_limit=drta_p.lower_limit;
    end
    if isfield(drta_p,'exc_sn')
        handles.p.exc_sn=drta_p.exc_sn;
%         handles.p.exc_sn_thr=drta_p.exc_sn_thr;
%         handles.p.exc_sn_ch=drta_p.exc_sn_ch;
    end
    
end

handles.p.trialNo=1;


%Find the threshold for the licks
handles.p.lick_th_frac=0.3;
one_per=zeros(1,length(handles.draq_d.t_trial));
ninetynine_per=zeros(1,length(handles.draq_d.t_trial));
ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
    *handles.draq_p.ActualRate+1);
ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
    +handles.p.display_interval)*handles.draq_p.ActualRate)-2000;
ii=19; %These are licsk

old_trial=handles.p.trialNo;

%Find out if the last trial can be read
handles.p.trialNo=length(handles.draq_d.t_trial);
try 
    data_this_trial=drtaGetTraceDataRHD(handles);
catch
    handles.draq_d.t_trial=handles.draq_d.t_trial(1:end-1);
    handles.draq_d.noTrials=handles.draq_d.noTrials-1;
end

for trialNo=1:length(handles.draq_d.t_trial)
    handles.p.trialNo=trialNo;
    
    %         data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
    %             floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
    %
    data_this_trial=drtaGetTraceDataRHD(handles);
    
    
    this_data=[];
    this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
    one_per(trialNo)=prctile(this_data(ii_from:ii_to),1);
    ninetynine_per(trialNo)=prctile(this_data(ii_from:ii_to),99);
    
end
handles.p.trialNo=old_trial;
handles.p.exc_sn_thr=handles.p.lick_th_frac*mean(ninetynine_per-one_per);
handles.p.lfp.maxLFP=9900;
handles.p.lfp.minLFP=-9900;
handles.trial_duration=9;
handles.pre_dt=6;

% Update handles structure
guidata(hObject, handles);


%Open threshold window
h=drtaThresholdSnips;
handles.w.drtaThresholdSnips=h;
drtaUpdateAllHandlespw(hObject,handles);
drtaThresholdSnips('updateHandles',h,eventdata,handles);

%Open browse traces
h=drtaBrowseTraces;
handles.w.drtaBrowseTraces=h;
% Update handles structure
guidata(hObject, handles);
% Update handles structure here and elsewhere
drtaUpdateAllHandlespw(hObject, handles);
drtaBrowseTraces('updateHandles',h,eventdata,handles);
drtaBrowseTraces('updateBrowseTraces',h);


% --- Executes on selection change in whichProtocol.
function whichProtocol_Callback(hObject, eventdata, handles)
% hObject    handle to whichProtocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns whichProtocol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from whichProtocol
handles.p.which_protocol=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function whichProtocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whichProtocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openFile.
function openFile_Callback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.rhd';'*.dg'},'Select rhd or dg file to open');
handles.p.fullName=[PathName,FileName];
handles.p.FileName=FileName;
handles.p.PathName=PathName;
% Update handles structure
guidata(hObject, handles);


if strcmp(FileName(end-2:end),'rhd')
    open_rhd_Callback(hObject, eventdata, handles);
end

if strcmp(FileName(end-2:end),'.dg')
    drtaOpenDG_Callback(hObject, eventdata, handles);
end



function drtaSetTrialDuration_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSetTrialDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaSetTrialDuration as text
%        str2double(get(hObject,'String')) returns contents of drtaSetTrialDuration as a double
handles.trial_duration= str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function drtaSetTrialDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaSetTrialDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drtaPreTime_Callback(hObject, eventdata, handles)
% hObject    handle to drtaPreTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaPreTime as text
%        str2double(get(hObject,'String')) returns contents of drtaPreTime as a double
handles.pre_dt= str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function drtaPreTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drtaPreTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
