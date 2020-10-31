function handles=drtaBatchChoicesDR_spm_05202019

%This is an example of the drtaBatchChoices used by drtaBatch

%Which program was used to acquire the data?
handles.drtachoices.which_protocol=8;    
%1 dropcspm
%2 laser(Ming)
%3 dropcnsampler
%4 laser (Merouann)
%5 dropc_conc
%6 dropcspm_hf
%7 continuous
%8 working memory

%This choice is used by drtaGenerateEvents
handles.drtachoices.which_c_program=14;    
%1 dropcnsampler
%2 is dropcspm
%10 is dropc_conc
%14 working memory


%First file to process
handles.drtachoices.first_file = 1;

handles.drtachoices.pre_dt;
handles.trial_duration=handles.drtachoices.trial_duration;



% no laser experiment ethyl ace
handles.drtachoices.PathName{1}='/Volumes/Diego/Daniel olfactory paper/254071/ethyl/';
handles.drtachoices.FileName{1}='73117254071ethylacepropylacenl.dg';


handles.drtachoices.PathName{2}='/Volumes/Diego/Daniel olfactory paper/261032/ethyl ace/';
handles.drtachoices.FileName{2}='73017261032ethylacepropylacenl.dg';


handles.drtachoices.PathName{3}='/Volumes/Diego/Daniel olfactory paper/294211/ethylace/';
handles.drtachoices.FileName{3}='122117294211etehylacepropylacenlnl.dg';


handles.drtachoices.PathName{4}='/Volumes/Diego/Daniel olfactory paper/294212/ethylace/';
handles.drtachoices.FileName{4}='122017294212ethylacepropylacenl.dg';


handles.drtachoices.PathName{5}='/Volumes/Diego/Daniel olfactory paper/254071/laser/';
handles.drtachoices.FileName{5}='73117254071ethylacepropylacel.dg';

handles.drtachoices.PathName{6}='/Volumes/Diego/Daniel olfactory paper/261032/laser/';
handles.drtachoices.FileName{6}='73017261032ethylacepropylacel.dg';

handles.drtachoices.PathName{7}='/Volumes/Diego/Daniel olfactory paper/294211/laser/';
handles.drtachoices.FileName{7}='122117294211etehylacepropylacel.dg';

handles.drtachoices.PathName{8}='/Volumes/Diego/Daniel olfactory paper/294212/laser/';
handles.drtachoices.FileName{8}='jt_times_122017294212ethylacepropyll.mat';



handles.drtachoices.no_files=max(size(handles.drtachoices.FileName(1,:)));




