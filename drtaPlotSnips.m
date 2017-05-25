function drtaPlotSnips(handles)

% draqPlotSpikePreview(handles)
%
% Plots preview for spike trains
%   
%

figure(handles.w.drtaThresholdSnips);
set(gcf,'doublebuffer','on') %Reduce plot flicker
%b = ones(1,ceil(handles.p.filter_dt*handles.draq_p.ActualRate))/ceil(handles.p.filter_dt*handles.draq_p.ActualRate);
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
noch=handles.draq_p.no_spike_ch;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
%[p_handle s_handle]=drtaSetupBrowse(handles);
data = drta('getTraceData',handles.w.drta);
s_handle=zeros(1,noch);

if (handles.p.which_display==1)
    %Display all traces

    for ii=1:noch
            bottom=0.12+(0.80/noch)*(ii-0.5);
            height=0.92*0.85/noch;
            s_handle(ii)=subplot('Position', [0.1 bottom 0.8 height]);
            if (ii<noch)
               if (handles.draq_d.snip_samp(ii)>0)
                    snips=zeros(handles.draq_d.snip_samp(ii),samp_bef+samp_aft);
                    snips(:,:)=handles.draq_d.snips(ii,1:handles.draq_d.snip_samp(ii),:);
                    snip_index=zeros(handles.draq_d.snip_samp(ii),samp_bef+samp_aft);
                    snip_index(:,:)=handles.draq_d.snip_index(ii,1:handles.draq_d.snip_samp(ii),:);
                    plot(snip_index',snips','b')
               else
                   plot([0 0],[0 0],'b');
               end

                v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
                scaling = handles.draq_p.scaling;
                offset = handles.draq_p.offset;
                nat_max=(v_max-offset)/scaling;
                nat_min=(v_min-offset)/scaling;
                ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
            else
                plot(data(floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
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

               if (handles.draq_d.snip_samp(ii)>0)
                    snips=zeros(handles.draq_d.snip_samp(ii),samp_bef+samp_aft);
                    snips(:,:)=handles.draq_d.snips(ii,:,:);
                    snip_index=zeros(handles.draq_d.snip_samp(ii),samp_bef+samp_aft);
                    snip_index(:,:)=handles.draq_d.snip_index(ii,:,:);
                    plot(snip_index',snips','b');
               else
                   plot([0 0],[0 0],'b');
               end

        v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
        v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);

        nat_max=(v_max-offset)/scaling;
        nat_min=(v_min-offset)/scaling;
        ylim(s_handle(ii),[nat_min nat_max]); %Note numbers are native
    else
        plot(data( floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
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