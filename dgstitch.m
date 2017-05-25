%% This script file stitches two files together
clear all
 
dt_between_sessions=20;

%Get the first file
[FileName1,PathName1] = uigetfile('*.mat','Select first .mat file to stitich');
FullName1=[PathName1,FileName1];
fls{1}=FullName1; 
load(FullName1) 
try
    draq_p=params;
    draq_d=data;
catch
end
draq_d1=draq_d;
no_files=1; 


enter_more_files=1;

while enter_more_files==1
    choice=questdlg('Would you like to enter another file?','Enter file')
    
    if strcmp(choice,'Yes')
        [FileName2,PathName2] = uigetfile('*.mat','Select second .mat file to stitch');
        FullName2=[PathName2,FileName2];
        no_files=no_files+1;
        fls{no_files}=FullName2;
        draq_d=[];
        draq_p=[];
        load(FullName2)
        try
            draq_p=params;
            draq_d=data;
        catch
        end
        eval(['draq_d' num2str(no_files) ' = draq_d;']);
    else
        enter_more_files=0;
    end
end

draq_d=[];
draq_d.trig1=1;
draq_d.noTrials=0;
time_offset=0;
draq_d.no_stitched_files=no_files;
for ii=1:no_files
    eval(['draq_d.t_trial(draq_d.noTrials+1:draq_d.noTrials+draq_d' num2str(ii) '.noTrials) = draq_d' num2str(ii) '.t_trial+time_offset;']);
    eval(['draq_d.start_trial_per_file(' num2str(ii) ')= draq_d.noTrials+1;']);
    eval(['draq_d.noTrials =draq_d.noTrials+draq_d' num2str(ii) '.noTrials;']);
    time_offset=draq_d.t_trial(end)+dt_between_sessions;
end
draq_d.t_end=draq_d.t_trial(end);

fullSaveName=[FullName1(1:end-4),'_stch.mat'];
save(fullSaveName,'draq_d','draq_p');  
 
pffft=1

%Read and stitch the dg files
fidw= fopen([FullName1(1:end-4),'_stch.dg'], 'w');

for ii=1:no_files
    file_to_open=fls{ii};
    fid1 = fopen([file_to_open(1:end-4) '.dg'], 'r');
    trial_data=[];
    trial_data= fread(fid1,'uint16');
    fwrite(fidw,trial_data,'uint16');
    fclose(fid1);
end
fclose(fidw);

pffft=1
