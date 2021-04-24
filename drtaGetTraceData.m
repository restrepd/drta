% --- Executes on button press in drtaBrowseDraPush.
function [data_per_trial]=drtaGetTraceData(handles)
% hObject    handle to drtaBrowseDraPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Note: two bytes per sample (uint16)
switch handles.draq_p.dgordra
    case 1
        %This code for dra is old and likely does not work
        handles.p.fid=fopen(handles.p.fullName,'rb');
        trialNo=handles.p.trialNo;
        offset=handles.draq_p.no_spike_ch*2*(sum(handles.draq_d.samplesPerTrial(1:handles.p.trialNo))-handles.draq_d.samplesPerTrial(handles.p.trialNo));
        fseek(handles.p.fid,offset,'bof');
        data_vec=fread(handles.p.fid,handles.draq_p.no_spike_ch*handles.draq_d.samplesPerTrial(handles.p.trialNo),'uint16');
        szdv=size(data_vec);
        data_per_trial=reshape(data_vec,szdv(1)/handles.draq_p.no_spike_ch,handles.draq_p.no_spike_ch);
        fclose(handles.p.fid);
    case 2
        %This is dg
        if handles.p.read_entire_file==1
            data_this_trial=[];
            trialNo=handles.p.trialNo;
            data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
                floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
            data=zeros(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)-2000,handles.draq_p.no_chans);
            for ii=1:handles.draq_p.no_chans
                data_per_trial(:,ii)=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)+1:...
                    floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)...
                    +floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)-2000);
            end
        else
            handles.p.fid=fopen(handles.p.fullName,'rb');
            trial_no=handles.p.trialNo;
            bytes_per_native=2;     %Note: Native is unit16
            %Note: Since 2013 DT3010 is acquiring at a rate that is not an integer.
            %However, the program saves using an integer number of bytes! VERY
            %important to use uint64(handles.draq_p.ActualRate) here!!! Nick George
            %solved this problem!
            size_per_ch_bytes=handles.draq_p.sec_per_trigger*uint64(handles.draq_p.ActualRate)*bytes_per_native;
            no_unit16_per_ch=size_per_ch_bytes/bytes_per_native;
            trial_offset=handles.draq_p.no_chans*size_per_ch_bytes*(trial_no-1);
            for ii=1:handles.draq_p.no_chans
                status=fseek(handles.p.fid, (ii-1)*size_per_ch_bytes+trial_offset, 'bof');
                this_trial=[];
                this_trial=fread(handles.p.fid,no_unit16_per_ch,'uint16');
                data_per_trial(1:length(this_trial),ii)=this_trial;
            end
            fclose(handles.p.fid);
        end
    case 3
        [data_per_trial]=drtaGetTraceDataRHD(handles);
end
