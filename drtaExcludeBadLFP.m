function handles = drtaExcludeBadLFP(handles)
%   This function excludes bad LFPs

if isfield(handles,'drtachoices')
    fprintf(1, ['Vetting LFPs...\n']);
end
tic
% oldTrialNo=handles.p.trialNo;


noch=handles.draq_p.no_spike_ch;


%This is dg
bytes_per_native=2;     %Note: Native is unit16
size_per_ch_bytes=handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate*bytes_per_native;
no_unit16_per_ch=size_per_ch_bytes/bytes_per_native;


gcp

for lfpno=1:16
    handles_out(lfpno).no_trials_exc=0;
    handles_out(lfpno).trials_excluded=[];
end


parfor lfpno=1:16
    if ~isfield(handles,'drtachoices')
        fprintf(1, ['Vetting LFP number %d\n'],lfpno)
    end
    handlespf=handles;
    for trNo=1:handlespf.draq_d.noTrials
        if handlespf.p.trial_allch_processed(trNo)==1
            
            %Get the data for this LFP
            
            
            handlespf.p.trialNo=trNo;
            data_this_trial=drtaGetTraceData(handlespf);
            data=[];
            data=data_this_trial(:,lfpno);
            
            
            %Exclude trials where the extracellular voltage signal exceeds
            %the maximum/minimum voltages of the amplifier
            if (((sum(data>handlespf.p.lfp.maxLFP)+sum(data<handlespf.p.lfp.minLFP))...
                    /handlespf.draq_p.ActualRate)>handlespf.p.lfp.delta_max_min_out)
%                 handlespf.p.trial_ch_processed(lfpno,trNo)=0;
                handles_out(lfpno).no_trials_exc=handles_out(lfpno).no_trials_exc+1;
                handles_out(lfpno).trials_excluded(handles_out(lfpno).no_trials_exc).trNo=trNo;
            end
            
            %Exclude triasl that have a sudden large change in the extracellular voltage
            %This sudden large change in voltage will generate a large power LFP for
            %all frequencies in spectrogram
            delta_abs=max(abs(data(2:end)-data(1:end-1)));
            if delta_abs>handlespf.p.lfp.maxLFP-handlespf.p.lfp.minLFP
%                 handlespf.p.trial_ch_processed(lfpno,trNo)=0;
                handles_out(lfpno).no_trials_exc=handles_out(lfpno).no_trials_exc+1;
                handles_out(lfpno).trials_excluded(handles_out(lfpno).no_trials_exc).trNo=trNo;
            end
            
            
        else
            %             handlespf.p.trial_ch_processed(lfpno,trNo)=0;
            handles_out(lfpno).no_trials_exc=handles_out(lfpno).no_trials_exc+1;
            handles_out(lfpno).trials_excluded(handles_out(lfpno).no_trials_exc).trNo=trNo;
        end
    end
    
    
end

for lfpno=1:16
    if handles_out(lfpno).no_trials_exc>0
        for ntrs=1:handles_out(lfpno).no_trials_exc
            trNo=handles_out(lfpno).trials_excluded(ntrs).trNo;
            handlesp.p.trial_ch_processed(lfpno,trNo)=0;
        end
    end
end

% handles.p.trialNo=oldTrialNo;

if ~isfield(handles,'drtachoices')
    toc
end


