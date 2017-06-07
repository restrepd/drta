function [drta_p]= drtaPullThreshold


[FileName,PathName] = uigetfile('jt_times*.mat','Select jt_times file to pull threshold');
load([PathName,FileName])

