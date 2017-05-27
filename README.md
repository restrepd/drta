**Drta**

When you type drta you get two windows showing the data in each trial:
drtaBrowseTraces and a sample of snips chosen with the thresholds
entered and turning off some trials/channels with drtaThresholdSnips.

In drtaBrowseTraces it is important to turn off differential (top, left
in drtaBrowseTraces).

drta is a program used to browse through data acquired with draq and to
set four parameters that are important for clustering the spikes using
Do\_wave\_clus.

Inputs:

Two files called ‘name.dg’ and ‘name.mat’

The .mat file has the all the acquisition parameters

The .dg file has all the binary data. It can be read as follows:

    fid=fopen(handles.p.fullName,'r');

   
no\_unit16\_per\_ch=floor(handles.draq\_p.sec\_per\_trigger\*handles.draq\_p.ActualRate);

   
data=fread(fid,no\_unit16\_per\_ch\*handles.draq\_p.no\_chans\*handles.draq\_d.noTrials,'uint16');

    fclose(fid)

Outputs: drta outputs all the user’s choices and excluded spike times in
name.mat

In the browse window the user can browse through the data, change the
y-axis and x-axis ranges, display only one or all channels, and display
3xthe standard deviation.

Fist exclude the lick artifact that is found in all channels

Then decide on differential or raw data

Finally set thresholds (2.5xSD)

The following parameters can be set by the user: thresholds for spike
generation, choose which channels are processed by Do\_wave\_clusdrdg,
choose trials that are excluded in Do\_wave\_clusdrdg because of
electrical artifacts

To save the settings and thresholds the user has set, the user must push
on “save” *making the right choice for the correct experiment used*
(e.g. dropcspm).

*Notes:* in drtaBrowsTraces do not click within the window because that
will change the red threshold line

In the code we have processing for two kinds of files:

dra and dg

They differ in their headers. The dra format was used for the studies of
Doucette and Gire(Doucette and Restrepo, 2008; Doucette et al., 2011;
Gire et al., 2013) where all the recording was performed with
electrodes, and the dg format is used for the more recent studies of Li
and Guthman(Li et al., 2014; Li et al., 2015; Li et al., 2017) where the
recordings were performed with tetrodes. The code for dra likely does
not work anymore. However, it is left in dra so that we can modify it in
the future when we start doing electrode recordings again.

Finally, try the software at your own risk Not all functions are
tested!! Also, I want to thank Nick George for steering me towards
GitHub.

Diego

Doucette W, Restrepo D (2008) Profound context-dependent plasticity of
mitral cell responses in olfactory bulb. PLoS Biol 6:e258.

Doucette W, Gire DH, Whitesell J, Carmean V, Lucero MT, Restrepo D
(2011) Associative cortex features in the first olfactory brain relay
station. Neuron 69:1176-1187.

Gire DH, Kapoor V, Seminara A, Arrighi-Allisan A, Murthy VN (2013)
Olfactory search behavior in mice: A novel task design that moves beyond
a single sniff. Society for Neuroscience 2013 Online Program No. 452.28.

Li A, Gire DH, Restrepo D (2015) Υ spike-field coherence in a population
of olfactory bulb neurons differentiates between odors irrespective of
associated outcome. J Neurosci 35:5808-5822.

Li A, Gire DH, Bozza T, Restrepo D (2014) Precise detection of direct
glomerular input duration by the olfactory bulb. J Neurosci
34:16058-16064.

Li A, Guthman EM, Doucette WT, Restrepo D (2017) Behavioral Status
Influences the Dependence of Odorant-Induced Change in Firing on
Prestimulus Firing Rate. J Neurosci 37:1835-1852.

Quiroga RQ, Nadasdy Z, Ben Shaul Y (2004) Unsupervised spike detection
and sorting with wavelets and superparamagnetic clustering. Neural
Comput 16:1661-1687.
