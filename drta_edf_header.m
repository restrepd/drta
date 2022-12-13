function [draq_p,draq_d]=drta_edf_header(filename, handles)

draq_p.dgordra=4;  %3 is edf
draq_p.show_plot=0;
draq_p.ActualRate=2000;
draq_p.srate=2000;

%edf assumes that which_protocol=7 (continuous)
draq_p.sec_before_trigger=handles.pre_dt;
draq_p.sec_per_trigger=handles.trial_duration;


draq_p.pre_gain=0;
draq_p.scaling=1;
draq_p.offset=0;

draq_d.noTrials=0;
draq_d.trig=1;
draq_d.num_amplifier_channels=16; %Note: only the first four have data for edf
% draq_d.num_samples_per_data_block=num_samples_per_data_block;
% draq_d.num_board_adc_channels=num_board_adc_channels;
% draq_d.num_board_dig_in_channels=num_board_dig_in_channels;
% draq_d.eval_board_mode=eval_board_mode;
% draq_d.board_dig_in_channels=board_dig_in_channels;


ptr_file=matfile(filename);

%Find the trials
at_end=0;
ii=1;
trials_to_sort=[];
full_trial_start=[];
full_trial_end=[];



%continuous read
%Find the full trials (excluding short trials)
ii=1;
total_length=ptr_file.no_samples;

while at_end==0

    %Is is too close to the end?
    if (ii+(draq_p.sec_per_trigger*draq_p.ActualRate)-1)<total_length

        %Full trial
        draq_d.noTrials=draq_d.noTrials+1;
        draq_d.trial_ii_start(draq_d.noTrials)=ii;
        draq_d.trial_ii_end(draq_d.noTrials)=ii+(draq_p.sec_per_trigger*draq_p.ActualRate)-1;
        draq_d.t_trial(draq_d.noTrials)=(ii-1)*draq_p.ActualRate;
        ii=ii+(draq_p.sec_per_trigger*draq_p.ActualRate);
    else
        at_end=1;
    end

end

full_trials=draq_d.noTrials;

fprintf(1, 'Found %d full trials...\n',full_trials);

draq_d.t_end=draq_d.t_trial(draq_d.noTrials)+draq_p.sec_per_trigger;
draq_d.total_length=total_length;
fprintf(1, 'Done reading rhd header...\n');





