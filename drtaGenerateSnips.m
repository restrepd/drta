function drtaGenerateSnips(hObject, handles)
% Generates snips in current display selection

% hObject    handle to drtaThresholdPush (see GCBO)
% handles    structure with handles and user data (see GUIDATA)


tic

if handles.draq_p.dgordra==1
    
    %This is dra
    noch=handles.draq_p.no_spike_ch-1;
    scaling = handles.draq_p.scaling;
    offset = handles.draq_p.offset;
    samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
    samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
    handles.draq_d.snip_samp=zeros(1,noch);
    handles.draq_d.snip_index=zeros(noch,1,samp_bef+samp_aft);
    handles.draq_d.snips=zeros(noch,1,samp_bef+samp_aft);
    
    %Get the data
    data = drta('getTraceData',handles.w.drta);
    
    %b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);
    
    
    for ii=1:noch
        if handles.p.ch_processed(ii)==1
            if length(handles.draq_p.pre_gain)==1
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                nat_thr=(v_thr-offset)/scaling;
                v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                nat_upper=(v_upper-offset)/scaling;
                v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                nat_lower=(v_lower-offset)/scaling;
            else
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                nat_thr=(v_thr-offset)/scaling;
                v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                nat_upper=(v_upper-offset)/scaling;
                v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                nat_lower=(v_lower-offset)/scaling;
            end
            
            if (handles.p.do_filter==1)
                
                data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                    *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                    +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
                data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                    floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)...
                    *handles.draq_p.ActualRate),ii);
                datavec=(data_1-data_0)-(offset/scaling);
            else
                datavec=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*...
                    handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                    +handles.p.display_interval)*handles.draq_p.ActualRate),ii);
            end
            szdata=size(datavec);
            
            %Find threshold crossings
            
            if handles.p.threshold(ii)>0
                cross_thresh=find(datavec>nat_thr);
            else
                cross_thresh=find(datavec<nat_thr);
            end
            
            if ~isempty(cross_thresh)
                %Found threshold crossings
                szcross=size(cross_thresh);
                jj=1;
                while jj<=szcross(1)
                    if (cross_thresh(jj)-samp_bef)>0
                        if (cross_thresh(jj)+samp_aft)<szdata(1)
                            handles.draq_d.snip_samp(ii) = handles.draq_d.snip_samp(ii) +1;
                            handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)=datavec(cross_thresh(jj)-samp_bef+1:cross_thresh(jj)+samp_aft);
                            handles.draq_d.snip_index(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)=cross_thresh(jj)-samp_bef+1:cross_thresh(jj)+samp_aft;
                            %above_upper=[];
                            %below_lower=[];
                            %above_upper=find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)>nat_upper);
                            %below_lower=find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)<nat_lower);
                            if ((~isempty(find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)>nat_upper,1)))...
                                    ||(~isempty(find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)<nat_lower,1))))
                                handles.draq_d.snip_samp(ii) = handles.draq_d.snip_samp(ii) -1;
                            end
                        end
                    end
                    last_cross=cross_thresh(jj);
                    jj=jj+1;
                    while (jj<=szcross(1))&&(cross_thresh(jj)<last_cross+samp_aft)
                        jj=jj+1;
                    end
                end
            end
        else
            handles.draq_d.snip_samp(ii) = 0;
        end
        
    end
    
else
    %This is dg
    noch=handles.draq_p.no_spike_ch;
    
    %     scaling = handles.draq_p.scaling;
    %     offset = handles.draq_p.offset;
    samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
    samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
    handles.draq_d.snip_samp=zeros(1,noch);
    handles.draq_d.snip_index=zeros(noch,1,samp_bef+samp_aft);
    handles.draq_d.snips=zeros(noch,1,samp_bef+samp_aft);
    
    %Get the data
    data = drta('getTraceData',handles.w.drta);
    
    trialNo=handles.p.trialNo;
    data_this_trial=[];
    data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
        floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
    data=zeros(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger),handles.draq_p.no_chans);
    for ii=1:handles.draq_p.no_chans
        data(1:end-2000,ii)=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)+1:...
            floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)...
            +floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)-2000);
    end
    
    
    fpass=[1000 5000];
    
    bpFilt = designfilt('bandpassiir','FilterOrder',20, ...
        'HalfPowerFrequency1',fpass(1),'HalfPowerFrequency2',fpass(2), ...
        'SampleRate',floor(handles.draq_p.ActualRate));
    
    data1=filtfilt(bpFilt,data);
    
    %     switch (handles.p.do_filter)
    %         case (1)
    %             %Filter between 10 and 100
    %             [b,a] = butter(2,[10./(handles.draq_p.ActualRate/2) 100./(handles.draq_p.ActualRate/2)]);
    %             data1 =filtfilt(b,a,data);
    %         case (2)
    %             %Filter between 300 and 5000
    %             [b,a] = butter(2,[handles.p.low_filter/(handles.draq_p.ActualRate/2) handles.p.high_filter/(handles.draq_p.ActualRate/2)]);
    %             data1 =filtfilt(b,a,data);
    %         case (3)
    %             data1 = data;
    %     end
    
    if (handles.p.doSubtract==1)
        data2=data1;
        for tetr=1:4
            for jj=1:4
                if handles.p.subtractCh(4*(tetr-1)+jj)<=18
                    if handles.p.subtractCh(4*(tetr-1)+jj)<=16
                        %Subtract one of the channels
                        data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-data2(:,handles.p.subtractCh((tetr-1)*4+jj));
                    else
                        if handles.p.subtractCh(4*(tetr-1)+jj)==17
                            %Subtract tetrode mean
                            data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2(:,(tetr-1)*4+1:(tetr-1)*4+4),2);
                        else
                            %Subtract average of all electrodes
                            data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2,2);
                        end
                    end
                end
            end
        end
    end
    
    for ii=1:noch
        if handles.p.ch_processed(ii)==1
            %             if length(handles.draq_p.pre_gain)==1
            %                 v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            %                 nat_thr=(v_thr-offset)/scaling;
            %                 v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            %                 nat_upper=(v_upper-offset)/scaling;
            %                 v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            %                 nat_lower=(v_lower-offset)/scaling;
            %             else
            %                 v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
            %                 nat_thr=(v_thr-offset)/scaling;
            %                 v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
            %                 nat_upper=(v_upper-offset)/scaling;
            %                 v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
            %                 nat_lower=(v_lower-offset)/scaling;
            %             end
            %
            %             if (handles.p.do_filter==1)
            %                 data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            %                     *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            %                     +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
            %                 data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
            %                     floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)...
            %                     *handles.draq_p.ActualRate),ii);
            %                 datavec=(data_1-data_0)-(offset/scaling);
            %             else
            %                 datavec=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*...
            %                     handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            %                     +handles.p.display_interval)*handles.draq_p.ActualRate),ii);
            %             end
            %             szdata=size(datavec);
            
            %Find threshold crossings
            
            datavec=data1(:,ii);
            if handles.p.threshold(ii)>0
                cross_thresh=find(datavec>handles.p.threshold(ii));
            else
                cross_thresh=find(datavec<handles.p.threshold(ii));
            end
            
            szdata=length(datavec);
            %             if handles.p.threshold(ii)>0
            %                 cross_thresh=find(datavec>nat_thr);
            %             else
            %                 cross_thresh=find(datavec<nat_thr);
            %             end
            
            if ~isempty(cross_thresh)
                %Found threshold crossings
                szcross=size(cross_thresh);
                jj=1;
                while jj<=szcross(1)
                    if (cross_thresh(jj)-samp_bef)>0
                        if ((cross_thresh(jj)+samp_aft)<szdata)
                            handles.draq_d.snip_samp(ii) = handles.draq_d.snip_samp(ii) +1;
                            handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)=datavec(cross_thresh(jj)-samp_bef+1:cross_thresh(jj)+samp_aft);
                            handles.draq_d.snip_index(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)=cross_thresh(jj)-samp_bef+1:cross_thresh(jj)+samp_aft;
                            %above_upper=[];
                            %below_lower=[];
                            %above_upper=find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)>nat_upper);
                            %below_lower=find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)<nat_lower);
                            if ((~isempty(find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)>handles.draq_p.prev_ylim(ii),1)))...
                                    ||(~isempty(find(handles.draq_d.snips(ii,handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft)<-handles.draq_p.prev_ylim(ii),1))))
                                handles.draq_d.snip_samp(ii) = handles.draq_d.snip_samp(ii) -1;
                            end
                        end
                    end
                    last_cross=cross_thresh(jj);
                    jj=jj+1;
                    while (jj<=szcross(1))&&(cross_thresh(jj)<last_cross+samp_aft)
                        jj=jj+1;
                    end
                end
            end
        else
            handles.draq_d.snip_samp(ii) = 0;
        end
        
    end
end

toc

% Update handles structure
guidata(hObject, handles);
