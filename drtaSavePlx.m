function drtaSavePlx(handles)

%Saves snips to plexon file

tic

plxfname=[handles.p.fullName,'.plx'];
plxfid=fopen(plxfname,'w');

%Write file header
header=int32(zeros(1,48));
header(1)=hex2dec('58454C50');
header(2)=105;
header(35)=handles.draq_p.ActualRate;
header(36)=handles.draq_p.no_spike_ch-1;
header(37)=handles.draq_d.nEventTypes; %No of event types
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
TScounts(2:handles.draq_p.no_spike_ch,2)=handles.draq_d.snip_samp(1:handles.draq_p.no_spike_ch-1);
fwrite(plxfid,TScounts','int32'); %Timestamps
fwrite(plxfid,TScounts','int32'); %Waveforms
EVcounts=handles.draq_d.nEvPerType;
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
comment=char(zeros(1,128));
padding=int32(zeros(1,33));
for nEvTy=1:handles.draq_d.nEventTypes
    name=char(zeros(1,32));
    name(:)=handles.draq_d.eventnames(nEvTy,:);
    fwrite(plxfid,name,'char'); %Name
    fwrite(plxfid,nEvTy,'int32'); %Event channel (event type)
    fwrite(plxfid,comment,'char'); %Comment
    fwrite(plxfid,padding,'int32'); %Padding
end

%None for the moment

%Continuous channel header

%None for the moment

%Waveforms
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
for ch_num=1:handles.draq_p.no_spike_ch-1
     if handles.draq_d.snip_samp(ch_num)>0
       for (ii_snip=1:handles.draq_d.snip_samp(ch_num))
       
       %write waveform data block header
       fwrite(plxfid,1,'int16'); %Data type 1=spike 4=event 5=continuous
       fwrite(plxfid,0,'uint16'); %Upper bit of 40 bit time stamp
       fwrite(plxfid,handles.draq_d.snip_index(ch_num,ii_snip,samp_bef),'uint32'); %Time stamp
       fwrite(plxfid,ch_num,'int16'); %Channel number
       fwrite(plxfid,0,'int16'); %Unit No 0=unsorted
       fwrite(plxfid,1,'int16'); %Number of waveforms to follow
       fwrite(plxfid,samp_bef+samp_aft,'int16'); %Number of samples per waveform
       
       %write waveform
       waveform=int16(zeros(1,samp_bef+samp_aft));
       waveform(:)=int16(handles.draq_d.snips(ch_num,ii_snip,1:samp_bef+samp_aft));
       fwrite(plxfid,waveform,'int16'); %Waveform
       end
    end
end

%Events
for noEvents=1:handles.draq_d.noEvents
       %write event data block header
       fwrite(plxfid,4,'int16'); %Data type 1=spike 4=event 5=continuous
       fwrite(plxfid,0,'int16'); %Upper bit of 40 bit time stamp
       fwrite(plxfid,handles.draq_d.events(noEvents)*handles.draq_p.ActualRate,'int32'); %Time stamp
       fwrite(plxfid,handles.draq_d.eventType(noEvents),'int16'); %Channel number
       fwrite(plxfid,0,'int16'); %Unit No 0=unsorted
       fwrite(plxfid,0,'int16'); %Number of waveforms to follow
       fwrite(plxfid,0,'int16'); %Number of samples per waveform

end
fclose(plxfid);

toc