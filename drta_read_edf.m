% function [outputArg1,outputArg2] = drta_read_edf_labels(inputArg1,inputArg2)
%UNTITLED2 Summary of this function goes here
close all
clear all

PathName{1}='/Users/restrepd/Documents/Projects/Multi day LFP/EmpiricalCalibration/';
FileName{1}='Use Ref Correct Label_2024-09-09_11_40_53_export.edf';

PathName{2}='/Users/restrepd/Documents/Projects/Multi day LFP/EmpiricalCalibration/';
FileName{2}='Use Ref Incorrect Label_2024-09-09_11_49_24_export.edf';

OutPathName='/Users/restrepd/Documents/Projects/Multi day LFP/';
OutFileName='empiricaledfLabels.xlsx';

figNo=0;
for fileNum=1:length(FileName)
    handles.p.fullName=[PathName{fileNum} FileName{fileNum}];

    einf=edfinfo(handles.p.fullName);
    signal_labels=einf.SignalLabels;

     data=edfread(handles.p.fullName);

    %Names of columns
    varnames=data.Properties.VariableNames;

    %Display the first 10 row in the table
    disp(data)

    %Plot the data
      figNo=figNo+1;
    try
        close(figNo)
    catch
    end

    %Plot the shifted odor plume
    hFig = figure(figNo);
    set(hFig, 'units','normalized','position',[.1 .1 .7 .3])
    hold on
    y_shift=0;
    for chNo=1:length(varnames)
        this_record=[];
        for recNo=1:size(data,1)
            eval(['this_record=[this_record data.' varnames{chNo} '{recNo}'' ];'])
        end
        plot(this_record+y_shift)
        y_shift=y_shift+max(this_record);
    end

    title(FileName{fileNum})
 
    if fileNum==1
        %Setup the output table
        % Determine number of columns for each type
        numVarNames = einf.NumSignals;
        numSignalLabels = einf.NumSignals;

        % Generate column names
        varNames = arrayfun(@(x) sprintf('VarName%d', x), 1:numVarNames, 'UniformOutput', false);
        signalLabels = arrayfun(@(x) sprintf('SignalLabel%d', x), 1:numSignalLabels, 'UniformOutput', false);

        % Combine all column names
        allColumnNames = ['FileName', varNames, signalLabels];

        % Create an empty cell array to hold the data
        numRows = length(FileName);
        table_data = cell(numRows, numel(allColumnNames));

        % Fill the cell array with sample data (as strings for consistency)
        for i = 1:size(table_data, 2)
            table_data(:, i) = arrayfun(@(x) num2str(rand), 1:numRows, 'UniformOutput', false);
        end

        % Create the table from the cell array
        T = cell2table(table_data, 'VariableNames', allColumnNames);

        % % Enter 'EEG1' into the first row of VarName1
        % T.VarName1(1) = {'EEG1'};

        % Display the table to verify
        disp(T);
    end

    T.FileName(fileNum)={FileName{fileNum}};


    %Extract and print the column names
    for chNo=1:einf.NumSignals
        eval(['T.VarName' num2str(chNo) '(fileNum)={varnames{chNo}};'])
        eval(['T.SignalLabel' num2str(chNo) '(fileNum)={signal_labels{chNo}};'])
        fprintf(1, ['Column No %d VariableName ' varnames{chNo} ' ,einf SignalLabel ' signal_labels{chNo} '\n'],chNo)
    end

end

% Specify the Excel file name
excel_filename = [OutPathName OutFileName];

% Write the table to an Excel file
writetable(T, excel_filename, 'Sheet', 'Sheet1');
pffft=1;