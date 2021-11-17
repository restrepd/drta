function  drtaShowDigital(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%This will plot the non-spike traces (traces reporting on
%digital values, sniffing, etc
figure(handles.w.drtaBrowseTraces)

noch=6;
left_axis=0.17;
right_axis=0.78;

%Get the data
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);




%Get the data for this trial

data=drtaGetTraceData(handles);


%17 trigger
%18 sniffing
%19 lick sensor
%20 mouse head
%21 photodiode
%22 digital input

%plot trigger (17)
this_record=17;
%trig=data_this_trial(floor((this_record-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(this_record*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
trig=data(:,this_record);

%Plot the trigger signal
bottom=0.12+(0.80/noch)*(1-0.5);
height=0.92*0.85/noch;
s_handle(1)=subplot('Position', [left_axis bottom right_axis height]);
ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            *handles.draq_p.ActualRate+1);
ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            +handles.p.display_interval)*handles.draq_p.ActualRate);

%trig = data(:,17);
plot(trig(ii_from:ii_to));

%xlabel('Time (sec)');
ylabel('Trigger');
dt=handles.p.display_interval/5;
dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
d_samples=dt*handles.draq_p.ActualRate;
set(gca,'XTick',0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
time=handles.p.start_display_time;
jj=1;
while time<(handles.p.start_display_time+handles.p.display_interval)
    tick_label{jj}=num2str(time);
    time=time+dt;
    jj=jj+1;
end
tick_label{jj}=num2str(time);
set(gca,'XTickLabel',tick_label);

xlim(s_handle(1),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
ylim(s_handle(1),[1500 3000]);


%Plot 18 to 21

for (ii=18:handles.draq_p.no_chans-1)
    bottom=0.12+(0.80/noch)*(ii-16-0.5);
    height=0.92*0.85/noch;
    s_handle(ii-16)=subplot('Position', [left_axis bottom right_axis height]);
    
    this_data=[];
    %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
    this_data=data(:,ii);
    
    plot(this_data(ii_from:ii_to),'-b');
    
    if (handles.p.exc_sn==1)&(ii==19)
        [pkt,lct]=findpeaks(abs(this_data(ii_from+1:ii_to)-this_data(ii_from:ii_to-1)),'MinPeakHeight',handles.p.exc_sn_thr);
        hold on
        plot(lct,this_data(ii_from+lct),'or')
        hold off
    end
    
    min_y=min(this_data(ii_from:ii_to));
    max_y=max(this_data(ii_from:ii_to));
    if max_y==min_y
        this_y=max_y;
        max_y=this_y+1;
        min_y=this_y-1;
    end
    ylim(s_handle(ii-16),[min_y-0.1*(max_y-min_y) max_y+0.1*(max_y-min_y)]);
    
    xlim(s_handle(ii-16),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
    ylabel(s_handle(ii-16),num2str(ii-16));
    
    set(gca,'XTick',0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
    set(gca,'XTickLabel','');
     
    switch ii
        case 18
            ylabel('Sniffing');
        case 19
            ylabel('Lick');
        case 20
            ylabel('In port');
        case 21
            ylabel('Diode');
    end
    
end



bottom=0.12+(0.80/noch)*(handles.draq_p.no_chans-16-0.5);
height=0.92*0.85/noch;
s_handle(handles.draq_p.no_chans-16)=subplot('Position', [left_axis bottom right_axis height]);

this_data=[];
this_data=data(:,22);
 
try
%     shiftdata_all=this_data;
%     one_twenty_eight_here=sum(this_data==128)
    shiftdata_all=bitand(this_data,1+2+4+8+16);
    hold off
    plot(shiftdata_all(ii_from:ii_to));
    hold on
    
    %Draw a red line at odor on
    shift_dropc_nsampler=bitand(this_data,1+2+4+8+16+32);

    odor_on=[];
    switch handles.p.which_c_program
        case 2
            %dropcspm
            odor_on=find(shiftdata_all==18,1,'first');
        case 10
            %dropcspm conc
            t_start=find(shift_dropc_nsampler==1,1,'first');
            if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*handles.draq_p.ActualRate)&...
                    ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
            end
    end
    
    if ~isempty(odor_on)
        plot([odor_on odor_on],[0 35],'-r');
    end
    
    ylim(s_handle(handles.draq_p.no_chans-16),[0 35]);
    xlim(s_handle(handles.draq_p.no_chans-16),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
    ylabel('Digital');
    
    pffft=1;
    
    %This code is here to plot the digital data in a separate figure
       
%      try
%         close 1
%     catch
%     end
%     
%     hFig1 = figure(1);
%     set(hFig1, 'units','normalized','position',[.15 .6 .7 .23])
%     
%     plot(shiftdata_all(ii_from:ii_to));

    
    %This code is here to read the odor onset time measured with the PID in
    %dropc_conc in the sniff channel
    
   
%     %Find the onset of the odor
%      try
%         close 1
%     catch
%     end
%     
%     hFig1 = figure(1);
%     set(hFig1, 'units','normalized','position',[.15 .6 .7 .23])
%     
%     ii_FV=find(shiftdata_all==1,1,'first');
%     delta_ii_odor_on=find(shiftdata_all(ii_FV:end)>1,1,'first');
%     this_trace=shiftdata_all(ii_FV+delta_ii_odor_on-ceil(0.1*handles.draq_p.ActualRate):ii_FV+delta_ii_odor_on+ceil(0.2*handles.draq_p.ActualRate));
%     plot(([1:length(this_trace)]/handles.draq_p.ActualRate)-0.1,this_trace)
%     
%     %Plot the sniff channel
%      try
%         close 2
%     catch
%     end
%     
%     hFig2 = figure(2);
%     set(hFig2, 'units','normalized','position',[.15 .6 .7 .23])
%     
%     this_data=data(:,18);
%     this_trace=this_data(ii_FV+delta_ii_odor_on-ceil(0.1*handles.draq_p.ActualRate):ii_FV+delta_ii_odor_on+ceil(0.2*handles.draq_p.ActualRate));
%     plot(([1:length(this_trace)]/handles.draq_p.ActualRate)-0.1,this_trace)
%     
%If you rrun drta_save_sniffs you save decimated sniff traces
catch
end

% figure(1)
% hold on
% 
% %Plot the filtered output
% filtLFP_data=[];
% %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
% filtLFP_data=data(:,21);
% 
% plot(filtLFP_data(ii_from:ii_to),'-b');
% 
% max_filtLFP_data=max(filtLFP_data(ii_from:ii_to));
% 
% %Plot the laserTTL
% laserTTL_data=[];
% %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
% laserTTL_data=data(:,18);
% 
% max_laserTTL_data=max(laserTTL_data);
% 
% plot((max_filtLFP_data/max_laserTTL_data)*laserTTL_data(ii_from:ii_to),'-r');


pffft=1;



