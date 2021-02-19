%drtaBatch does drta batch processing
%By default drtaBatch reads the header of rhd files and overwrites jt_times and .mat files

% Read the BatchParameters
[choicesFileName,choicesPathName] = uigetfile({'drtaBatchChoices*.m'},'Select the .m file with all the choices for drta');
fprintf(1, ['\ndrtaBatch run for ' choicesFileName '\n\n']);

addpath(choicesPathName)
eval(['handles_choices=' choicesFileName(1:end-2) ';'])
handles.choicesFileName=choicesFileName;
handles.choicesPathName=choicesPathName;

handles.drtachoices=handles_choices.drtachoices;
 
 
% Choose default command line output for drta
%load('C:\Awake Data\drta_preferences.mat');
prefs=drtaSetPreferences();
handles.p=prefs;
% handles.output = hObject;
%handles.p.trialNo=1;
% handles.w.drta=hObject;
% handles.w.drtaBrowseTraces=0;
% handles.w.drtaThresholdSnips=0;
% handles.p.threexsdexists(1:16)=0;
handles.p.which_c_program=handles_choices.drtachoices.which_c_program;
handles.time_before_FV=1;
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
handles.p.which_protocol=handles_choices.drtachoices.which_protocol;

handles.pre_dt=handles.drtachoices.pre_dt;
handles.trial_duration=handles.drtachoices.trial_duration;

%For the moment this only works with rhd files
for filNum=handles_choices.drtachoices.first_file:handles_choices.drtachoices.no_files
    
    if iscell(handles_choices.drtachoices.PathName)
        PathName=handles_choices.drtachoices.PathName{filNum};
    else
        PathName=handles_choices.drtachoices.PathName;
    end
    
    
    FileName=[PathName handles_choices.drtachoices.FileName{filNum}];
    handles.p.fullName=FileName;
    handles.p.PathName=PathName;
    handles.p.FileName=handles_choices.drtachoices.FileName{filNum};
    
    fprintf(1, ['Processing drta for file %d ' handles_choices.drtachoices.FileName{filNum} '\n'],filNum);
    
    
    if strcmp(FileName(end-2:end),'rhd')
        %         open_rhd_Callback
        
        %Setup the matlab header file
        [handles.draq_p,handles.draq_d]=drta_read_Intan_RHD2000_header(FileName,handles.p.which_protocol,handles);
        
        handles.draq_p.dgordra=3;
        
        scaling = handles.draq_p.scaling;
        offset = handles.draq_p.offset;
        
        handles.draq_p.no_spike_ch=16;
        handles.draq_p.daq_gain=1;
        handles.draq_p.prev_ylim(1:17)=4000;
        handles.draq_p.no_chans=22;
        handles.draq_p.acquire_display_start=0;
        handles.draq_p.inp_max=10;
        
        
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
        
%         if (exist('drta_p')~=0)
%             handles.p.threshold=drta_p.threshold;
%             
%             if (isfield(drta_p,'ch_processed')~=0)
%                 handles.p.ch_processed=drta_p.ch_processed;
%             end
%             if (isfield(drta_p,'trial_ch_processed')~=0)
%                 handles.p.trial_ch_processed=drta_p.trial_ch_processed;
%             end
%             if (isfield(drta_p,'trial_allch_processed')~=0)
%                 handles.p.trial_allch_processed=drta_p.trial_allch_processed;
%             end
%             if (isfield(drta_p,'upper_limit')~=0)
%                 handles.p.upper_limit=drta_p.upper_limit;
%                 handles.p.lower_limit=drta_p.lower_limit;
%             end
%             if isfield(drta_p,'exc_sn')
%                 handles.p.exc_sn=drta_p.exc_sn;
%                 %         handles.p.exc_sn_thr=drta_p.exc_sn_thr;
%                 %         handles.p.exc_sn_ch=drta_p.exc_sn_ch;
%             end
%             
%         end
        
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
%         handles.trial_duration=9;
%         handles.pre_dt=6;
    else
        %This is a dg file
        FileName=handles.p.FileName;
         
        load([handles.p.fullName(1:end-2),'mat']);
        try
            handles.draq_p=params;
            handles.draq_d=data;
        catch
            handles.draq_p=draq_p;
            handles.draq_d=draq_d;
        end
        
        
        handles.draq_p.dgordra=2;
        
        scaling = handles.draq_p.scaling;
        offset = handles.draq_p.offset;
        
        handles.draq_p.no_spike_ch=16;
        handles.draq_p.daq_gain=8;
        handles.draq_p.prev_ylim(1:17)=4000;
        handles.draq_p.no_chans=22;
        handles.draq_p.acquire_display_start=0;
        handles.draq_p.inp_max=10;

        
        
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
        
%         if (exist('drta_p')~=0)
%             handles.p.threshold=drta_p.threshold;
%             
%             if (isfield(drta_p,'ch_processed')~=0)
%                 handles.p.ch_processed=drta_p.ch_processed;
%             end
%             if (isfield(drta_p,'trial_ch_processed')~=0)
%                 handles.p.trial_ch_processed=drta_p.trial_ch_processed;
%             end
%             if (isfield(drta_p,'trial_allch_processed')~=0)
%                 handles.p.trial_allch_processed=drta_p.trial_allch_processed;
%             end
%             if (isfield(drta_p,'upper_limit')~=0)
%                 handles.p.upper_limit=drta_p.upper_limit;
%                 handles.p.lower_limit=drta_p.lower_limit;
%             end
%             if isfield(drta_p,'exc_sn')
%                 handles.p.exc_sn=drta_p.exc_sn;
%                 %         handles.p.exc_sn_thr=drta_p.exc_sn_thr;
%                 %         handles.p.exc_sn_ch=drta_p.exc_sn_ch;
%             end
%             
%         end
        
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
        
    end
    
    %Now do drtaGenerateEvents(handles)
    drtaGenerateEvents(handles)
    
end