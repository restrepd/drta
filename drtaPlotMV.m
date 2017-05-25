function drtaPlotMV(handles)

% draqPlotSpikePreview(handles)
%
% Plots preview for spike trains
%   
%
tic

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

b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);



for ii=1:noch
    if handles.p.ch_processed(ii)==1
        v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        nat_thr=(v_thr-offset)/scaling;
        v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        nat_upper=(v_upper-offset)/scaling;
        v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        nat_lower=(v_lower-offset)/scaling;

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
                
        
        sz_dvec=size(datavec);
        sdvec=zeros(1,sz_dvec(1)-(samp_bef+samp_aft));
            
        for kk=1:sz_dvec(1)-(samp_bef+samp_aft)
             MV(kk,2)=log10(var(datavec(kk:kk+(samp_bef+samp_aft))));
             MV(kk,1)=mean(datavec(kk:kk+(samp_bef+samp_aft)));
        end
        plot(3*sdvec-(offset/scaling),'b');
        hold on
        plot(-3*sdvec-(offset/scaling),'b'); 
                
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



toc
figure(handles.w.drtaThresholdSnips);
set(gcf,'doublebuffer','on') %Reduce plot flicker

%Setup the plots
d_samples=0;
noch=handles.draq_p.no_spike_ch-1;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
for (ii=1:noch)
        ii
        bottom=0.17+(0.80/(noch/4))*(floor((ii-1)/(noch/4)));
        height=0.93*0.85/(noch/4);     
        a1=0.96;
        width=((a1-0.15)/(noch/4));
        left=(0.09+(a1-0.15)*rem(ii-1,(noch/4))/(noch/4));
        sh=subplot('Position', [left bottom width height]);
        if handles.p.ch_processed(ii)==1
            v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_thr=(v_thr-offset)/scaling;
            v_upper=(handles.p.upper_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_upper=(v_upper-offset)/scaling;
            v_lower=(handles.p.lower_limit(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            nat_lower=(v_lower-offset)/scaling;

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


            sz_dvec=size(datavec);
            sdvec=zeros(1,sz_dvec(1)-(samp_bef+samp_aft));

            for kk=1:sz_dvec(1)-(samp_bef+samp_aft)
                 MV(kk,2)=log10(var(datavec(kk:kk+(samp_bef+samp_aft))));
                 MV(kk,1)=mean(datavec(kk:kk+(samp_bef+samp_aft)));
            end
            
            [N, C] = hist3(MV,[50 50]);
            pcolor(C{1},C{2},log10(N+1));



%             v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
%             v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
%             scaling = handles.draq_p.scaling;
%             offset = handles.draq_p.offset;
%             nat_max=(v_max-offset)/scaling;
%             nat_min=(v_min-offset)/scaling;
%             ylim(sh,[nat_min nat_max]); %Note numbers are native
%             set(gca,'YTick',[( ((nat_max+nat_min)/2)-((nat_max-nat_min)/3) ) (nat_max+nat_min)/2 ( ((nat_max+nat_min)/2)+ ((nat_max-nat_min)/3) )]);
%             if rem(ii-1,(noch/4))==0
%                 tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
%                 tick_label{2}='0';
%                 tick_label{3}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
%             else
%                 tick_label{1}='';
%                 tick_label{2}='';
%                 tick_label{3}='';   
%             end
%             set(gca,'YTickLabel',tick_label);
%             xlim(sh,[0 (samp_bef+samp_aft)]);
%             text((samp_bef+samp_aft)*0.2 ,nat_min+0.1*(nat_max-nat_min),num2str(ii),'HorizontalAlignment','left')
% 
%             if floor((ii-1)/(noch/4))==0
%                xlabel('Time (sec)'); 
%                dt=(samp_bef+samp_aft)/(1*handles.draq_p.ActualRate);
%                dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
%                d_samples=dt*handles.draq_p.ActualRate;
%                set(gca,'XTick',0:d_samples:samp_bef+samp_aft);
%                time=0;
%                jj=1;
%                while time<(samp_bef+samp_aft)/(handles.draq_p.ActualRate)
%                    tick_label{jj}=num2str(time);
%                    time=time+dt;
%                    jj=jj+1;
%                end
%                tick_label{jj}=num2str(time);
%                set(gca,'XTickLabel',tick_label);
%             else
%                set(gca,'XTick',0:d_samples:handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate);
%                set(gca,'XTickLabel','');
%             end

        else
            plot([],[]);
        end
end


