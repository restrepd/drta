function drtaSetThreshold25(hObject, handles)
% hObject    handle to drtaThresholdPush (see GCBO)
% handles    structure with handles and user data (see GUIDATA)


tic
SD_factor=3;
noch=handles.draq_p.no_spike_ch-1;
sztrials=size(handles.draq_d.t_trial);
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
handles.draq_d.snip_samp=zeros(1,noch);
trialNo=handles.p.trialNo;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);

data = drta('getTraceData',handles.w.drta);

b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);



for ii=1:noch
  
%     v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
%     nat_thr=(v_thr-offset)/scaling;

        data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
        data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
            floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)...
            *handles.draq_p.ActualRate),ii);
        datavec=(data_1-data_0)-(offset/scaling);
        new_thr=SD_factor*std(datavec)+mean(datavec);
        v_thr=new_thr*scaling+offset;
        if length(handles.draq_p.pre_gain)==1
        handles.p.threshold(ii)=v_thr/(handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        else
           handles.p.threshold(ii)=v_thr/(handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000); 
        end
end



toc

% Update handles structure
guidata(hObject, handles);
