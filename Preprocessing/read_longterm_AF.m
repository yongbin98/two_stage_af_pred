clear all;
close all;
clc;

%% longterm AF (fs = 128)
folderPath = fullfile(pwd, "database/ltafdb/1.0.0/");
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
fs = 128;
segment_time = 180; % minutes
for currentSubject = subjects
    filePath = ['ltafdb/1.0.0/', currentSubject{1}];
    [ann,anntype,subtype,chan,num,comments] = rdann(filePath, 'atr');
    
    commentIdx = find(~cellfun(@isempty, comments));
    comments = comments(commentIdx);
    commentIdx(end+1) = length(ann);

    afIdx = find(strcmp(comments,'(AFIB'));
    startIdx_AF = commentIdx(afIdx);
    endIdx_AF = commentIdx(afIdx+1);
    startIdx_NSR = [1;endIdx_AF(1:end-1)];    

    if(isempty(endIdx_AF))
        continue;
    end

    diff_AFtime = (ann(startIdx_AF) - ann(startIdx_NSR))/fs/60;    
    idx_seg = find(diff_AFtime > segment_time);
    onsetIndex = ann(endIdx_AF(idx_seg));
    startIndex = onsetIndex - segment_time*fs*60+1;

    if isempty(onsetIndex)
        continue;
    end

    for i = 1:length(onsetIndex)
        startInfo = startIndex(i);
        endInfo = onsetIndex(i);

        [signal, ~, ~] = rdsamp(filePath, [], endInfo, startInfo);  % Adjust the parameter order as needed
        [af_signal, ~, ~] = rdsamp(filePath, [], endInfo+fs*60*5, endInfo+1);  % Adjust the parameter order as needed
        ann(ismember(anntype,['+','"'])) = [];
        anntype(ismember(anntype,['+','"'])) = [];

        validIdx = (ann >= startInfo) & (ann <= endInfo);  % Logical indexing for annotations
        rri = ann(validIdx) - startInfo;  % Adjust annotations relative to the startIndex
        rri_info = anntype(validIdx);  % Extract corresponding annotation types

        save(['longAF_', currentSubject{1},'_',num2str(i),'.mat'], 'signal','rri','rri_info','startInfo','endInfo','fs','af_signal');
    end 
end