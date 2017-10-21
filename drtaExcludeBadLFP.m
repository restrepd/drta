function handles = drtaExcludeBadLFP(handles)
%   This function excludes bad LFPs

tic
oldTrialNo=handles.p.trialNo;


noch=handles.draq_p.no_spike_ch;


%This is dg
bytes_per_native=2;     %Note: Native is unit16
size_per_ch_bytes=handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate*bytes_per_native;
no_unit16_per_ch=size_per_ch_bytes/bytes_per_native;


for lfpno=1:16
    lfpno
    
    for trNo=1:handles.draq_d.noTrials
        if handles.p.trial_allch_processed(trNo)==1
            
            %Get the data for this LFP
            
            
            handles.p.trialNo=trNo;
            data_this_trial=drtaGetTraceData(handles);
            data=[];
            data=data_this_trial(:,lfpno);
            
            
            %Exclude trials where the extracellular voltage signal exceeds
            %the maximum/minimum voltages of the amplifier
            if (((sum(data>handles.p.lfp.maxLFP)+sum(data<handles.p.lfp.minLFP))...
                    /handles.draq_p.ActualRate)>handles.p.lfp.delta_max_min_out)
                handles.p.trial_ch_processed(lfpno,trNo)=0;
            end
            
            %Exclude triasl that have a sudden large change in the extracellular voltage
            %This sudden large change in voltage will generate a large power LFP for
            %all frequencies in spectrogram
            delta_abs=max(abs(data(2:end)-data(1:end-1)));
            if delta_abs>handles.p.lfp.maxLFP-handles.p.lfp.minLFP
                handles.p.trial_ch_processed(lfpno,trNo)=0;
            end
            
            
        else
            handles.p.trial_ch_processed(lfpno,trNo)=0;
            
        end
    end
    
    
end

handles.p.trialNo=oldTrialNo;
toc


