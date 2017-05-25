function drtaGenerateSpikesAndSavePlx(handles)

%Saves snips to plexon file

tic

plxfname=[handles.p.fullName,'.plx'];
plxfid=fopen(plxfname,'w');

%Write file header
header=int32(zeros(1,48));
header(1)=hex2dec('58454C50'); %Magic number
header(2)=105;
header(35)=handles.draq_p.ActualRate;
header(36)=handles.draq_p.no_spike_ch-1;
header(37)=0; %No of event types
header(38)=0; %No of slow channels
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
header(39)=samp_bef+samp_aft;
header(40)=samp_bef;
dvec=datevec(date); %Yesr
header(41)=dvec(1); %Month
header(42)=dvec(2); %Date
%Time was left as 0:0:0
header(43)=dvec(3);
header(48)=handles.draq_p.ActualRate;
fwrite(plxfid, header, 'int32');
szt_tr=size(handles.draq_d.t_trial);
fwrite(plxfid, handles.draq_p.ActualRate*(handles.draq_d.t_trial(szt_tr(2))+handles.draq_p.sec_per_trigger), 'double');

%Only valid if version >=103
fwrite(plxfid, 1, 'char'); %Trodalness
fwrite(plxfid, 1, 'char'); %DataTrodalness
fwrite(plxfid,12, 'char'); %BitsPerSpikeSample
fwrite(plxfid,12, 'char'); %BitsPerSlowSample
maxMagnitudemV=1000*handles.draq_p.InputRange(2)/handles.draq_p.daq_gain;
fwrite(plxfid,maxMagnitudemV, 'uint16'); %Zero to peak for spikes in mV
fwrite(plxfid,maxMagnitudemV, 'uint16'); %Zero to peak for slow in mV

% Only valid if version >=105
fwrite(plxfid,handles.draq_p.pre_gain, 'uint16'); %Spike preamp gain
padding=char(zeros(1,46));
fwrite(plxfid,padding,'char');

%Counters for the number of timestamps and waveforms
TScounts=int32(zeros(130,5));
%TScounts(2:handles.draq_p.no_spike_ch,2)=handles.draq_d.snip_samp(1:handles.draq_p.no_spike_ch-1);
fwrite(plxfid,TScounts','int32'); %Timestamps
fwrite(plxfid,TScounts','int32'); %Waveforms
EVcounts=int32(zeros(1,512));
fwrite(plxfid,EVcounts,'int32'); %Events


%Now write spike channel headers
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;

for ch_num=1:handles.draq_p.no_spike_ch-1
      name=char(num2str(ch_num));
      fwrite(plxfid,name,'char'); %Name
      szname=size(name);
      name_post=char(zeros(1,32-szname(2)));
      fwrite(plxfid,name_post,'char'); %Fill out rest of name field
      name=char(num2str(ch_num));
      fwrite(plxfid,name,'char'); %SIG name
      szname=size(name);
      name_post=char(zeros(1,32-szname(2)));
      fwrite(plxfid,name_post,'char'); %Fill out rest of SIG name field
      fwrite(plxfid,ch_num,'int32'); %Channel number
      fwrite(plxfid,100,'int32'); %limit w/f per sec divided by 10
      fwrite(plxfid,ch_num,'int32'); %SIG channel number
      fwrite(plxfid,1,'int32'); %Ref channel
      fwrite(plxfid,handles.draq_p.daq_gain,'int32'); %Gain
      fwrite(plxfid,handles.p.do_filter,'int32'); %Filter
      v_thr=(handles.p.threshold(ch_num)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
      nat_thr=(v_thr-offset)/scaling;  
      fwrite(plxfid,nat_thr,'int32'); %Threshold
      fwrite(plxfid,1,'int32'); %Sorting method
      fwrite(plxfid,0,'int32'); %Number of sorted units
      spike_temp=int16(zeros(5,64));
      fwrite(plxfid,spike_temp,'int16'); %Templates for sorting
      temp_fit=int32(zeros(1,5));
      fwrite(plxfid,temp_fit,'int32'); %Template fit
      fwrite(plxfid,1,'int32'); %Points to use in template sorting
      boxes=int16(zeros(5,2,4));
      fwrite(plxfid,boxes,'int16'); %Templates for sorting
      fwrite(plxfid,1,'int32'); %Sort beg
      comment=char(zeros(1,128));
      fwrite(plxfid,comment,'char'); %Comment
      padding=int32(zeros(1,11));
      fwrite(plxfid,padding,'int32'); %Padding
end

%Event headers
% comment=char(zeros(1,128));
% padding=int32(zeros(1,33));
% for nEvTy=1:handles.draq_d.nEventTypes
%     name=char(zeros(1,32));
%     name(:)=handles.draq_d.eventnames(nEvTy,:);
%     fwrite(plxfid,name,'char'); %Name
%     fwrite(plxfid,nEvTy,'int32'); %Event channel (event type)
%     fwrite(plxfid,comment,'char'); %Comment
%     fwrite(plxfid,padding,'int32'); %Padding
% end

%None for the moment

%Continuous channel header

%None for the moment


%Now generate and save spikes
noch=handles.draq_p.no_spike_ch-1;
%sztrials=size(handles.draq_d.t_trial);
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
handles.draq_d.snip_samp=zeros(1,noch);
oldTrialNo=handles.p.trialNo;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
snip=zeros(1,samp_bef+samp_aft);
snip_samp=zeros(1,noch);
handles.draq_d.snip_index=zeros(noch,1,samp_bef+samp_aft);              
handles.draq_d.snips=zeros(noch,1,samp_bef+samp_aft);

b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);

for trialNo=1:handles.draq_d.noTrials
    drta('setTrialNo',handles.w.drta,trialNo);
    data = drta('getTraceData',handles.w.drta);
    trialNo
    tic
    for ii=1:noch
        if handles.p.ch_processed(ii)==1
            v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_thr=(v_thr-offset)/scaling;   
            v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_upper=(v_upper-offset)/scaling;
            v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_lower=(v_lower-offset)/scaling;

            if (handles.p.do_filter==1)
                data_0 = filtfilt(b,1,data( floor(handles.draq_p.acquire_display_start...
                    *handles.draq_p.ActualRate+1):floor(handles.draq_p.sec_per_trigger...
                    *handles.draq_p.ActualRate),ii));
                data_1=data( floor(handles.draq_p.acquire_display_start*handles.draq_p.ActualRate+1):...
                    floor(handles.draq_p.sec_per_trigger...
                    *handles.draq_p.ActualRate),ii);
                datavec=(data_1-data_0)-(offset/scaling);
            else
                datavec=data( floor(handles.draq_p.acquire_display_start*...
                    handles.draq_p.ActualRate+1):floor(handles.draq_p.sec_per_trigger...
                    *handles.draq_p.ActualRate),ii);
            end
            szdata=size(datavec);

            if handles.p.threshold(ii)>0
                cross_thresh=find(datavec>nat_thr);
            else
                cross_thresh=find(datavec<nat_thr);
            end


            if ~isempty(cross_thresh)
               szcross=size(cross_thresh); 
               jj=1;
               while jj<=szcross(1)
                    if (cross_thresh(jj)-samp_bef)>0
                       if (cross_thresh(jj)+samp_aft)<szdata(1)
                         snip(1,:)=datavec(cross_thresh(jj)-samp_bef+1:cross_thresh(jj)+samp_aft); 
                         shift=handles.draq_d.t_trial(trialNo)*handles.draq_p.ActualRate;
                         snip_index=cross_thresh(jj)+shift;
                         
                         if ~((~isempty(find(snip>nat_upper,1)))||(~isempty(find(snip<nat_lower,1))))
                        
                               snip_samp(ii)=snip_samp(ii)+1;
                               %This is a valid snip. Save
                               %write waveform data block header
                               fwrite(plxfid,1,'int16'); %Data type 1=spike 4=event 5=continuous
                               fwrite(plxfid,0,'uint16'); %Upper bit of 40 bit time stamp
                               fwrite(plxfid,uint32(snip_index),'uint32'); %Time stamp
                               fwrite(plxfid,int16(ii),'int16'); %Channel number
                               fwrite(plxfid,0,'int16'); %Unit No 0=unsorted
                               fwrite(plxfid,1,'int16'); %Number of waveforms to follow
                               fwrite(plxfid,samp_bef+samp_aft,'int16'); %Number of samples per waveform

                               %write waveform
                               waveform=int16(zeros(1,samp_bef+samp_aft));
                               waveform(:)=int16(snip+(offset/scaling));
                               fwrite(plxfid,waveform,'int16'); %Waveform
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
    end %for ii=1:noch
    toc
end

fclose(plxfid);

drta('setTrialNo',handles.w.drta,oldTrialNo);
toc