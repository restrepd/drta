function drtaPlotPileup(handles)

% draqPlotSpikePreview(handles)
%
% Plots preview for spike trains
%
%

figure(handles.w.drtaThresholdSnips);
set(gcf,'doublebuffer','on') %Reduce plot flicker

samp_bef=12;
samp_aft=13;

%Setup the plots
d_samples=0;
if handles.draq_p.dgordra==1
    noch=handles.draq_p.no_spike_ch-1;
else
    noch=handles.draq_p.no_spike_ch;
end
% samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
% samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);
for (ii=1:noch)
    if noch>=4
        bottom=0.17+(0.80/(noch/4))*(floor((ii-1)/(noch/4)));
        height=0.93*0.85/(noch/4);
        a1=0.96;
        width=((a1-0.15)/(noch/4));
        left=(0.09+(a1-0.15)*rem(ii-1,(noch/4))/(noch/4));
    else
        bottom=0.17+floor((ii-0.1)/2)*0.4;
        height=0.37;
        width=0.35;
        left=0.09+rem((ii+1),2)*0.42;
    end
    
    sh=subplot('Position', [left bottom width height]);
    if handles.draq_d.snip_samp(ii)>0
        snips=ones(handles.draq_d.snip_samp(ii),samp_bef+samp_aft);
        snips(:,:)=handles.draq_d.snips(ii,1:handles.draq_d.snip_samp(ii),1:samp_bef+samp_aft);
        ph=plot(snips');
        yl=ylim;
        xl=xlim;
        text(xl(1)+0.2*(xl(2)-xl(1)),yl(2)-0.2*(yl(2)-yl(1)),num2str(ii))
    else
        snips=zeros(1,samp_bef+samp_aft);
        ph=plot(snips','w');
    end
    
%     if handles.draq_p.dgordra==1
%         if length(handles.draq_p.pre_gain)==1
%             v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
%             v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000);
%         else
%             v_max=(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
%             v_min=-(handles.draq_p.prev_ylim(ii)*handles.draq_p.pre_gain(ii)*handles.draq_p.daq_gain/1000000);
%         end
%         scaling = handles.draq_p.scaling;
%         offset = handles.draq_p.offset;
%         nat_max=(v_max-offset)/scaling;
%         nat_min=(v_min-offset)/scaling;
%         ylim(sh,[nat_min nat_max]); %Note numbers are native
%         set(gca,'YTick',[( ((nat_max+nat_min)/2)-((nat_max-nat_min)/3) ) (nat_max+nat_min)/2 ( ((nat_max+nat_min)/2)+ ((nat_max-nat_min)/3) )]);
%         
%         
%         if rem(ii-1,(noch/4))==0
%             tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
%             tick_label{2}='0';
%             tick_label{3}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
%         else
%             tick_label{1}='';
%             tick_label{2}='';
%             tick_label{3}='';
%         end
%         set(gca,'YTickLabel',tick_label);
%         text((samp_bef+samp_aft)*0.2 ,nat_min+0.1*(nat_max-nat_min),num2str(ii),'HorizontalAlignment','left')
%     else
%         set(gca,'YTick',[-handles.draq_p.prev_ylim(ii)+(handles.draq_p.prev_ylim(ii)/3) handles.draq_p.prev_ylim(ii)-(handles.draq_p.prev_ylim(ii)/3)]);
%         tick_label={};
%         tick_label{1}=num2str(floor(-2*handles.draq_p.prev_ylim(ii)/3));
%         tick_label{2}=num2str(floor(2*handles.draq_p.prev_ylim(ii)/3));
%         set(gca,'YTickLabel',tick_label);
%     end
%     
%     
%     xlim(sh,[0 (samp_bef+samp_aft)]);
%     
%     
%     if floor((ii-1)/(noch/4))==0
%         xlabel('Time (sec)');
%         dt=(samp_bef+samp_aft)/(1*handles.draq_p.ActualRate);
%         dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
%         d_samples=dt*handles.draq_p.ActualRate;
%         set(gca,'XTick',0:d_samples:samp_bef+samp_aft);
%         time=0;
%         jj=1;
%         while time<(samp_bef+samp_aft)/(handles.draq_p.ActualRate)
%             tick_label{jj}=num2str(time);
%             time=time+dt;
%             jj=jj+1;
%         end
%         tick_label{jj}=num2str(time);
%         set(gca,'XTickLabel',tick_label);
%     else
%         set(gca,'XTick',0:d_samples:handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate);
%         set(gca,'XTickLabel','');
%     end
    
    
end


