function drtaGenerateEvents(handles)
% hObject    handle to drtaThresholdPush (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'drtachoices')
    fprintf(1, ['Generating events...\n']);
end

%Genterates the header information for events, etc saved in jt_times and drg files
oldTrialNo=handles.p.trialNo;

generate_dio_bits=0;

oldTrialNo=handles.p.trialNo;

%Events
handles.draq_d.noEvents=0;


t_start_index=0;
t_start_events=[];

if ~isfield(handles,'drta_p')
    handles.drta_p.exc_sn=0;
end

% determine program type and set up event labels
switch handles.p.which_c_program
    case(1)
        %dropcnsampler
        %This is a dg file
        
        handles.draq_d.nEventTypes=2;
        handles.draq_d.eventlabels=[];
        handles.draq_d.eventlabels{1}='FinalValve';
        handles.draq_d.eventlabels{2}='OdorOn';
        
        
        %Find which odors were used
        dropc_nsamp_odors=[];
        ii_dropc_nsamp_odors=0;
        FV_interval=0;
        dropc_nsamp_odorNo=[];
        for trialNo=1:handles.draq_d.noTrials
            if ~isfield(handles,'drtachoices')
                trialNo
            end
            tic
            
            
            
            handles.p.trialNo=trialNo;
            data=drtaGetTraceData(handles);
            
            digi = data(:,handles.draq_p.no_chans);
            shiftdat=bitand(digi,1+2+4+8+16+32);
            
            %For some reason the first trial is incorrect and has a 63 in
            %it
            shiftdat=shiftdat(shiftdat<63);
            
            %Find the vaule of the first number different from zero
            first_not_zero_ii=find(shiftdat>0,1,'first');
            
            if ~isempty(first_not_zero_ii)
                
                first_not_zero=shiftdat(first_not_zero_ii);
                
                
                
                if first_not_zero==4
                    
                    %This is an odor, find which odor
                    found_odor=0;
                    for odorNo=[1 2 8 16 32]
                        first_odor_ii=find(shiftdat==odorNo,1,'first');
                        if ~isempty(first_odor_ii)
                            found_odor=1;
                            odor_ii(trialNo)=first_odor_ii;
                            FV_interval=first_odor_ii-first_not_zero_ii;
                            exclude_trial(trialNo)=0;
                            dropc_nsamp_odorNo(trialNo)=odorNo;
                            if isempty(dropc_nsamp_odors==odorNo)
                                ii_dropc_nsamp_odors=ii_dropc_nsamp_odors+1;
                                dropc_nsamp_odors(ii_dropc_nsamp_odors)=odorNo;
                            end
                        end
                    end
                    
                    if found_odor==0
                        %This is odor 4?
                        %If there are at least 2 sec left this is indeed
                        %odor 4
                        first_four_ii=find(shiftdat==4,1,'first');
                        if ((length(shiftdat)-first_four_ii)/handles.draq_p.ActualRate)>=1.99
                            ii_dropc_nsamp_odors=ii_dropc_nsamp_odors+1;
                            dropc_nsamp_odors(ii_dropc_nsamp_odors)=4;
                            dropc_nsamp_odorNo(trialNo)=4;
                            exclude_trial(trialNo)=0;
                            odor_ii(trialNo)=first_four_ii+1*handles.draq_p.ActualRate;
                        else
                            exclude_trial(trialNo)=1;
                        end
                    end
                    
                else
                    %This may be a phantom odor, or a trial to be discarded
                    if first_not_zero==16
                        %Phantom odor
                        exclude_trial(trialNo)=0;
                        dropc_nsamp_odorNo(trialNo)=-1;
                    else
                        %Exclude this trial
                        exclude_trial(trialNo)=1;
                    end
                end
                
                
                
                
            else
                %Exclude this trial
                exclude_trial(trialNo)=1;
            end
            
            %             figure(1)
            %             plot(shiftdat)
            %             pffft=1
        end
        dropc_nsamp_odors=sort(dropc_nsamp_odors);
        
        for jj=1:length(dropc_nsamp_odors)
            handles.draq_d.nEventTypes=handles.draq_d.nEventTypes+1;
            handles.draq_d.eventlabels{handles.draq_d.nEventTypes}=['Odor' num2str(dropc_nsamp_odors(jj))];
        end
        
        handles.draq_d.nEventTypes=handles.draq_d.nEventTypes+1;
        handles.draq_d.eventlabels{handles.draq_d.nEventTypes}='Phantom';
        
        
        handles.draq_d.nEvPerType=zeros(1,handles.draq_d.nEventTypes);
        
        
        pffft=1
        
    case {2,13}
        %dropcspm, dropcspm_hf
        handles.draq_d.nEvPerType=zeros(1,17);
        handles.draq_d.nEventTypes=17;
        handles.draq_d.eventlabels=cell(1,17);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='Hit';
        handles.draq_d.eventlabels{4}='HitE';
        handles.draq_d.eventlabels{5}='S+';
        handles.draq_d.eventlabels{6}='S+E';
        handles.draq_d.eventlabels{7}='Miss';
        handles.draq_d.eventlabels{8}='MissE';
        handles.draq_d.eventlabels{9}='CR';
        handles.draq_d.eventlabels{10}='CRE';
        handles.draq_d.eventlabels{11}='S-';
        handles.draq_d.eventlabels{12}='S-E';
        handles.draq_d.eventlabels{13}='FA';
        handles.draq_d.eventlabels{14}='FAE';
        handles.draq_d.eventlabels{15}='Reinf';
        handles.draq_d.eventlabels{16}='Short';
        handles.draq_d.eventlabels{17}='Inter';
        
    case(3)
        %background
        handles.draq_d.nEvPerType=zeros(1,9);
        handles.draq_d.nEventTypes=9;
        handles.draq_d.eventlabels=cell(1,9);
        handles.draq_d.eventlabels{1}='OdorA';
        handles.draq_d.eventlabels{2}='OdorB';
        handles.draq_d.eventlabels{3}='OdorAB';
        handles.draq_d.eventlabels{4}='BkgA';
        handles.draq_d.eventlabels{5}='BkgB';
        handles.draq_d.eventlabels{6}='OdorBBkgA';
        handles.draq_d.eventlabels{7}='OdorABkgB';
        handles.draq_d.eventlabels{8}='OdorBBkgB';
        handles.draq_d.eventlabels{9}='OdorABkgA';
    case(4)
        %spmult
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spmult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_spmult_odors=str2num(answer{1});
        handles.draq_d.nsp_odors = num_spmult_odors;
        
        handles.draq_d.nEvPerType=zeros(1,9+num_spmult_odors*3);
        handles.draq_d.nEventTypes=9+num_spmult_odors*3;
        handles.draq_d.eventlabels=cell(1,9+num_spmult_odors*3);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='CR';
        handles.draq_d.eventlabels{4}='S-';
        handles.draq_d.eventlabels{5}='FA';
        handles.draq_d.eventlabels{6}='Reinf';
        handles.draq_d.eventlabels{7}='S+';
        handles.draq_d.eventlabels{8}='Hit';
        handles.draq_d.eventlabels{9}='Miss';
        
        for odNum=1:num_spmult_odors
            handles.draq_d.eventlabels{9+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            handles.draq_d.eventlabels{9+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            handles.draq_d.eventlabels{9+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
    case (5)
        %mspy
        [FileName,PathName] = uigetfile('*.*','Enter location of keys.dat file');
        fullName=[PathName,FileName];
        fid=fopen(fullName);
        sec_post_trigger=textscan(fid,'%d',1);
        num_keys=textscan(fid,'%d',1);
        key_names=textscan(fid,'%s',num_keys{1});
        fclose(fid)
        for ii=1:num_keys{1}
            handles.draq_d.eventlabels{ii}=key_names{1}(ii);
        end
        handles.draq_d.nEvPerType=zeros(1,num_keys{1});
        handles.draq_d.nEventTypes=num_keys{1};
    case (6)
        %osampler
        prompt = {'Enter the number of odors used:'};
        dlg_title = 'Input for osampler';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_spmult_odors=str2num(answer{1});
        handles.draq_d.nsp_odors = num_spmult_odors;
        
        handles.draq_d.nEvPerType=zeros(1,5+num_spmult_odors*3);
        handles.draq_d.nEventTypes=5+num_spmult_odors*3;
        handles.draq_d.eventlabels=cell(1,5+num_spmult_odors*3);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='Reinf';
        handles.draq_d.eventlabels{4}='Hit';
        handles.draq_d.eventlabels{5}='Miss';
        
        for odNum=1:num_spmult_odors
            handles.draq_d.eventlabels{5+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            handles.draq_d.eventlabels{5+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            handles.draq_d.eventlabels{5+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
        
    case(7)
        %spm2mult
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_splus_odors=str2num(answer{1});
        handles.draq_d.nsp_odors = num_splus_odors;
        
        prompt = {'Enter the number of odors used as S-:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_sminus_odors=str2num(answer{1});
        
        num_spmult_odors=num_sminus_odors+num_splus_odors;
        
        handles.draq_d.nEvPerType=zeros(1,3+num_spmult_odors*3);
        handles.draq_d.nEventTypes=3+num_spmult_odors*3;
        handles.draq_d.eventlabels=cell(1,3+num_spmult_odors*3);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='Reinf';
        
        for odNum=1:num_splus_odors
            handles.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            handles.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            handles.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
        
        for odNum=num_splus_odors+1:num_spmult_odors
            handles.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S-'];
            handles.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-CR'];
            handles.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-FA'];
        end
        
    case(8)
        %lighton1
        handles.draq_d.nEvPerType=zeros(1,2);
        handles.draq_d.nEventTypes=2;
        handles.draq_d.eventlabels=cell(1,2);
        
        handles.draq_d.eventlabels{1}='LightOn';
        handles.draq_d.eventlabels{2}='LightOn';
        
    case (9)
        %lighton5
        handles.draq_d.nEvPerType=zeros(1,7);
        handles.draq_d.nEventTypes=7;
        handles.draq_d.eventlabels=cell(1,7);
        
        handles.draq_d.eventlabels{1}='LightOn';
        handles.draq_d.eventlabels{2}='LightOn';
        handles.draq_d.eventlabels{3}='10';
        handles.draq_d.eventlabels{4}='30';
        handles.draq_d.eventlabels{5}='60';
        handles.draq_d.eventlabels{6}='100';
        handles.draq_d.eventlabels{7}='200';
        
    case (10)
        %dropcspm_conc
        handles.draq_d.nEvPerType=zeros(1,23);
        handles.draq_d.nEventTypes=23;
        handles.draq_d.eventlabels=cell(1,23);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='Hit';
        handles.draq_d.eventlabels{4}='HitE';
        handles.draq_d.eventlabels{5}='S+';
        handles.draq_d.eventlabels{6}='S+E';
        handles.draq_d.eventlabels{7}='Miss';
        handles.draq_d.eventlabels{8}='MissE';
        handles.draq_d.eventlabels{9}='CR';
        handles.draq_d.eventlabels{10}='CRE';
        handles.draq_d.eventlabels{11}='S-';
        handles.draq_d.eventlabels{12}='S-E';
        handles.draq_d.eventlabels{13}='FA';
        handles.draq_d.eventlabels{14}='FAE';
        handles.draq_d.eventlabels{15}='Reinf';
        handles.draq_d.eventlabels{16}='Hi Od1'; %Highest concentration
        handles.draq_d.eventlabels{17}='Hi Od2';
        handles.draq_d.eventlabels{18}='Hi Od3';
        handles.draq_d.eventlabels{19}='Low Od4';
        handles.draq_d.eventlabels{20}='Low Od5';
        handles.draq_d.eventlabels{21}='Low Od6'; %Lowest concentration
        handles.draq_d.eventlabels{22}='Short';
        handles.draq_d.eventlabels{23}='Inter';
    case (11)
        %Ming laser
        handles.draq_d.nEvPerType=zeros(1,3);
        handles.draq_d.nEventTypes=3;
        handles.draq_d.eventlabels=cell(1,3);
        handles.draq_d.eventlabels{1}='Laser';
        handles.draq_d.eventlabels{2}='All';
        handles.draq_d.eventlabels{3}='Inter';
    case (12)
        %Merouann laser
        handles.draq_d.nEvPerType=zeros(1,3);
        handles.draq_d.nEventTypes=3;
        handles.draq_d.eventlabels=cell(1,3);
        handles.draq_d.eventlabels{1}='Laser';
        handles.draq_d.eventlabels{2}='All';
        handles.draq_d.eventlabels{3}='Inter';
        
    case {14}
        %Working memory
        handles.draq_d.nEvPerType=zeros(1,15);
        handles.draq_d.nEventTypes=15;
        handles.draq_d.eventlabels=cell(1,15);
        handles.draq_d.eventlabels{1}='TStart';
        handles.draq_d.eventlabels{2}='OdorOn';
        handles.draq_d.eventlabels{3}='NM_Hit';
        handles.draq_d.eventlabels{4}='AB';
        handles.draq_d.eventlabels{5}='NonMatch';
        handles.draq_d.eventlabels{6}='BA';
        handles.draq_d.eventlabels{7}='NM_Miss';
        handles.draq_d.eventlabels{8}='Blank';
        handles.draq_d.eventlabels{9}='M_CR';
        handles.draq_d.eventlabels{10}='AA';
        handles.draq_d.eventlabels{11}='Match';
        handles.draq_d.eventlabels{12}='BB';
        handles.draq_d.eventlabels{13}='M_FA';
        handles.draq_d.eventlabels{14}='Blank';
        handles.draq_d.eventlabels{15}='Reinf';
        
    case(15)
        %Continuous
        handles.draq_d.nEventTypes=2;
        handles.draq_d.nEvPerType=zeros(1,2);
        handles.draq_d.eventlabels=[];
        handles.draq_d.eventlabels{1}='Event1';
        handles.draq_d.eventlabels{2}='Event1';
        
end



% find events, determine the type, and assign event labels
% store event information in handles.draq_d in the arrays eventlabels (key
% for converting event string to event number), events (time stamps for
% events) and eventType (numeric event numbers corresponding to event time
% stamps)

empty_new_block=0;
empty_t_start=0;


showBits=0;

if generate_dio_bits==1
    %For digging out data
    sniffs=zeros(216000,100);
    dio_bits=zeros(216000,100);
end

%Now get the events
% reset_ii=0;

all_licks=[];
for trialNo=1:handles.draq_d.noTrials
    handles.p.trialNo=trialNo;
    data=drtaGetTraceData(handles);
    if trialNo==1
        all_licks=data(:,19)';
    else
        all_licks=[all_licks data(:,19)'];
    end
end
lick_max=prctile(all_licks,99.9);
lick_min=prctile(all_licks,0.01);
lick_thr=lick_min+0.5*(lick_max-lick_min);

for trialNo=1:handles.draq_d.noTrials
    if ~isfield(handles,'drtachoices')
        trialNo
    end
    tic
    
    handles.p.trialNo=trialNo;
    [data]=drtaGetTraceData(handles);
    
    
    %For digging out data
    sniffs(:,trialNo)=data(:,1);
    dio_bits(:,trialNo)=data(:,3);
    
    if handles.draq_p.dgordra==1
        %This is a dra file
        datavec=data(:,handles.draq_p.no_spike_ch);
        shiftdata=bitshift( bitand(datavec,248), -2);
    else
        %These are dg or rhd files
        digi = data(:,handles.draq_p.no_chans);
        
        shiftdata=bitand(digi,2+4+8+16);
        shiftdatablock=bitand(digi,1+2+4+8+16);
        %shiftdatans=bitand(digi,1+2+4+8);
        shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
        %shift_dropc_nsampler=shiftdata(shift_dropc_nsampler<63);
        
    end
    
    
    shiftdata30=shiftdata;
    shiftdata(1:int64(handles.draq_p.ActualRate*handles.p.exclude_secs))=0;
    shift_dropc_nsampler(1:int64(handles.draq_p.ActualRate*handles.p.exclude_secs))=0;
    
    licks=[];
    licks=data(:,19);
    
    %Exclude the trials that are off
    switch handles.p.which_c_program
        
        case (1)
            %dropcnsampler
            if exclude_trial(trialNo)==1
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
            end
            
            try
                timeBefore=str2double(get(handles.timeBeforeFV,'String'));
            catch
                timeBefore=handles.time_before_FV;
            end
            firstFV=(find(shift_dropc_nsampler>0,1,'first')/handles.draq_p.ActualRate);
            
            if firstFV<timeBefore
                exclude_trial(trialNo)=1;
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
            end
            
            firstFVii=find(shift_dropc_nsampler>0,1,'first');
            pointsleft=length(shiftdata)-(firstFVii+3*handles.draq_p.ActualRate);
            
            if(pointsleft<1)
                exclude_trial(trialNo)=1;
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
            end
            
            
        case {2,13}
            %             %dropcspm
            %             timeBefore=str2double(get(handles.timeBeforeFV,'String'));
            %             firstFV=find(shiftdata30==6,1,'first')/handles.draq_p.ActualRate;
            %
            %             if firstFV<timeBefore
            %                 handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
            %                 handles.p.trial_allch_processed(trialNo)=0;
            %             end
            %
            %             this_odor_on=find(shiftdata==18,1,'first');
            %             pointsleft=216000-(this_odor_on+3*handles.draq_p.ActualRate);
            %
            %             if(pointsleft<1)
            %                 handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
            %                 handles.p.trial_allch_processed(trialNo)=0;
            %             end
            
        case (3)
            %background
            
        case (4)
            %spmult
            
        case (5)
            %mspy
            
        case (6)
            %osampler
            
        case (7)
            %ospm2mult
            
        case {8,9}
            %lighton one pulse
            %lighton five pulses
            
            digidata=data(:,21);
            
            %This is a bit safer way to get min and max
            minmin_y=min(digidata);
            maxmax_y=max(digidata);
            max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
            min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));
            
            if (max_y-min_y)>200
                timeBefore=str2double(get(handles.timeBeforeFV,'String'));
                firstLightOn=find(digidata>(min_y+(max_y-min_y)/2),1,'first')/handles.draq_p.ActualRate;
                if firstLightOn<timeBefore
                    handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                    handles.p.trial_allch_processed(trialNo)=0;
                end
            else
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
            end
            
        case (10)
            %dropcspm_conc
            %I fixed the problems in drta_read_Intan_RHD2000_header, this should be OK
            
            %             timeBefore=str2double(get(handles.timeBeforeFV,'String'));
            %             firstFV=find(shift_dropc_nsampler==1,1,'first')/handles.draq_p.ActualRate;
            %
            %             if firstFV<timeBefore
            %                 handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
            %                 handles.p.trial_allch_processed(trialNo)=0;
            %             end
            %
            %             this_odor_on=find(shift_dropc_nsampler>1,1,'first');
            %             pointsleft=216000-(this_odor_on+3*handles.draq_p.ActualRate);
            %
            %             if(pointsleft<1)
            %                 handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
            %                 handles.p.trial_allch_processed(trialNo)=0;
            %                 trialNo
            %                 pointsleft
            %             end
        case (11)
            %Ming laser
        case (12)
            %Merouann laser
    end
    
    
    
    
    
    %Enter events
    switch (handles.p.which_c_program)
        
        case (1)
            %dropcnsampler
            
            if exclude_trial(trialNo)~=1
                
                
                %Is this phantom?
                if dropc_nsamp_odorNo(trialNo)==-1
                    %Yes, phantom
                    first_phantom_ii=find(shift_dropc_nsampler==16,1,'first');
                    
                    %Phantom final valve
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(first_phantom_ii/handles.draq_p.ActualRate)-1);
                    handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                    handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    
                    %Phantom odorOn
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(first_phantom_ii/handles.draq_p.ActualRate));
                    handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                    handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    
                    %Phantom odor
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(first_phantom_ii/handles.draq_p.ActualRate));
                    handles.draq_d.eventType(handles.draq_d.noEvents)=handles.draq_d.nEventTypes;
                    handles.draq_d.nEvPerType(handles.draq_d.nEventTypes)=handles.draq_d.nEvPerType(handles.draq_d.nEventTypes)+1;
                    
                else
                    %This is an odor
                     
                    %Final valve
                    first_FV_ii=find(shift_dropc_nsampler==4,1,'first');
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(first_FV_ii/handles.draq_p.ActualRate)-1);
                    handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                    handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    
                    %Phantom odorOn
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(odor_ii(trialNo)/handles.draq_p.ActualRate));
                    handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                    handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    
                    %odor
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=(handles.draq_d.t_trial(trialNo)+(odor_ii(trialNo)/handles.draq_p.ActualRate));
                    handles.draq_d.eventType(handles.draq_d.noEvents)=find(dropc_nsamp_odors==dropc_nsamp_odorNo(trialNo))+2;
                    handles.draq_d.nEvPerType(find(dropc_nsamp_odorNo(trialNo))+2)=handles.draq_d.nEvPerType(find(dropc_nsamp_odorNo(trialNo))+2)+1;
                    
                end
                
            end
        case (2)
            %dropcspm
            %All the labels without the "E" suffix are assigned the time at
            %odor on
            
            %             figure(1)
            %             plot(shiftdata)
            
            start_ii=(handles.draq_p.sec_before_trigger-6)*handles.draq_p.ActualRate+1;
            end_ii=(handles.draq_p.sec_before_trigger+2)*handles.draq_p.ActualRate;
            
            if ~isempty(find(shiftdata>=1,1,'first'))
                
                if sum(shiftdata(start_ii:end_ii)>=1)<3*handles.draq_p.ActualRate
                    %This is a short
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    t_start=find(shiftdata(start_ii:end_ii)>=1,1,'first')+start_ii;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=16;
                    handles.draq_d.nEvPerType(16)=handles.draq_d.nEvPerType(16)+1;
                else
                    %Find trial start time (event 1)
                    %Note: This is the same as FINAL_VALVE
                    if sum(shiftdata(start_ii:end_ii)==6)>0.5*handles.draq_p.ActualRate
                        t_start=find(shiftdata(start_ii:end_ii)==6,1,'first')+start_ii;
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                        handles.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                        
                    end
                    
                    %Find odor on (event 2)
                    found_Hit=sum(shiftdata==8)>0.05*handles.draq_p.ActualRate;
                    found_Miss=sum(shiftdata==10)>0.05*handles.draq_p.ActualRate;
                    found_CR=sum(shiftdata==12)>0.05*handles.draq_p.ActualRate;
                    found_FA=sum(shiftdata==14)>0.05*handles.draq_p.ActualRate;
                    foundEvent=found_Hit||found_Miss||found_CR||found_FA;
                    
                    found_odor_on=0;
                    if (sum(shiftdata(t_start:end_ii)==18)>2.4*handles.draq_p.ActualRate)&foundEvent...
                            &~isempty(find((shiftdata(t_start:end_ii)==18)))                    %Very important: each odor On has to have an event
                        
                        odor_on=t_start+find(shiftdata(t_start:end)==18,1,'first');
                        found_odor_on=1;
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                        handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                        handles.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                        %                         handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=17;   %Add it as an inter
                        handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    end
                    
                    
                    %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                    %(event 6)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==8)>0.05*handles.draq_p.ActualRate
                        hits=t_start+find(shiftdata(t_start:end)==8,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                            fv=shiftvec==6;
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                        end
                        
                        %Hit (event 3)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                            handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                        end
                        
                        %HitE (event 4)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                        handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                        
                        %S+ (event 5)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                            handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                            
                        end
                        
                        %S+E (event 6)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                        
                    end
                    
                    %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                    %(event 6)
                    
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==10)>0.05*handles.draq_p.ActualRate
                        miss=t_start+find(shiftdata(t_start:end)==10,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                            fv=shiftvec==6;
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                        end
                        
                        %Miss (event 7)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                            handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                        end
                        
                        %MissE
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=8;
                        handles.draq_d.nEvPerType(8)=handles.draq_d.nEvPerType(8)+1;
                        
                        %S+ (event 5)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                            handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                            
                        end
                        
                        %S+E (event 6)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                        
                    end
                    
                    %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                    %(event 12)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==12)>0.05*handles.draq_p.ActualRate
                        crej=t_start+find(shiftdata(t_start:end)==12,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                        end
                        
                        %CR (event 9)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=9;
                            handles.draq_d.nEvPerType(9)=handles.draq_d.nEvPerType(9)+1;
                        end
                        
                        %CRE (event 10)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=10;
                        handles.draq_d.nEvPerType(10)=handles.draq_d.nEvPerType(10)+1;
                        
                        %S- (event 11)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                            handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                            
                        end
                        
                        %S-E (event 12)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                        handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                        
                    end
                    
                    %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                    %(event 12)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==14)>0.05*handles.draq_p.ActualRate
                        false_alarm=t_start+find(shiftdata(t_start:end)==14,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                        end
                        
                        %FA (event 13)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=13;
                            handles.draq_d.nEvPerType(13)=handles.draq_d.nEvPerType(13)+1;
                        end
                        
                        %FAE
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=14;
                        handles.draq_d.nEvPerType(14)=handles.draq_d.nEvPerType(14)+1;
                        
                        %S- (event 11)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                            handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                            
                        end
                        
                        %S-E (event 12)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                        handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                    end
                    
                    %Find reinforcement (event 15)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==16)>0.02*handles.draq_p.ActualRate
                        reinf=t_start+find(shiftdata(t_start:end)==16,1,'first');
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=15;
                        handles.draq_d.nEvPerType(15)=handles.draq_d.nEvPerType(15)+1;
                    end
                    
                    %                     %Find new block
                    %                     blockNoIndx=find(shiftdatablock>19,1,'first');
                    %                     if ~isempty(blockNoIndx)
                    %                         if ~isempty(t_start)
                    %                             %block_per_index=block_per_index+1;
                    %                             handles.draq_d.block_per_trial(trialNo)=(shiftdata(blockNoIndx)-18)/2;
                    %                         end
                    %                     else
                    %                         empty_new_block=empty_new_block+1
                    %                     end
                    
                    
                    handles.draq_d.block_per_trial(trialNo)=floor((trialNo-1)/20)+1;
                    
                    
                    
                end
            else
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+(length(shiftdata)/3)/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=17;
                handles.draq_d.nEvPerType(17)=handles.draq_d.nEvPerType(17)+1;
            end
            
            
        case (3)
            %backgound
            for ii=2:2:18
                t_start=find(shiftdata==ii,1,'first');
                if ~isempty(t_start)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=ii/2;
                    handles.draq_d.nEvPerType(ii/2)=handles.draq_d.nEvPerType(ii/2)+1;
                end
            end
            
        case (4)
            %spmult
            
            %Find trial start time (event 1)
            %Note: This is the same as FINAL_VALVE
            t_start=find(shiftdata==6,1,'first');
            if ~isempty(t_start)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            end
            
            %Find odor on (event 2)
            odor_on=find(shiftdata==18,1,'first');
            found_odor_on=0;
            if ~isempty(odor_on)
                found_odor_on=1;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(2)+1;
            end
            
            %Find Hit and S+
            hits=find(shiftdata==8,1,'first');
            if ~isempty(hits)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Hit (event number 8 and number 9+3*(odNum-1)+2)
                if (found_odor_on==1)
                    % add a Hit event (event 8)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=8;
                    handles.draq_d.nEvPerType(8)=handles.draq_d.nEvPerType(8)+1;
                    % add an OdorNoX-Hit event (event 9+3*(odNum-1)+2)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=9+3*(odNum-1)+2;
                    handles.draq_d.nEvPerType(9+3*(odNum-1)+2)=handles.draq_d.nEvPerType(9+3*(odNum-1)+2)+1;
                end
                
                %S+ (event 7 and event 9+3*(odNum-1)+1)
                if (found_odor_on==1)
                    % add an S+ event (event 7)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                    handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                    % add an OdorX-S+ event for this odor (event 9+3*(odNum-1)+1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=9+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(9+3*(odNum-1)+1)=handles.draq_d.nEvPerType(9+3*(odNum-1)+1)+1;
                end
                
            end
            
            %Find Miss and S+
            
            miss=find(shiftdata==10,1,'first');
            if ~isempty(miss)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Miss (event 9+3*(odNum-1)+3)
                if (found_odor_on==1)
                    % add a miss (event 9)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=9;
                    handles.draq_d.nEvPerType(9)=handles.draq_d.nEvPerType(9)+1;
                    % add an OdorNoX-Miss event (event number 9+3*(odNum-1)+3)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=9+3*(odNum-1)+3;
                    handles.draq_d.nEvPerType(9+3*(odNum-1)+3)=handles.draq_d.nEvPerType(9+3*(odNum-1)+3)+1;
                end
                
                %S+ (event 7 and event 9+3*(odNum-1)+1)
                if (found_odor_on==1)
                    % add an S+ event (event 7)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                    handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                    % add an OdorX-S+ event (event number 9+3*(odNum-1)+1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=9+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(9+3*(odNum-1)+1)=handles.draq_d.nEvPerType(9+3*(odNum-1)+1)+1;
                end
                
                
            end
            
            %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
            %(event 12)
            crej=find(shiftdata==12,1,'first');
            if ~isempty(crej)
                
                %CR (event 3)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                    handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                end
                
                %S- (event 4)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                    handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                end
                
            end
            
            %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
            %(event 12)
            false_alarm=find(shiftdata==14,1,'first');
            if ~isempty(false_alarm)
                
                %FA (event 5)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                    handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                end
                
                %S- (event 4)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                    handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                end
                
                
            end
            
            %Find reinforcement (event 6)
            reinf=find(shiftdata==16,1,'first');
            if ~isempty(reinf)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
            end
            
            %             %Find new block (event 10)
            %
            %             new_block=find(shiftdata>19,1,'first');
            %             if ~isempty(new_block)
            %                if ~isempty(t_start)
            %                 block_per_index=block_per_index+1;
            %                 trial_start_time(block_per_index)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
            %                 block_per_trial(block_per_index)=(shiftdata(new_block)-18)/2;
            %                end
            %             else
            %                 empty_new_block=empty_new_block+1
            %             end
            
            
            
        case(5)
            
            current_ii=1;
            last_event=-10000000;
            while current_ii<length(shiftdata)
                event=find(shiftdata(current_ii:length(shiftdata))>=2+handles.p.mspy_key_offset,1,'first');
                if ~isempty(event)
                    if current_ii+event-1-last_event>handles.p.mspy_key_offset*handles.draq_p.ActualRate
                        eventNo=(shiftdata(current_ii+event-1)-handles.p.mspy_key_offset)/2;
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+event/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=eventNo;
                        handles.draq_d.nEvPerType(eventNo)=handles.draq_d.nEvPerType(eventNo)+1;
                        last_evType=eventNo
                    else
                        eventNo=(shiftdata(current_ii+event-1)-handles.p.mspy_key_offset)/2;
                        if eventNo~=last_evType
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+event/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=eventNo;
                            handles.draq_d.nEvPerType(eventNo)=handles.draq_d.nEvPerType(eventNo)+1;
                            last_evType=eventNo
                        end
                    end
                    event=find(shiftdata(current_ii:length(shiftdata))==shiftdata(current_ii+event-1),1,'last');
                    current_ii=current_ii+event;
                    last_event=current_ii;
                    
                else
                    current_ii=length(shiftdata);
                end
                
            end
            
        case (6)
            %osampler
            
            %Find trial start time (event 1)
            %Note: This is the same as FINAL_VALVE
            t_start=find(shiftdata==6,1,'first');
            if ~isempty(t_start)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            end
            
            %Find OdorOn (event 2)
            
            odor_on=find(shiftdata==18,1,'first');
            found_odor_on=0;
            if ~isempty(odor_on)
                found_odor_on=1;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(2)+1;
            end
            
            %Find Hit and S+
            hits=find(shiftdata==8,1,'first');
            if ~isempty(hits)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Hit (event 4 and event 5+3*(odNum-1)+2)
                if (found_odor_on==1)
                    % add a Hit event
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                    handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                    % add a OdorX-Hit event
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5+3*(odNum-1)+2;
                    handles.draq_d.nEvPerType(5+3*(odNum-1)+2)=handles.draq_d.nEvPerType(5+3*(odNum-1)+2)+1;
                end
                
                %S+ (This finds S+ for a specific odor, OdorX-S+, event 5+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(5+3*(odNum-1)+1)=handles.draq_d.nEvPerType(5+3*(odNum-1)+1)+1;
                end
                
            end
            
            %Find Miss and S+
            
            miss=find(shiftdata==10,1,'first');
            if ~isempty(miss)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Miss (event 5 and event 5+3*(odNum-1)+3)
                if (found_odor_on==1)
                    % add a Miss event
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                    handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                    % add an OdorX-Miss event
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5+3*(odNum-1)+3;
                    handles.draq_d.nEvPerType(5+3*(odNum-1)+3)=handles.draq_d.nEvPerType(5+3*(odNum-1)+3)+1;
                end
                
                %S+ (This finds S+ for a specific odor, OdorX-S+, event 5+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(5+3*(odNum-1)+1)=handles.draq_d.nEvPerType(5+3*(odNum-1)+1)+1;
                end
                
                
            end
            
            %Find reinforcement (event 6)
            reinf=find(shiftdata==16,1,'first');
            if ~isempty(reinf)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
            end
            
        case (7)
            %spm2mult
            
            %Find trial start time (event 1)
            %Note: This is the same as FINAL_VALVE
            t_start=find(shiftdata==6,1,'first');
            if ~isempty(t_start)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            end
            
            %Find odor on (event 2)
            odor_on=find(shiftdata==18,1,'first');
            found_odor_on=0;
            if ~isempty(odor_on)
                found_odor_on=1;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            else
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(2)+1;
            end
            
            %Find Hit and S+
            hits=find(shiftdata==8,1,'first');
            if ~isempty(hits)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Hit (event 3+3*(odNum-1)+2)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+2;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+2)=handles.draq_d.nEvPerType(3+3*(odNum-1)+2)+1;
                end
                
                %S+ (event 3+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+1)=handles.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
                end
                
            end
            
            %Find Miss and S+
            
            miss=find(shiftdata==10,1,'first');
            if ~isempty(miss)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %Miss (event 3+3*(odNum-1)+3)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+3;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+3)=handles.draq_d.nEvPerType(3+3*(odNum-1)+3)+1;
                end
                
                %S+ (event 3+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+1)=handles.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
                end
                
                
            end
            
            %Find CR and S-
            
            crej=find(shiftdata==12,1,'first');
            if ~isempty(crej)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %CR (event 3+3*(odNum-1)+2)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+2;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+2)=handles.draq_d.nEvPerType(3+3*(odNum-1)+2)+1;
                end
                
                %S- (event 3+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+1)=handles.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
                end
                
                
            end
            
            %Find FA and S-
            false_alarm=find(shiftdata==14,1,'first');
            if ~isempty(false_alarm)
                
                %Determine the odor number
                for ii=20:2:64
                    t_odor=find(shiftdata==ii,1,'first');
                    if ~isempty(t_odor)
                        odNum=(ii-18)/2;
                        break;
                    end
                end
                
                %FA (event 3+3*(odNum-1)+3)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+3;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+3)=handles.draq_d.nEvPerType(3+3*(odNum-1)+3)+1;
                end
                
                %S- (event 3+3*(odNum-1)+1)
                if (found_odor_on==1)
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=3+3*(odNum-1)+1;
                    handles.draq_d.nEvPerType(3+3*(odNum-1)+1)=handles.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
                end
                
            end
            
            %Find reinforcement (event 3)
            reinf=find(shiftdata==16,1,'first');
            if ~isempty(reinf)
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
            end
            
        case (8)
            %lighton
            %21 digital input
            digidata=data(:,21);
            
            %This is a bit safer way to get min and max
            minmin_y=min(digidata);
            maxmax_y=max(digidata);
            max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
            min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));
            
            bad_trial=0;
            
            if (max_y-min_y)>200
                firstdig=find(digidata>min_y+0.5*(max_y-min_y),1,'first');
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                
                
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            else
                bad_trial=1;
            end  %if (max_y-min_y)>200
            
            if bad_trial==1
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            end
            
        case (9)
            %lighton
            %21 digital input
            digidata=data(:,21);
            
            %This is a bit safer way to get min and max
            minmin_y=min(digidata);
            maxmax_y=max(digidata);
            max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
            min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));
            
            bad_trial=0;
            
            if (max_y-min_y)>200
                
                %Find out how many pulses are here
                pulses_found=0;
                pulse_found=1;
                ii=1;
                while pulse_found==1
                    firstdig=find(digidata(ii:end)>min_y+0.5*(max_y-min_y),1,'first');
                    if ~isempty(firstdig)
                        %Found a pulse
                        pulses_found=pulses_found+1;
                        deltadig=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first');
                        deltat=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first')/handles.draq_p.ActualRate;
                        ii=ii+firstdig+deltadig;
                    else
                        pulse_found=0;
                    end
                end
                
                if pulses_found>=5
                    
                    firstdig=find(digidata>min_y+0.5*(max_y-min_y),1,'first');
                    %deltadig=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first');
                    deltat=find(digidata(firstdig:end)<min_y+0.5*(max_y-min_y),1,'first')/handles.draq_p.ActualRate;
                    
                    %The first two are odor on
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                    handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                    handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    
                    
                    if (deltat>0.005)&(deltat<0.015)
                        %10 msec
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                        handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                    end
                    
                    
                    
                    if (deltat>0.02)&(deltat<0.04)
                        %30 msec
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                        handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                    end
                    
                    if (deltat>0.05)&(deltat<0.07)
                        %60 msec
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                        handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                    end
                    
                    if (deltat>0.090)&(deltat<0.110)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                    end
                    
                    if (deltat>0.190)&(deltat<0.210)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+firstdig/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                        handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                    end
                    
                    
                end   %while pulse found==1
                
            else
                bad_trial=1;
            end  %if (max_y-min_y)>200
            
            if bad_trial==1
                %It is extremely important, every single trial must have an
                %accompanying t_start and odor_on
                
                %First exclude this weird trial
                handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                handles.p.trial_allch_processed(trialNo)=0;
                
                %Then add this one
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                
            end
            
        case (10)
            %dropcspm conc
            %All the labels without the "E" suffix are assigned the time at
            %odor on
            
            if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
                %This is an odor trial or a short
                
                if length(find(shift_dropc_nsampler>=1))<3*handles.draq_p.ActualRate
                    %This is a short
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    t_start=find(shift_dropc_nsampler>=1,1,'first');
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=22;
                    handles.draq_d.nEvPerType(22)=handles.draq_d.nEvPerType(22)+1;
                else
                    %Find trial start time (event 1)
                    %Note: This is the same as FINAL_VALVE
                    
                    
                    if sum(shift_dropc_nsampler==1)>0.9*handles.draq_p.ActualRate
                        t_start=find(shift_dropc_nsampler==1,1,'first');
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                        handles.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list as a short
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=22;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                        
                    end
                    
                    
                    if exist('t_start')~=0
                        %Find odor on (event 2)
                        found_odor_on=0;
                        %Note, odor on must be longer than 2.4 sec and must take place after final
                        %valve when shift_dropc_nsampler==1
                        if (sum((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7))>2.4*handles.draq_p.ActualRate)&...
                                ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                            %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                            odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
                            found_odor_on=1;
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                            handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                        else
                            %It is extremely important, every single trial must have an
                            %accompanying t_start followed by an odor_on
                            
                            %First exclude this weird trial
                            handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                            handles.p.trial_allch_processed(trialNo)=0;
                            
                            %Then add it to the list as a short
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=22;
                            handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                        end
                        
                        %Now do processing only if odor on was found
                        if (found_odor_on==1)
                            %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                            %(event 6)
                            
                            if sum(shift_dropc_nsampler==8)>0.05*handles.draq_p.ActualRate
                                hits=t_start+find(shift_dropc_nsampler(t_start:end)==8,1,'first');
                                if generate_dio_bits==1
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                    shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                                    fv=shiftvec==6;
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                                end
                                
                                %Hit (event 3)
                                
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                                handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                                
                                
                                %HitE (event 4)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                                handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                                
                                %S+ (event 5)
                                
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                                handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                                
                                
                                %S+E (event 6)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                                handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                                
                            end
                            
                            %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                            %(event 6)
                            
                            
                            if sum(shift_dropc_nsampler==10)>0.05*handles.draq_p.ActualRate
                                miss=t_start+find(shift_dropc_nsampler(t_start:end)==10,1,'first');
                                if generate_dio_bits==1
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                    shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                                    fv=shiftvec==6;
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                                end
                                
                                %Miss (event 7)
                                
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                                handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                                
                                
                                %MissE
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=8;
                                handles.draq_d.nEvPerType(8)=handles.draq_d.nEvPerType(8)+1;
                                
                                %S+ (event 5)
                                
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                                handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                                
                                
                                %S+E (event 6)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                                handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                                
                            end
                            
                            %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                            %(event 12)
                            
                            if sum(shift_dropc_nsampler==12)>0.05*handles.draq_p.ActualRate
                                crej=t_start+find(shift_dropc_nsampler(t_start:end)==12,1,'first');
                                if generate_dio_bits==1
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                end
                                
                                %CR (event 9)
                                
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=9;
                                handles.draq_d.nEvPerType(9)=handles.draq_d.nEvPerType(9)+1;
                                
                                
                                %CRE (event 10)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=10;
                                handles.draq_d.nEvPerType(10)=handles.draq_d.nEvPerType(10)+1;
                                
                                %S- (event 11)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                                handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                                
                                
                                %S-E (event 12)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                                handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                                
                            end
                            
                            %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                            %(event 12)
                            
                            if sum(shift_dropc_nsampler(t_start:end)==14)>0.05*handles.draq_p.ActualRate
                                false_alarm=t_start+find(shift_dropc_nsampler(t_start:end)==14,1,'first');
                                if generate_dio_bits==1
                                    dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                end
                                
                                %FA (event 13)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=13;
                                handles.draq_d.nEvPerType(13)=handles.draq_d.nEvPerType(13)+1;
                                
                                
                                %FAE
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=14;
                                handles.draq_d.nEvPerType(14)=handles.draq_d.nEvPerType(14)+1;
                                
                                %S- (event 11)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                                handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                                
                                %S-E (event 12)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                                handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                            end
                            
                            %Find reinforcement (event 15)
                            if sum(shift_dropc_nsampler==32)>0.02*handles.draq_p.ActualRate
                                reinf=t_start+find(shift_dropc_nsampler(t_start:end)==32,1,'first');
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                                handles.draq_d.eventType(handles.draq_d.noEvents)=15;
                                handles.draq_d.nEvPerType(15)=handles.draq_d.nEvPerType(15)+1;
                            end
                            
                            
                            %Find which odor concentration this is
                            this_odor=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first');
                            if ~isempty(this_odor)
                                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                                this_odor_evNo=shift_dropc_nsampler(this_odor);
                                handles.draq_d.eventType(handles.draq_d.noEvents)=15+this_odor_evNo-1;
                                handles.draq_d.nEvPerType(15+this_odor_evNo-1)=handles.draq_d.nEvPerType(15+this_odor_evNo-1)+1;
                            end
                        end
                        
                    else
                        %This is an intermediate trial
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=23;
                        handles.draq_d.nEvPerType(23)=handles.draq_d.nEvPerType(23)+1;
                    end
                end
                
                
                
            else
                %This is an intermediate trial
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=23;
                handles.draq_d.nEvPerType(23)=handles.draq_d.nEvPerType(23)+1;
            end
            
            % This code is here for troubleshooting
            %             figure(10)
            %             plot(shift_dropc_nsampler)
            %             pffft=1;
            
        case (11)
            %Ming laser
            
            if sum(data(:,21)>(handles.draq_d.min_laser+(handles.draq_d.max_laser-handles.draq_d.min_laser)/2))==0
                %This is an inter trial
                t_start=3*handles.draq_p.ActualRate;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                
            else
                %This is a laser trial
                k=find(data(ceil(2.5*handles.draq_p.ActualRate):end,21)>(handles.draq_d.min_laser+(handles.draq_d.max_laser-handles.draq_d.min_laser)/2),1,'first');
                t_start=ceil(2.5*handles.draq_p.ActualRate)+k-1;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            end
            
        case (12)
            %Merouann laser
            
            if sum(data(:,18)>(handles.draq_d.min_laser+(handles.draq_d.max_laser-handles.draq_d.min_laser)/2))==0
                %This is an inter trial
                t_start=3*handles.draq_p.ActualRate;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                
            else
                %This is a laser trial
                k=find(data(ceil(2.5*handles.draq_p.ActualRate):end,18)>(handles.draq_d.min_laser+(handles.draq_d.max_laser-handles.draq_d.min_laser)/2),1,'first');
                t_start=ceil(2.5*handles.draq_p.ActualRate)+k-1;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            end
            
            %Enter all trials
            t_start=3*handles.draq_p.ActualRate;
            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
            handles.draq_d.eventType(handles.draq_d.noEvents)=2;
            handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            
        case (13)
            %dropcspm_hf
            %All the labels without the "E" suffix are assigned the time at
            %odor on
            
            %             figure(1)
            %             plot(shiftdata)
            
            start_ii=(handles.draq_p.sec_before_trigger-7)*handles.draq_p.ActualRate+1;
            end_ii=(handles.draq_p.sec_before_trigger+3)*handles.draq_p.ActualRate;
            
            if ~isempty(find(shiftdata>=1,1,'first'))
                
                if sum(shiftdata(start_ii:end_ii)>=1)<2*handles.draq_p.ActualRate
                    %This is a short
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    t_start=find(shiftdata(start_ii:end_ii)>=1,1,'first')+start_ii;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=16;
                    handles.draq_d.nEvPerType(16)=handles.draq_d.nEvPerType(16)+1;
                else
                    %Find trial start time (event 1)
                    %Note: This is the same as FINAL_VALVE
                    if sum(shiftdata(start_ii:end_ii)==6)>0.5*handles.draq_p.ActualRate
                        t_start=find(shiftdata(start_ii:end_ii)==6,1,'first')+start_ii;
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                        handles.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                        handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                        
                    end
                    
                    %Find odor on (event 2)
                    found_Hit=sum(shiftdata==8)>0.05*handles.draq_p.ActualRate;
                    found_Miss=sum(shiftdata==10)>0.05*handles.draq_p.ActualRate;
                    found_CR=sum(shiftdata==12)>0.05*handles.draq_p.ActualRate;
                    found_FA=sum(shiftdata==14)>0.05*handles.draq_p.ActualRate;
                    found_Short=(sum(shiftdata==2)>0.05*handles.draq_p.ActualRate)||(sum(shiftdata==4)>0.05*handles.draq_p.ActualRate);
                    foundEvent=found_Hit||found_Miss||found_CR||found_FA||found_Short;
                    
                    found_odor_on=0;
                    %                     if (sum(shiftdata(t_start:end_ii)==18)>2.4*handles.draq_p.ActualRate)&foundEvent...
                    %                             &~isempty(find((shiftdata(t_start:end_ii)==18)))                    %Very important: each odor On has to have an event
                    %
                    if (sum(shiftdata(t_start:end_ii)==18)>2*handles.draq_p.ActualRate) %Note that I have relaxed this for _hf
                        odor_on=t_start+find(shiftdata(t_start:end)==18,1,'first');
                        found_odor_on=1;
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                        handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        handles.p.trial_ch_processed(1:16,trialNo)=zeros(16,1);
                        handles.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+2;
                        %                         handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=17;   %Add it as an inter
                        handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    end
                    
                    
                    %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                    %(event 6)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==8)>0.01*handles.draq_p.ActualRate
                        hits=t_start+find(shiftdata(t_start:end)==8,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                            fv=shiftvec==6;
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                        end
                        
                        %Hit (event 3)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                            handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                        end
                        
                        %HitE (event 4)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                        handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                        
                        %S+ (event 5)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                            handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                            
                        end
                        
                        %S+E (event 6)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+hits/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                        
                    end
                    
                    %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                    %(event 6)
                    
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==10)>0.01*handles.draq_p.ActualRate
                        miss=t_start+find(shiftdata(t_start:end)==10,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                            fv=shiftvec==6;
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                        end
                        
                        %Miss (event 7)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                            handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                        end
                        
                        %MissE
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=8;
                        handles.draq_d.nEvPerType(8)=handles.draq_d.nEvPerType(8)+1;
                        
                        %S+ (event 5)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                            handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                            
                        end
                        
                        %S+E (event 6)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+miss/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                        
                    end
                    
                    %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                    %(event 12)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==12)>0.01*handles.draq_p.ActualRate
                        crej=t_start+find(shiftdata(t_start:end)==12,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                        end
                        
                        %CR (event 9)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=9;
                            handles.draq_d.nEvPerType(9)=handles.draq_d.nEvPerType(9)+1;
                        end
                        
                        %CRE (event 10)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=10;
                        handles.draq_d.nEvPerType(10)=handles.draq_d.nEvPerType(10)+1;
                        
                        %S- (event 11)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                            handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                            
                        end
                        
                        %S-E (event 12)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+crej/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                        handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                        
                    end
                    
                    %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                    %(event 12)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==14)>0.01*handles.draq_p.ActualRate
                        false_alarm=t_start+find(shiftdata(t_start:end)==14,1,'first');
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                        end
                        
                        %FA (event 13)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=13;
                            handles.draq_d.nEvPerType(13)=handles.draq_d.nEvPerType(13)+1;
                        end
                        
                        %FAE
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=14;
                        handles.draq_d.nEvPerType(14)=handles.draq_d.nEvPerType(14)+1;
                        
                        %S- (event 11)
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                            handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                            
                        end
                        
                        %S-E (event 12)
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+false_alarm/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                        handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                    end
                    
                    %Find Short (events 2 and 4)
                    
                    if (sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==2)>0.01*handles.draq_p.ActualRate)||...
                            (sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==4)>0.01*handles.draq_p.ActualRate)
                        
                        
                        if generate_dio_bits==1
                            dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                        end
                        
                        %Short
                        if (found_odor_on==1)
                            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+odor_on/handles.draq_p.ActualRate;
                            handles.draq_d.eventType(handles.draq_d.noEvents)=16;
                            handles.draq_d.nEvPerType(13)=handles.draq_d.nEvPerType(16)+1;
                        end
                        
                        
                    end
                    
                    %Find reinforcement (event 15)
                    
                    if sum(shiftdata(t_start:t_start+6*handles.draq_p.ActualRate)==16)>0.01*handles.draq_p.ActualRate
                        reinf=t_start+find(shiftdata(t_start:end)==16,1,'first');
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+reinf/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=15;
                        handles.draq_d.nEvPerType(15)=handles.draq_d.nEvPerType(15)+1;
                    end
                    
                    %                     %Find new block
                    %                     blockNoIndx=find(shiftdatablock>19,1,'first');
                    %                     if ~isempty(blockNoIndx)
                    %                         if ~isempty(t_start)
                    %                             %block_per_index=block_per_index+1;
                    %                             handles.draq_d.block_per_trial(trialNo)=(shiftdata(blockNoIndx)-18)/2;
                    %                         end
                    %                     else
                    %                         empty_new_block=empty_new_block+1
                    %                     end
                    
                    
                    handles.draq_d.block_per_trial(trialNo)=floor((trialNo-1)/20)+1;
                    
                    
                    
                end
            else
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+(length(shiftdata)/3)/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=17;
                handles.draq_d.nEvPerType(17)=handles.draq_d.nEvPerType(17)+1;
            end
            
        case (14)
            %Working memory
            
            
            %             figure(1)
            %             plot(shift_dropc_nsampler)
            
            start_ii=1;
            end_ii=handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate;
            
            if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
                
                
                %Find trial start time (event 1)
                %Note: This is FINAL_VALVE
                
                t_start=find(shift_dropc_nsampler(start_ii:end_ii)==1,1,'first')+start_ii;
                handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
                handles.draq_d.eventType(handles.draq_d.noEvents)=1;
                handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
                
                
                %Find the first odor
                ii_first2=find(shift_dropc_nsampler(start_ii:end_ii)==2,1,'first');
                ii_first4=find(shift_dropc_nsampler(start_ii:end_ii)==4,1,'first');
                ii_reinf=find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first');
                
                %Find the odor on off times
                ii_odor1=find(shift_dropc_nsampler(start_ii:end_ii)>1,1,'first');
                delta_ii_odor1=find(shift_dropc_nsampler(start_ii+ii_odor1:end_ii)==0,1,'first');
                delta_ii_odor12=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1:end_ii)>0,1,'first');
                delta_ii_odor2=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1+delta_ii_odor12:end_ii)==0,1,'first');

                handles.draq_d.delta_ii_odor1(trialNo)=delta_ii_odor1;
                handles.draq_d.delta_ii_odor12(trialNo)=delta_ii_odor12;
                handles.draq_d.delta_ii_odor2(trialNo)=delta_ii_odor2;

                if (~isempty(ii_first2))&(~isempty(ii_first4))
                    %Non match
                    ii_odor_on=min([ii_first2 ii_first4]);
                    
                    %OdorOn
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                    handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    
                    %NonMatch
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=5;
                    handles.draq_d.nEvPerType(5)=handles.draq_d.nEvPerType(5)+1;
                    
                    
                    if ~isempty(find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first'))
                        %NonMatchHit
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=3;
                        handles.draq_d.nEvPerType(3)=handles.draq_d.nEvPerType(3)+1;
                    else
                        %NonMatchMiss
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=7;
                        handles.draq_d.nEvPerType(7)=handles.draq_d.nEvPerType(7)+1;
                    end
                    
                    if ii_first2<ii_first4
                        %AB
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=4;
                        handles.draq_d.nEvPerType(4)=handles.draq_d.nEvPerType(4)+1;
                    else
                        %BA
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=6;
                        handles.draq_d.nEvPerType(6)=handles.draq_d.nEvPerType(6)+1;
                    end
                else
                    if (~isempty(ii_first2))
                        ii_odor_on=ii_first2;
                    else
                        ii_odor_on=ii_first4;
                    end
                    
                    %OdorOn
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=2;
                    handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
                    
                    %Match
                    handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                    handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                    handles.draq_d.eventType(handles.draq_d.noEvents)=11;
                    handles.draq_d.nEvPerType(11)=handles.draq_d.nEvPerType(11)+1;
                    
                    %Did the animal lick
                    %Note: Here I assume the user entered 4 RAs with 0.5
                    %sec each
                    these_licks=zeros(1,4);
                    delta_RA=0.5*handles.draq_p.ActualRate;
                    this_ii=start_ii+ii_odor1+delta_ii_odor1+delta_ii_odor12+delta_ii_odor2-1;
                    for ii_RA=1:4
                        if sum(licks(this_ii:this_ii+delta_RA)>lick_thr)>0
                            these_licks(ii_RA)=1;
                        end
                        this_ii=this_ii+delta_RA;
                    end

                    if sum(these_licks)==4
                        licked=1;
                    else
                        licked=0;
                    end
                    
                    if licked==1
                        %MatchFA
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=13;
                        handles.draq_d.nEvPerType(13)=handles.draq_d.nEvPerType(13)+1;
                    else
                        %MatchCR
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=9;
                        handles.draq_d.nEvPerType(9)=handles.draq_d.nEvPerType(9)+1;
                    end
                    
                    if ~isempty(ii_first2)
                        %AA
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=10;
                        handles.draq_d.nEvPerType(10)=handles.draq_d.nEvPerType(10)+1;
                    else
                        %BB
                        handles.draq_d.noEvents=handles.draq_d.noEvents+1;
                        handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+ii_odor_on/handles.draq_p.ActualRate;
                        handles.draq_d.eventType(handles.draq_d.noEvents)=12;
                        handles.draq_d.nEvPerType(12)=handles.draq_d.nEvPerType(12)+1;
                    end
                    
                end
                
            end
            
        case (15)
            %Continuous
            
            
            %Event1
            t_start=(3+0.2)*handles.draq_p.ActualRate;  %Note: 0.2 is a time pad used for filtering
            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
            handles.draq_d.eventType(handles.draq_d.noEvents)=1;
            handles.draq_d.nEvPerType(1)=handles.draq_d.nEvPerType(1)+1;
            
            %Event2
            handles.draq_d.noEvents=handles.draq_d.noEvents+1;
            handles.draq_d.events(handles.draq_d.noEvents)=handles.draq_d.t_trial(trialNo)+t_start/handles.draq_p.ActualRate;
            handles.draq_d.eventType(handles.draq_d.noEvents)=2;
            handles.draq_d.nEvPerType(2)=handles.draq_d.nEvPerType(2)+1;
            
    end %switch
    if ~isfield(handles,'drtachoices')
        toc
    end
end %for


% Setup block numbers

switch handles.p.which_c_program
    
    case (1)
        %dropcnsampler
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (2)
        %dropcspm
        indxOdorOn=find(strcmp('OdorOn',handles.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(handles.draq_d.eventType==indxOdorOn);
        
        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        if numBlocks==0
           numBlocks=1; 
        end
        handles.draq_d.blocks=zeros(numBlocks,2);
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.001;
        handles.draq_d.blocks(numBlocks,2)=max(handles.draq_d.events)+0.001;
        
        for blockNo=2:numBlocks
            handles.draq_d.blocks(blockNo,1)=((handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            handles.draq_d.blocks(blockNo,2)=((handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end
    case (3)
        %background
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (4)
        %spmult
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (5)
        %nsampler
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (6)
        %osampler
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
        
    case (7)
        %spm2mult
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (8)
        %lighton1
        handles.draq_d.blocks(1,1)=handles.draq_d.t_trial(1)-9;
        handles.draq_d.blocks(1,2)=handles.draq_d.t_trial(end)+9;
    case (9)
        %lighton5
        handles.draq_d.blocks(1,1)=handles.draq_d.t_trial(1)-9;
        handles.draq_d.blocks(1,2)=handles.draq_d.t_trial(end)+9;
    case (10)
        %dropcspm_conc
        indxOdorOn=find(strcmp('OdorOn',handles.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(handles.draq_d.eventType==indxOdorOn);
        
        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        handles.draq_d.blocks=zeros(numBlocks,2);
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.001;
        handles.draq_d.blocks(numBlocks,2)=max(handles.draq_d.events)+0.001;
        
        for blockNo=2:numBlocks
            handles.draq_d.blocks(blockNo,1)=((handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            handles.draq_d.blocks(blockNo,2)=((handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end
    case (11)
        %Ming laser
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (12)
        %Merouann laser
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
    case (14)
        %dropcspm
        indxOdorOn=find(strcmp('OdorOn',handles.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(handles.draq_d.eventType==indxOdorOn);
        
        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        if numBlocks==0
            numBlocks=1;
        end
        handles.draq_d.blocks=zeros(numBlocks,2);
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.001;
        handles.draq_d.blocks(numBlocks,2)=max(handles.draq_d.events)+0.001;
        
        for blockNo=2:numBlocks
            handles.draq_d.blocks(blockNo,1)=((handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            handles.draq_d.blocks(blockNo,2)=((handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end


        fprintf(1, ['Delta odor 1 = %d sec \n'], mean(handles.draq_d.delta_ii_odor1)/handles.draq_p.ActualRate);
        fprintf(1, ['Delta odor 12 = %d sec \n'], mean(handles.draq_d.delta_ii_odor12)/handles.draq_p.ActualRate);
        fprintf(1, ['Delta odor 2 = %d sec \n'], mean(handles.draq_d.delta_ii_odor2)/handles.draq_p.ActualRate);
    case (15)
        %Continuous
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
end

try
    drta('setTrialNo',handles.w.drta,oldTrialNo);
catch
end

handles=drtaExcludeBadLFP(handles);

%Now update the .mat file
data=handles.draq_d;
if isfield(data,'data')
    data=rmfield(data,'data');
end
params=handles.draq_p;
drta_p=handles.p;

if handles.draq_p.dgordra==2
    %dg
    save([handles.p.fullName(1:end-2),'mat'],'data','params','drta_p');
else
    %dra or rhd
    save([handles.p.fullName(1:end-3),'mat'],'data','params','drta_p');
end

if isfield(handles,'drtachoices')
    fprintf(1, ['\nSaved .mat for ' handles.choicesFileName '\n\n']);
else
    switch handles.p.which_c_program
        
        case (1)
            %dropcnsampler
            msgbox('Saved .mat (dropcnsampler)');
        case (2)
            %splussminus
            msgbox('Saved .mat (dropcspm)');
        case (3)
            %background
            msgbox('Saved .mat (background)');
        case (4)
            %spmult
            msgbox('Saved .mat (spmult)');
        case (5)
            %mspy
            msgbox('Saved .mat (mspy)');
        case (6)
            %osampler
            msgbox('Saved .mat (osampler)');
        case (7)
            %ospm2mult
            msgbox('Saved .mat (spm2mult)');
        case (8)
            %lighton one pulse
            msgbox('Saved .mat (lighton1)');
        case (9)
            %lighton five pulses
            msgbox('Saved .mat (lighton5)');
        case (10)
            %dropcspm_conc
            msgbox('Saved .mat (dropcspm_conc)');
        case (11)
            %dropcspm_conc
            msgbox('Saved .mat (Ming laser)');
        case (12)
            %dropcspm_conc
            msgbox('Saved .mat (Merouann laser)');
        case (14)
            %dropcspm_conc
            msgbox('Saved .mat (Working Memory)');
        case (15)
            %dropcspm_conc
            msgbox('Saved .mat (Continuous)');
    end
end

%If the jt_times exists change the handles.draq_p and handles.p
%This is done so that variables generated by wave_clus are not overwritten

%Do this only if jt_times does exist

if handles.draq_p.dgordra==2
    %This is a dg file
    jt_times_file=[handles.p.PathName,'jt_times_',handles.p.FileName(1:end-2),'mat'];
else
    %dra or rhd
    jt_times_file=[handles.p.PathName,'jt_times_',handles.p.FileName(1:end-3),'mat'];
end

if isfield(handles,'drtachoices')
    %Note that drtaBatch overwrites the jt_times file
    cluster_class_per_file=[];
    offset_for_chan=[];
    noSpikes=0;
    all_timestamp_per_file=[];
    draq_p=handles.draq_p;
else
    %If drta is being run load jt_times_file
    try
        load(jt_times_file);
    catch
        cluster_class_per_file=[];
        offset_for_chan=[];
        noSpikes=0;
        all_timestamp_per_file=[];
        draq_p=handles.draq_p;
    end
end

par.doBehavior=0;

if isfield(drta_p,'tetr_processed')
    handles.p.tetr_processed=drta_p.tetr_processed;
end

drta_p=handles.p;


draq_d=handles.draq_d;
if isfield(draq_d,'data')
    draq_d=rmfield(draq_d,'data');
end

if exist('units_per_tet','var')
    if handles.p.which_c_program==8
        save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
    else
        
        if isfield(par,'doBehavior')
            if par.doBehavior==1
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','lickbit','dtime','units_per_tet');
            else
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
            end
        else
            save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
        end
        
    end
else
    if handles.p.which_c_program==8
        save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
    else
        
        if isfield(par,'doBehavior')
            if par.doBehavior==1
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','lickbit','dtime');
            else
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
            end
        else
            save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
        end
        
    end
end

if isfield(handles,'drtachoices')
    fprintf(1, ['\nSaved jt_times file for ' handles.choicesFileName '\n\n']);
else
    msgbox('Saved jt_times file');
end

handles.p.trialNo=oldTrialNo;




