function [data_this_trial]=drtaGetTraceDataEDF(handles)

ptr_file=matfile([handles.p.fullName(1:end-4) '_edf.mat']);

data_this_trial=zeros(handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate,22);
data_this_trial(:,1:ptr_file.no_columns)=ptr_file.data_out(handles.draq_d.trial_ii_start(handles.p.trialNo):handles.draq_d.trial_ii_end(handles.p.trialNo),:);





