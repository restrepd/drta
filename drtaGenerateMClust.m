function drtaGenerateMClust(hObject, handles)
% hObject    handle to drtaThresholdPush (see GCBO)
% handles    structure with handles and user data (see GUIDATA)


%This is a dg file
noch=handles.draq_p.no_spike_ch;
handles.draq_d.snip_samp=zeros(1,noch);
oldTrialNo=handles.p.trialNo;
samp_bef=16;
samp_aft=16;
no_spikes=0;

for tets=1:4
    
    %For each tetrode get the spikes and save them
    %for trialNo=1:2
    for trialNo=1:handles.draq_d.noTrials
        
        trialNo
        tic
        
        
        data=drtaGetTraceData(handles);
        
        
        
        %         Fstop1 = 800;
        %         Fpass1 = 1000;
        %         Fpass2 = 2800;
        %         Fstop2 = 3000;
        %         Astop1 = 65;
        %         Apass  = 0.5;
        %         Astop2 = 65;
        %         Fs = handles.draq_p.ActualRate;
        %
        %         d = designfilt('bandpassfir', ...
        %             'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
        %             'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
        %             'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
        %             'StopbandAttenuation2',Astop2, ...
        %             'DesignMethod','equiripple','SampleRate',Fs);
        %
        %         data1=filtfilt(d,data);
        
        bpFilt = designfilt('bandpassiir','FilterOrder',20, ...
            'HalfPowerFrequency1',1000,'HalfPowerFrequency2',5000, ...
            'SampleRate',floor(handles.draq_p.ActualRate));
        
        data1=filtfilt(bpFilt,data);
        
        
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
        
        szdata1=size(data1);
        
        jj=17;
        
        while jj<szdata1(1)-32
            %Go through the time and find spikes
            
            %Is there a spike?
            found_spike=0;
            for ii=1:4
                if (handles.p.ch_processed((tets-1)*4+ii)==1)
                    if handles.p.threshold(ii)>0
                        if (data1(jj,(tets-1)*4+ii)>handles.p.threshold(ii))
                            found_spike=1;
                        end
                    else
                        if (data1(jj,(tets-1)*4+ii)<handles.p.threshold(ii))
                            found_spike=1;
                        end
                    end
                    
                end
            end
            
            if (found_spike==1)
                no_spikes=no_spikes+1;
                for ii=1:4
                    if (handles.p.ch_processed((tets-1)*4+ii)==1)
                        wv1.spikes(no_spikes,ii,1:32)=data1(jj-samp_bef+1:jj+samp_aft,(tets-1)*4+ii);
                    else
                        wv1.spikes(no_spikes,ii,1:32)=zero(1,32);
                    end
                    wv1.ts(no_spikes)=handles.draq_d.t_trial(trialNo)+(jj/handles.draq_p.ActualRate);
                end
                
            end
            
            jj=jj+1;
            
            
        end
        toc
    end
    if isfield(wv1,'ts')
        save([handles.p.fullName(1:end-3) 'tet' num2str(tets) '.mat'], 'wv1');
        wv1=rmfield(wv1,'spikes');
        wv1=rmfield(wv1,'ts');
    end
    
end %for tets=1:4


drta('setTrialNo',handles.w.drta,oldTrialNo);


