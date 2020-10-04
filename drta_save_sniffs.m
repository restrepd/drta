%when this code is run in drtaShowDigital it saves the sniff data
dec_fact=24;
Fr=handles.draq_p.ActualRate/dec_fact;
delta_t=8;
no_trials=handles.draq_d.noTrials;
sniff_out=zeros(no_trials,floor(delta_t*Fr));

for trNo=1:no_trials
    handles.p.trialNo=trNo;
    data=drtaGetTraceData(handles);
    these_sniff_data=data(:,18);
    these_sniff_decimated=decimate(these_sniff_data,dec_fact); 
    these_sniff_decimated=these_sniff_decimated(1:floor(delta_t*Fr),1)';
    these_sniff_decimated=these_sniff_decimated-mean(these_sniff_decimated);
    sniff_out(trNo,:)=these_sniff_decimated;
end

sniff_out=5*sniff_out/max(abs(sniff_out(:)));
save('/Users/restrepd/Documents/Projects/Justin/Sniff/decimated_sniff.mat','sniff_out','Fr')