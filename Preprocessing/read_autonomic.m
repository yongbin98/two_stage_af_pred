clear all;
close all;
clc;

% [signal,fs,tm] = rdsamp('afdb/1.0.0/04043',[],1000);
% [ann,anntype,subtype,chan,num,comments] = rdann('afdb/1.0.0/04043', 'atr');

% h5info('record_000_ecg_00.h5');
% h5read('record_000_ecg_00.h5','/ecg');


%% longterm AF (fs = 128)
folderPath = fullfile(pwd, "database/autonomic-aging-cardiovascular/1.0.0/");
fileName = fullfile(folderPath, "RECORDS"); % Full path to the file

% Open the file in read mode
fid = fopen(fileName, 'r');
if fid == -1
    error('File not found or permission denied.');
end

% Read the file line by line and store each line in the cell array
subjects = {};
while ~feof(fid)
    line = strtrim(fgets(fid));  % Read one line and trim whitespace
    if ~isempty(line)  % Ignore empty lines
        subjects{end+1} = line; % Append the line to the cell array
    end
end

% read subjects via WFDB tool box
for currentSubject = subjects
    filePath = ['autonomic-aging-cardiovascular/1.0.0/', currentSubject{1}];
    [signal, fs, ~] = rdsamp(filePath);  % Adjust the parameter order as needed
    
    savefile = fullfile("data_preprocessed/autonomic/",['autonomic_',currentSubject{1},'.mat']);
    save(savefile, 'signal','fs');
end