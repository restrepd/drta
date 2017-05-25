function drtaPlotFeatures(handles)

% drtaPlotFeatures(handles)
%
% Plots preview for spike trains
%
%

figure(handles.w.drtaThresholdSnips);
set(gcf,'doublebuffer','on') %Reduce plot flicker

%Setup the plots
d_samples=0;
if handles.draq_p.dgordra==1
    noch=handles.draq_p.no_spike_ch-1;
else
    noch=handles.draq_p.no_spike_ch;
end
% samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
% samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);

samp_bef=12;
samp_aft=13;
scales=4;

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
        
        %Now get the features requested by the user
        
        %First get feature1
        feature1=[];
        if handles.draq_p.feature1==1
            %User wants p-v
            feature1=max(snips')-min(snips');
        end
        
        if (handles.draq_p.feature1>=2)&(handles.draq_p.feature1<=4)
            %User wants princomp
            [C,S,L] = princomp(snips);
            feature1=S(:,handles.draq_p.feature1-1);
        end
        
        if (handles.draq_p.feature1>=5)
            %User wants princomp
            nspk=size(snips)
            for i=1:nspk(1)
                if exist('wavedec')                             % Looks for Wavelets Toolbox
                    % Wavelet decomposition
                    [c,l]=wavedec(snips(i,:),scales,'haar');   
                else
                    % Replaces Wavelets Toolbox, if not available
                    [c,l]=fix_wavedec(snips(i,:),scales);
                end
                feature1(i)=c(handles.draq_p.feature1-4);
            end
        end
        
        %Then get feature2
        feature2=[];
        if handles.draq_p.feature2==1
            %User wants p-v
            feature2=max(snips')-min(snips');
        end
        
        if (handles.draq_p.feature2>=2)&(handles.draq_p.feature2<=4)
            %User wants princomp
            [C,S,L] = princomp(snips);
            feature2=S(:,handles.draq_p.feature2-1);
        end
        
        if (handles.draq_p.feature2>=5)
            %User wants princomp
            nspk=size(snips)
            for i=1:nspk(1)
                if exist('wavedec')                             % Looks for Wavelets Toolbox
                    % Wavelet decomposition
                    [c,l]=wavedec(snips(i,:),scales,'haar');   
                else
                    % Replaces Wavelets Toolbox, if not available
                    [c,l]=fix_wavedec(snips(i,:),scales);
                end
                feature2(i)=c(handles.draq_p.feature2-4);
            end
        end
       
        
        ph=plot(feature1,feature2,'.b','MarkerSize',1);
        yl=ylim;
        xl=xlim;
        text(xl(1)+0.2*(xl(2)-xl(1)),yl(2)-0.2*(yl(2)-yl(1)),num2str(ii))
    else
        snips=zeros(1,samp_bef+samp_aft);
        ph=plot(snips','w');
    end
    
  
    
end


