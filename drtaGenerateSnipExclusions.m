function handles = drtaGenerateSnipExclusions(handles)
% This function generates times for exclussion of snipes based on date
% entered by the user. The purpose of this function is to exclude snipes
% that are found in all channels (electical artifact)

if (handles.p.exc_sn==1)
    %This is for the old dra data
    
    handles.p.which_display=handles.p.exc_sn_ch;
    handles.draq_d.exc_timestamp=[];
    handles.draq_d.index=[];
    w_pre=12;
    w_post=12;
    ref=w_post;
    
    if (handles.draq_p.dgordra==1)
        
        for trialNo=1:handles.draq_d.noTrials
            
            
            trialNo
            tic
            drta('setTrialNo',handles.w.drta,trialNo);
            
            %Note: The code that follows is taken directly from
            %get_draq_data_all_trials and is exactly the code that is used by
            %Do_waveclus
            %handles.p.fid=fopen(handles.p.fullName,'r');
            
            scaling = handles.draq_p.scaling;
            offset = handles.draq_p.offset;
            
            %Read the data
            offset_bytes=handles.draq_p.no_spike_ch*2*(sum(handles.draq_d.samplesPerTrial(1:trialNo))-handles.draq_d.samplesPerTrial(trialNo));
            fseek(handles.p.fid,offset_bytes,'bof');
            data_vec=fread(handles.p.fid,handles.draq_p.no_spike_ch*handles.draq_d.samplesPerTrial(trialNo),'uint16');
            szdv=size(data_vec);
            data=reshape(data_vec,szdv(1)/handles.draq_p.no_spike_ch,handles.draq_p.no_spike_ch);
            
            %Extract channel and convert to mV
            ii=handles.p.which_display;
            data_1=data( floor(handles.draq_p.acquire_display_start*handles.draq_p.ActualRate+1):...
                floor(handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate),ii);
            if length(handles.draq_p.pre_gain)==1
                data=1000*(scaling*double( data_1 )+offset)/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
            else
                data=1000*(scaling*double( data_1 )+offset)/(handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain);
            end
            x=data';
            
            %fclose(handles.p.fid);
            
            %And these lines are directly from dr_amp_detect_wc.m
            % FILTER OF THE DATA
            
            switch (handles.p.do_filter)
                case (1)
                    a=1;
                    b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);
                    xf = x-filtfilt(b,a,x);
                    xf_detect=xf;
                case (2)
                    xf=zeros(length(x),1);
                    [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
                    xf_detect=filtfilt(b,a,x);
                    [b,a]=ellip(2,0.1,40,[fmin_sort fmax_sort]*2/sr);
                    xf=filtfilt(b,a,x);
                    lx=length(xf);
                case (3)
                    xf=x-mean(x);
                    xf_detect=xf;
            end
            
            %Now setup thresholds
            % noise_std_detect = median(abs(xf_detect))/0.6745;
            % noise_std_sorted = median(abs(xf))/0.6745;
            % thr = stdmin * noise_std_detect;        %thr for detection is based on detect settings.
            % thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.
            
            
            
            thrmax=handles.p.upper_limit(handles.p.which_display)/1000;
            
            %set(handles.file_name,'string','Detecting spikes ...');
            
            if (handles.p.exc_sn_thr>0)
                detect='pos';
                thr=handles.p.exc_sn_thr/1000;
            else
                detect='neg';
                thr=-handles.p.exc_sn_thr/1000;
            end
            
            aux_index=[];
            
            % LOCATE SPIKE TIMES
            switch detect
                case 'pos'
                    nspk = 0;
                    xaux = find(xf_detect(w_pre+2:end-w_post-2) > thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=max((xf(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
                case 'neg'
                    nspk = 0;
                    xaux = find(xf_detect(w_pre+2:end-w_post-2) < -thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=min((xf(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
                case 'both'
                    nspk = 0;
                    xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=max(abs(xf(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
            end
            handles.draq_d.index_from(trialNo)=length(handles.draq_d.index)+1;
            handles.draq_d.index=[handles.draq_d.index aux_index];
            handles.draq_d.index_to(trialNo)=length(handles.draq_d.index);
            shift=handles.draq_d.t_trial(trialNo)*handles.draq_p.ActualRate;
            handles.draq_d.exc_timestamp=[handles.draq_d.exc_timestamp (shift+aux_index)/handles.draq_p.ActualRate];
            toc
        end
        
    else
        %This is for the new dg data
        %NEEDS TO BE TESTED!!!
        for trialNo=1:handles.draq_d.noTrials
            
            
            trialNo
            tic
            drta('setTrialNo',handles.w.drta,trialNo);
            
            %Note: The code that follows is taken directly from
            %get_draq_data_all_trials and is exactly the code that is used by
            %Do_waveclus
            handles.p.fid=fopen(handles.p.fullName,'r');
            %             scaling = handles.draq_p.scaling;
            %             offset = handles.draq_p.offset;
            
            %Read the data
            %             offset_bytes=handles.draq_p.no_spike_ch*2*(sum(handles.draq_d.samplesPerTrial(1:trialNo))-handles.draq_d.samplesPerTrial(trialNo));
            %             fseek(handles.p.fid,offset_bytes,'bof');
            %             data_vec=fread(handles.p.fid,handles.draq_p.no_spike_ch*handles.draq_d.samplesPerTrial(trialNo),'uint16');
            %             szdv=size(data_vec);
            %             data=reshape(data_vec,szdv(1)/handles.draq_p.no_spike_ch,handles.draq_p.no_spike_ch);
            
            
            bytes_per_native=2;     %Note: Native is unit16
            size_per_ch_bytes=handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate*bytes_per_native;
            no_unit16_per_ch=size_per_ch_bytes/bytes_per_native;
            trial_offset=handles.draq_p.no_chans*size_per_ch_bytes*(trialNo-1);
            for ii=1:handles.draq_p.no_chans
                fseek(handles.p.fid, (ii-1)*size_per_ch_bytes+trial_offset, 'bof');
                data(:,ii)=fread(handles.p.fid,no_unit16_per_ch,'uint16');
            end
            

            
            switch (handles.p.do_filter)
                case (1)
                    %Filter between 1 and 100
                    [b,a] = butter(2,[10./(handles.draq_p.ActualRate/2) 100./(handles.draq_p.ActualRate/2)]);
                    data1 =filtfilt(b,a,data);
                case (2)
                    %Filter between 300 and 5000
                    [b,a] = butter(2,[handles.p.low_filter/(handles.draq_p.ActualRate/2) handles.p.high_filter/(handles.draq_p.ActualRate/2)]);
                    data1 =filtfilt(b,a,data);
                case (3)
                    data1 = data;
            end
            
            %Extract channel and convert to mV
            ii=handles.p.which_display;
            xf_detect=data1(floor(handles.draq_p.acquire_display_start*handles.draq_p.ActualRate+1):...
                floor(handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate),ii);
            %             if length(handles.draq_p.pre_gain)==1
            %                 data=1000*(scaling*double( data_1 )+offset)/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
            %             else
            %                 data=1000*(scaling*double( data_1 )+offset)/(handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain);
            %             end
            xf_detect=xf_detect';
            
            fclose(handles.p.fid);
            
            %And these lines are directly from dr_amp_detect_wc.m
            % FILTER OF THE DATA
            
            %             switch (handles.p.do_filter)
            %                 case (1)
            %                     a=1;
            %                     b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);
            %                     xf = x-filtfilt(b,a,x);
            %                     xf_detect=xf;
            %                 case (2)
            %                     xf=zeros(length(x),1);
            %                     [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
            %                     xf_detect=filtfilt(b,a,x);
            %                     [b,a]=ellip(2,0.1,40,[fmin_sort fmax_sort]*2/sr);
            %                     xf=filtfilt(b,a,x);
            %                     lx=length(xf);
            %                 case (3)
            %                     xf=x-mean(x);
            %                     xf_detect=xf;
            %             end
            
            
            %Now setup thresholds
            % noise_std_detect = median(abs(xf_detect))/0.6745;
            % noise_std_sorted = median(abs(xf))/0.6745;
            % thr = stdmin * noise_std_detect;        %thr for detection is based on detect settings.
            % thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.
            
            
            
            thrmax=handles.p.upper_limit(handles.p.which_display)/1000;
            
            %set(handles.file_name,'string','Detecting spikes ...');
            
            if (handles.p.exc_sn_thr>0)
                detect='pos';
                thr=handles.p.exc_sn_thr/1000;
            else
                detect='neg';
                thr=-handles.p.exc_sn_thr/1000;
            end
            
            aux_index=[];
            
            % LOCATE SPIKE TIMES
            switch detect
                case 'pos'
                    nspk = 0;
                    xaux = find(xf_detect(w_pre+2:end-w_post-2) > thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=max((xf_detect(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
                case 'neg'
                    nspk = 0;
                    xaux = find(xf_detect(w_pre+2:end-w_post-2) < -thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=min((xf_detect(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
                case 'both'
                    nspk = 0;
                    xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
                    xaux0 = 0;
                    for ii=1:length(xaux)
                        if xaux(ii) >= xaux0 + ref
                            [maxi iaux]=max(abs(xf_detect(xaux(ii):xaux(ii)+floor(ref/2)-1)));    %introduces alignment
                            nspk = nspk + 1;
                            aux_index(nspk) = iaux + xaux(ii) -1;
                            xaux0 = aux_index(nspk);
                        end
                    end
            end
            handles.draq_d.index_from(trialNo)=length(handles.draq_d.index)+1;
            handles.draq_d.index=[handles.draq_d.index aux_index];
            handles.draq_d.index_to(trialNo)=length(handles.draq_d.index);
            shift=handles.draq_d.t_trial(trialNo)*handles.draq_p.ActualRate;
            handles.draq_d.exc_timestamp=[handles.draq_d.exc_timestamp (shift+aux_index)/handles.draq_p.ActualRate];
            toc
        end
    end
    
    
end


