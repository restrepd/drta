function prefs=drtaSetPreferences()
%Sets preferences for drta

prefs.threshold(1:16)=1300;
prefs.start_display_time=0;
prefs.display_interval=9;
prefs.filter_dt=0.001666667;
prefs.trialNo=1;
prefs.which_channel=1;
prefs.which_display=1;
prefs.do_filter=1;
prefs.dt_pre_snip=0.0005;
prefs.dt_post_snip=0.001;
prefs.which_channel_th=1;
prefs.upper_limit(1:16)=5000;
prefs.lower_limit(1:16)=-5000;
prefs.which_display_th=1;
prefs.which_c_program=1;
prefs.ch_processed(1:16)=1;
prefs.do_3xSD=0;
prefs.lfp.maxLFP=9800;
prefs.lfp.minLFP=-9800;
prefs.lfp.delta_max_min_out=0.5;

%Preferences for mspy
prefs.mspy_exclude_dt=1; %Exclude 
prefs.mspy_key_offset=2; %Use 2 for mspy before 3/13, and 0 afterwards