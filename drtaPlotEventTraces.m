function drtaPlotBrowseTraces(handles)

% draqPlotSpikePreview(handles)
%
% Plots preview for spike trains
%
%

figure(handles.w.drtaBrowseTraces);
set(gcf,'doublebuffer','on') %Reduce plot flicker

switch (handles.p.do_filter)
    case (1)
        a=1;
        b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);
    case (2)
        fmin_detect=300;
        fmax_detect=3000;
        [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/handles.draq_p.ActualRate);
end


scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
noch=handles.draq_p.no_spike_ch;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
data = drta('getTraceData',handles.w.drta);

if (handles.p.which_display==1)
    %Display all traces

    for (ii=1:noch)
        bottom=0.12+(0.80/noch)*(ii-0.5);
        height=0.92*0.85/noch;
        s_handle(ii)=subplot('Position', [0.15 bottom 0.8 height]);
        if (ii<noch)
            switch (handles.p.do_filter)
                case (1)
                    data_0 = filtfilt(b,a,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                        *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                        +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
                    data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                        floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)...
                        *handles.draq_p.ActualRate),ii);
                    p_handle(ii)=plot((data_1-data_0)-offset/scaling);
                case (2)
                    data_1 = filtfilt(b,a,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                        *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                        +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
                    %data_0=mean(data_1);
                    p_handle(ii)=plot(data_1-offset/scaling);
                case (3)
                    %                     data_0 = mean(data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                    %                     *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                    %                     +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
                    data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                        floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)...
                        *handles.draq_p.ActualRate),ii);
                    data_0=mean(data_1);
                    p_handle(ii)=plot((data_1-data_0)-offset/scaling);
            end

            sz_dat=size(data_1);
            tim=[0 sz_dat(1)];
            if length(handles.draq_p.pre_gain)==1
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                nat_thr=(v_thr-offset)/scaling;
                y_thr=[nat_thr nat_thr];
                hold on
                plot(tim,y_thr,'r');
            else
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                nat_thr=(v_thr-offset)/scaling;
                y_thr=[nat_thr nat_thr];
                hold on
                plot(tim,y_thr,'r');
                
            end
            
            %If exclude snips is on, and there is a value for the threshold
            %plot a green line
            if isfield(handles.p,'exc_sn')
                if handles.p.exc_sn==1
                    if isfield(handles.p,'exc_sn_thr')
                        if length(handles.draq_p.pre_gain)>1
                            v_thr=(handles.p.exc_sn_thr*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                        else
                            v_thr=(handles.p.exc_sn_thr*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                        end
                        nat_thr=(v_thr-offset)/scaling;
                        y_thr=[nat_thr nat_thr];
                        plot(tim,y_thr,'g');
                    end  
                end
            end

            hold off

            if length(handles.draq_p.pre_gain)==1
                v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                scaling = handles.draq_p.scaling;
                offset = handles.draq_p.offset;
                nat_max=(v_max-offset)/scaling;
                nat_min=(v_min-offset)/scaling;
                ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
            else
                v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                scaling = handles.draq_p.scaling;
                offset = handles.draq_p.offset;
                nat_max=(v_max-offset)/scaling;
                nat_min=(v_min-offset)/scaling;
                ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
            end
        else
            %                 p_handle(ii)= plot(bitshift(bitand(data((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            %                     *handles.draq_p.ActualRate+1:(handles.draq_p.acquire_display_start+handles.p.start_display_time...
            %                     +handles.p.display_interval)*handles.draq_p.ActualRate,ii),248),-2));
            p_handle(ii)= plot(data(floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
        end

        set(gca,'YTick',[( ((nat_max+nat_min)/2)-((nat_max-nat_min)/3) ) (nat_max+nat_min)/2 ( ((nat_max+nat_min)/2)+ ((nat_max-nat_min)/3) )]);
        tick_label={};
        if (ii<noch)
            tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
            tick_label{2}='';
            tick_label{3}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
        else
            ylims=get(gca,'YLim');
            nat_min=ylims(1);
            nat_max=ylims(2);
            tick_label{1}=num2str(floor(nat_min+(1/3)*(nat_max-nat_min)));
            tick_label{2}='';
            tick_label{3}=num2str(floor(nat_min+(2/3)*(nat_max-nat_min)));
        end
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

else
    %Display only one trace

    ii=handles.p.which_display-1;
    bottom=0.12+(0.80/noch)*(1-0.5);
    height=0.92*0.85;
    s_handle(ii)=subplot('Position', [0.15 bottom 0.8 height]);
    if (ii<noch)

        if (handles.p.do_filter==1)
            data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate),ii));
            data_1=data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate),ii);


            if (handles.p.do_3xSD==0)
                plot((data_1-data_0)-offset/scaling);
                hold on
            else
                datavec=(data_1-data_0)-(offset/scaling);
                sz_dvec=size(datavec);
                sdvec=zeros(1,sz_dvec(1)-(samp_bef+samp_aft));

                for kk=1:sz_dvec(1)-(samp_bef+samp_aft)
                    sdvec(kk)=std(datavec(kk:kk+(samp_bef+samp_aft)));
                end
                plot(3*sdvec-(offset/scaling),'b');
                hold on
                plot(-3*sdvec-(offset/scaling),'b');
            end
            sz_dat=size(data_0);
            tim=[0 sz_dat(1)];
            if length(handles.draq_p.pre_gain)>1
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
            else
                v_thr=(handles.p.threshold(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            end
            nat_thr=(v_thr-offset)/scaling;
            y_thr=[nat_thr nat_thr];
            plot(tim,y_thr,'r');
            hold on
            
            %If exclude snips is on, and there is a value for the threshold
            %plot a green line
            if isfield(handles.p,'exc_sn')
                if handles.p.exc_sn==1
                    if isfield(handles.p,'exc_sn_thr')
                        if length(handles.draq_p.pre_gain)>1
                            v_thr=(handles.p.exc_sn_thr*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
                        else
                            v_thr=(handles.p.exc_sn_thr*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                        end
                        nat_thr=(v_thr-offset)/scaling;
                        y_thr=[nat_thr nat_thr];
                        plot(tim,y_thr,'g');
                    end     
                end
            end
            
            hold off
        else
            p_handle(ii)= plot(data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
                floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate),ii));
        end
        %         if (0)
        %             hold on
        %             data_0 = filtfilt(b,1,data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1):...
        %                      floor((handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate),ii));
        %             plot(data_0);
        %             hold off
        %         end
        
        if length(handles.draq_p.pre_gain)>1
            v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
            v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);   
        else
            v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
            v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        end
            
        nat_max=(v_max-offset)/scaling;
        nat_min=(v_min-offset)/scaling;
        ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
    else
        p_handle(ii)= plot(data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            *handles.draq_p.ActualRate+1):floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            +handles.p.display_interval)*handles.draq_p.ActualRate),ii));
    end

    tick_label={};
    set(gca,'YTick',[( ((nat_max+nat_min)/2)-((nat_max-nat_min)/3) ) (nat_max+nat_min)/2 ( ((nat_max+nat_min)/2)+ ((nat_max-nat_min)/3) )]);
    if (ii<noch)
        tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
        tick_label{2}='';
        tick_label{3}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
    else
        ylims=get(gca,'YLim');
        nat_min=ylims(1);
        nat_max=ylims(2);
        tick_label{1}=num2str(floor(nat_min+(1/3)*(nat_max-nat_min)));
        tick_label{2}='';
        tick_label{3}=num2str(floor(nat_min+(2/3)*(nat_max-nat_min)));
    end

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

end
% for ii=1:noch
%    set(p_handle(ii),'ydata',data((handles.draq_p.acquire_display_start+handles.p.start_display_time)*handles.draq_p.ActualRate+1:(handles.draq_p.acquire_display_start+handles.p.start_display_time+handles.p.display_interval)*handles.draq_p.ActualRate,ii));
% end
%
% drawnow


function [p_handle s_handle]= drtaSetupBrowse(handles)

%Setup the plots
d_samples=0;
noch=handles.draq_p.no_spike_ch;
for (ii=1:noch)
    bottom=0.12+(0.80/noch)*(ii-0.5);
    height=0.92*0.85/noch;
    s_handle(ii)=subplot('Position', [0.15 bottom 0.8 height]);
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