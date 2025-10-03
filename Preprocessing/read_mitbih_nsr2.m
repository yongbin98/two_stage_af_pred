clear all;
close all;
clc;

%% longterm AF (fs = 128)
folderPath = fullfile(pwd, "database/nsr2db/1.0.0/");
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
    filePath = ['nsr2db/1.0.0/', currentSubject{1}];
    [ann,anntype,~,~,~,~] = rdann(filePath, 'ecg');
    ann(ismember(anntype, ['|','~'])) = [];
    anntype(ismember(anntype, ['|','~'])) = [];

    fs = 128;
    rri = ann;
    savefile = fullfile("data_preprocessed/MIT-BIH_NSR2/",['NSR_',currentSubject{1},'.mat']);
    save(savefile, 'rri','fs');

    clearvars -except currentSubject subjects
end