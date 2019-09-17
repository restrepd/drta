function handles=drtaPlotBrowseTraces(handles)

% draqPlotSpikePreview(handles)
%
% Plots preview for spike trains
%
%

persistent auto_sign;

if isempty(auto_sign)
    auto_sign=1;
end

%Location of plots
left_axis=0.17;
right_axis=0.78;
bottom_offset=0.145;
height_delta=0.782;

figure(handles.w.drtaBrowseTraces);
set(gcf,'doublebuffer','on') %Reduce plot flicker

scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
noch=handles.draq_p.no_spike_ch;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);

data=drtaGetTraceData(handles);


%First determine whether this is hit, cr, etc
digi=[];
digi = data(:,handles.draq_p.no_chans);

%Please note that bit 1 is not used for spm because it is used in different
%programs for something else such as splus=1 sminus=0
try
    shiftdata30=bitand(digi,2+4+8+16);
    shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
    
    
    %Please note that there are problems with the start of the trial.
    %Because of this we start looking 2 sec and beyond
    shiftdata30(1:handles.draq_p.ActualRate*handles.p.exclude_secs)=0;
    %     shift_dropc_nsampler(1:handles.draq_p.ActualRate*handles.p.exclude_secs)=0;
    
    odor_on=[];
    switch handles.p.which_protocol
        case {1,6}
            %dropcspm
            odor_on=find(shiftdata30==18,1,'first');
        case 5
            %dropcspm conc
            t_start=find(shift_dropc_nsampler==1,1,'first');
            if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*handles.draq_p.ActualRate)&...
                    ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
            end
    end
    
%     try
%         close(1)
%     catch
%     end
%     hFig=figure(1);
%     set(hFig, 'units','normalized','position',[.2 .4 .7 .25])
%     plot(shiftdata30)
    
    %Hit
    if sum(shiftdata30==8)>0.05*handles.draq_p.ActualRate
        drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'Hit ');
        %set(handles.trialOutcome,'String','Hit ');
    else
        %Miss
        if sum(shiftdata30==10)>0.05*handles.draq_p.ActualRate
            drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'Miss');
            %set(handles.trialOutcome,'String','Miss');
        else
            %CR
            if sum(shiftdata30==12)>0.05*handles.draq_p.ActualRate
                drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'CR  ');
                %set(handles.trialOutcome,'String','CR  ');
            else
                %FA
                if sum(shiftdata30==14)>0.05*handles.draq_p.ActualRate
                    drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'FA  ');
                else
                    %Short
                    if(length(find(shiftdata30>=1,1,'first'))==1)&(length(find(shiftdata30==8,1,'first'))~=1)&(length(find(shiftdata30==10,1,'first'))~=1)...
                            (length(find(shiftdata30==12,1,'first'))~=1)&(length(find(shiftdata30>0))>handles.draq_p.ActualRate*0.75)
                        drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'Short');
                    else
                        drtaBrowseTraces('setTrialsOutcome',handles.w.drtaBrowseTraces,'Inter');
                    end
                end
            end
        end
    end
catch
end

if (handles.p.whichPlot~=11)
    %Display analog records
    if (handles.p.which_display==1)
        %Display all traces
        
        
        %Now proceed to plot all channels
        switch handles.p.whichPlot
            case 1
                %Raw data
                data1=data;
%             case 2
%                 %Raw data -mean
%                 szdata=size(data);
%                 baseline=zeros(szdata(1),szdata(2));
%                 mean_data=mean(data,1);
%                 baseline=repmat(mean_data,szdata(1),1);
%                 data1=data-baseline;
            case {2,3,4,5,6,7,8,9,10}
                %Filter with different bandwidths
                switch handles.p.whichPlot
                    case 2
                        fpass=[4 100];
                    case 3 %High Theta 6-10
                        fpass=[6 14];
                    case 4 %Theta 2-12
                        fpass=[2 14];
                    case 5 %Beta 15-36
                        fpass=[15 30];
                    case 6 %Gamma1 35-65
                        fpass=[35 65];
                    case 7 %Gamma2 65-95
                        fpass=[65 95];;
                    case 8 %Gamma 35-95
                        fpass=[35 95];
                    case {9,10} %Spikes 500-5000
                        fpass=[500 5000];
                end
                bpFilt = designfilt('bandpassiir','FilterOrder',20, ...
                    'HalfPowerFrequency1',fpass(1),'HalfPowerFrequency2',fpass(2), ...
                    'SampleRate',floor(handles.draq_p.ActualRate));
                data1=filtfilt(bpFilt,data);
                
                if handles.p.whichPlot==10
                    %Calculate the moving variance
                    data1=movvar(data1,ceil(0.05*handles.draq_p.ActualRate));
                end
        end
        
        
        
        
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
        
        CHID = [1:16];
        
        for (ii=1:noch)
            bottom=bottom_offset+(0.80/noch)*(ii-0.5);
            height=height_delta/noch;
            s_handle(ii)=subplot('Position', [left_axis bottom right_axis height]);
            ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                *handles.draq_p.ActualRate+1);
            ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                +handles.p.display_interval)*handles.draq_p.ActualRate);
            
            plot(data1(ii_from:ii_to,CHID(ii)));
            
            
            
            sz_dat=length(data1);
            tim=[0 sz_dat];
            
            %Calculate 2.5 SD
            %Now plot 3xmedian(std)
            datavec=data1(:,CHID(ii));
            
            sdvec=zeros(1,ceil(length(datavec)/1000));
            
            jj=0;
            for kk=1:1000:length(datavec)-1000
                jj=jj+1;
                sdvec(jj)=std(datavec(kk:kk+1000));
            end
            
            %Set threshold to 2.5 or -2.5 xSD
            two_half_med_SD=2.5*median(sdvec);
            
            %If this is zero this is the differentially subtracted
            %channel, set 2.5SD high
            if two_half_med_SD==0
                two_half_med_SD=100;
            end
            
            if handles.p.set2p5SD==1
                handles.p.threshold(ii)=two_half_med_SD;
            end
            if handles.p.setm2p5SD==1
                handles.p.threshold(ii)=-two_half_med_SD;
            end
            
            %Set threshold to nxSD
            nxSD=handles.p.nxSD*median(sdvec);
            
            %If nxSD=0 this is the differentially subtracted channel
            if nxSD==0
                nxSD=1000;
                handles.p.threshold(ii)=nxSD;
            end
            
            if handles.p.setnxSD==1
                handles.p.threshold(ii)=nxSD;
            end
            
            %Set threshold to uv
            if handles.p.setThr==1
                handles.p.threshold(ii)=handles.p.thrToSet;
            end
            
            
            
            hold on
            
            plot(tim,[handles.p.threshold(ii) handles.p.threshold(ii)],'r');
            
            if exist('odor_on')~=0
                if ~isempty(odor_on)
                    plot([odor_on odor_on],[-handles.draq_p.prev_ylim(ii) handles.draq_p.prev_ylim(ii)],'r');
                end
            end
            
            
            drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
            
            
            hold off
            
            
            ylim(s_handle(ii),[-handles.draq_p.prev_ylim(ii) handles.draq_p.prev_ylim(ii)]);
            set(gca,'YTick',[-handles.draq_p.prev_ylim(ii)+(handles.draq_p.prev_ylim(ii)/3) handles.draq_p.prev_ylim(ii)-(handles.draq_p.prev_ylim(ii)/3)]);
            tick_label={};
            tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
            tick_label{2}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
            set(gca,'YTickLabel',tick_label);
            
            xlim(s_handle(ii),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
            ylabel(s_handle(ii),num2str(ii));
            if ii==1
                %xlabel('Time (sec)');
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
            else
                set(gca,'XTick',0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
                set(gca,'XTickLabel','');
            end
            
        end
        
        
        
        
        
        
    else
        %Display only one trace
        %         try
        %             close 10
        %         catch
        %         end
        %
        %         figure(10)
        ii=handles.p.which_display-1;
        bottom=bottom_offset+(0.80/noch)*(1-0.5);
        height=height_delta;
        s_handle(ii)=subplot('Position', [left_axis bottom right_axis height]);
        
        
        
        notch60HzFilt = designfilt('bandstopiir','FilterOrder',2, ...
            'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
            'DesignMethod','butter','SampleRate',floor(handles.draq_p.ActualRate));
        
        %Now proceed to plot this channel
        switch handles.p.whichPlot
            case 1
                %Raw data
                data1=data;
            case 2
                %Raw data -mean
                szdata=size(data);
                baseline=zeros(szdata(1),szdata(2));
                mean_data=mean(data,1);
                baseline=repmat(mean_data,szdata(1),1);
                data1=data-baseline;
            case {3,4,5,6,7,8,9,10}
                %Filter with different bandwidths
                switch handles.p.whichPlot
                    case 3 %High Theta 6-10
                        fpass=[6 10];
                    case 4 %Theta 2-12
                        fpass=[2 12];
                    case 5 %Beta 15-36
                        fpass=[15 30];
                    case 6 %Gamma1 35-65
                        fpass=[35 65];
                    case 7 %Gamma2 65-95
                        fpass=[65 95];;
                    case 8 %Gamma 35-95
                        fpass=[35 95];
                    case {9,10} %Spikes 500 
                        fpass=[500 5000];
                end
                bpFilt = designfilt('bandpassiir','FilterOrder',20, ...
                    'HalfPowerFrequency1',fpass(1),'HalfPowerFrequency2',fpass(2), ...
                    'SampleRate',floor(handles.draq_p.ActualRate));
                
%                  bpFilt = designfilt('highpassiir','FilterOrder',2, ...
%                     'PassbandFrequency',fpass(1),'Passbandripple',0.2, ...
%                     'SampleRate',floor(handles.draq_p.ActualRate));

                 data1=filtfilt(bpFilt,data);
                
                if handles.p.whichPlot==10
                    %Calculate the moving variance
                    data1=movvar(data1,ceil(0.05*handles.draq_p.ActualRate));
                end
        end
        
        
        
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
        
        CHID = [1:16];
        
        
        ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            *handles.draq_p.ActualRate+1);
        ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            +handles.p.display_interval)*handles.draq_p.ActualRate);
        
        %plot(data2(ii_from:ii_to,CHID(ii)));
        hold off
        
        
        plot(data1(ii_from:ii_to,CHID(ii)),'-b');
        hold on
        
%         Commented out plot the trace to use in a figure for publication
%         figure(1)
%         time=(1:length(data1(ii_from:ii_to,CHID(ii))))/handles.draq_p.ActualRate;
%         plot(time,data1(ii_from:ii_to,CHID(ii)),'-b');
%         ylim([-2500 2500])
%         
        %This is equation 3.1 of Quiroga et al Neural Comp 16:1661 (2004)
        %         quiroga_thr=4*median(abs(data1(ii_from:ii_to,CHID(ii)))/0.6745);
        %         plot([ii_from ii_to], [quiroga_thr quiroga_thr],'-c');
        %         plot([ii_from ii_to], [-quiroga_thr -quiroga_thr],'-c');
        
        %Now plot 3xmedian(std)
        datavec=data1(:,CHID(ii));
        
        sdvec=zeros(1,ceil(length(datavec)/1000));
        
        jj=0;
        for kk=1:1000:length(datavec)-1000
            jj=jj+1;
            sdvec(jj)=std(datavec(kk:kk+1000));
        end
        
        
        two_half_med_SD=2.5*median(sdvec);
        plot([1 ii_to-ii_from+1],[two_half_med_SD two_half_med_SD],'-c');
        hold on
        plot([1 ii_to-ii_from+1],[-two_half_med_SD -two_half_med_SD],'-c');
        
        
        three_t_med_SD=3*median(sdvec);
        plot([1 ii_to-ii_from+1],[three_t_med_SD three_t_med_SD],'-y');
        hold on
        plot([1 ii_to-ii_from+1],[-three_t_med_SD -three_t_med_SD],'-y');
        

        
        sz_dat=length(data1);
        
        
        tim=[0 sz_dat(1)];
        
        hold on
        if isfield(handles.p,'last_threshold')
            plot(tim,[handles.p.last_threshold(ii) handles.p.last_threshold(ii)],'y');
        end
        
        %Set threshold if requested by user
        %If this is zero this is the differentially subtracted
        %channel, set 2.5SD high
        if two_half_med_SD==0
            two_half_med_SD=100;
        end
        
        if handles.p.set2p5SD==1
            handles.p.threshold(ii)=two_half_med_SD;
        end
        if handles.p.setm2p5SD==1
            handles.p.threshold(ii)=-two_half_med_SD;
        end
        
        %Set threshold to nxSD
        nxSD=handles.p.nxSD*median(sdvec);
        
        %If nxSD=0 this is the differentially subtracted channel
        if nxSD==0
            nxSD=1000;
            handles.p.threshold(ii)=nxSD;
        end
        
        if handles.p.setnxSD==1
            handles.p.threshold(ii)=nxSD;
        end
        
        %Set threshold to uv
        if handles.p.setThr==1
            handles.p.threshold(ii)=handles.p.thrToSet;
        end
        
        drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
        
        plot(tim,[handles.p.threshold(ii) handles.p.threshold(ii)],'r');
        thr=handles.p.threshold(ii)
        
        if exist('odor_on')~=0
            if ~isempty(odor_on)
                plot([odor_on odor_on],[-handles.draq_p.prev_ylim(ii) handles.draq_p.prev_ylim(ii)],'r');
            end
        end
        
        
        
        
        hleg1 = legend('Voltage','2.5xSD','2.5xSD','3xSD','3xSD','Threshold','Threshold','Discard');
        
        hold off
        
        %         if (0)
        %             hold on
        %             data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
        %                      floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate),ii));
        %             plot(data_0);
        %             hold off
        %         end
        
        ylim(s_handle(ii),[-handles.draq_p.prev_ylim(ii) handles.draq_p.prev_ylim(ii)]);
        set(gca,'YTick',[-handles.draq_p.prev_ylim(ii)+(handles.draq_p.prev_ylim(ii)/3) handles.draq_p.prev_ylim(ii)-(handles.draq_p.prev_ylim(ii)/3)]);
        tick_label={};
        tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
        tick_label{2}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
        set(gca,'YTickLabel',tick_label);
        
        
        xlim(s_handle(ii),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
        ylabel(s_handle(ii),num2str(ii));
        
        xlabel('Time (sec)');
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
        
        %Stop here if you want to save the figure
        pffft=1;
    end
else
    %This will plot the non-spike traces (traces reporting on
    %digital values, sniffing, etc
    
    
    drtaShowDigital(handles);
end



function [p_handle s_handle]= drtaSetupBrowse(handles)

%Setup the plots
d_samples=0;
noch=handles.draq_p.no_spike_ch;
for (ii=1:noch)
    bottom=bottom_offset+(0.80/noch)*(ii-0.5);
    height=height_delta/noch;
    s_handle(ii)=subplot('Position', [left_axis bottom right_axis height]);
    p_handle(ii)= plot(zeros(handles.p.display_interval*handles.draq_p.ActualRate,1));
    v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
    v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
    scaling = handles.draq_p.scaling;
    offset = handles.draq_p.offset;
    nat_max=(v_max-offset)/scaling;
    nat_min=(v_min-offset)/scaling;
    ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
    set(gca,'YTick',[( ((nat_max+nat_min)/2)-((nat_max-nat_min)/3) ) (nat_max+nat_min)/2 ( ((nat_max+nat_min)/2)+ ((nat_max-nat_min)/3) )]);
    tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
    tick_label{2}='';
    tick_label{3}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
    set(gca,'YTickLabel',tick_label);
    xlim(s_handle(ii),[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
    ylabel(s_handle(ii),num2str(ii));
    if ii==1
        xlabel('Time (sec)');
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
    else
        set(gca,'XTick',0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
        set(gca,'XTickLabel','');
    end
    
end