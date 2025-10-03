clear all;
close all;
clc;

%% longterm AF (fs = 128)
folderPath = fullfile(pwd, "database/afdb/1.0.0/");
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


% read subjects via WFDB tool ox
fs = 250;
segment_time = 180; % minutes
subjects(1:2) = [];
for currentSubject = subjects
    filePath = ['afdb/1.0.0/', currentSubject{1}];
    [ann,anntype,subtype,chan,num,comments] = rdann(filePath, 'atr');

    startIdx = find(strcmp(comments,'(N'));
    endIdx = intersect(find(strcmp(comments, '(AFIB')), startIdx + 1);

    diff_AFtime = [];
    for idx = 1:length(endIdx)
        diff_AFtime(idx) = (ann(endIdx(idx)) - ann(startIdx(idx)))/fs/60;
    end
    idx_seg = find(diff_AFtime > segment_time);
    onsetIndex = ann(endIdx(idx_seg));

    startIndex = onsetIndex - fs * segment_time * 60 + 1;  % Ensure start index is not negative

    if(startIndex < 0)
        disp(['AF onset within 30 minutes', currentSubject{1}]);
    else
        for i = 1:length(onsetIndex)
            startInfo = startIndex(i);
            endInfo = onsetIndex(i);

            [signal, ~, ~] = rdsamp(filePath, [], endInfo, startInfo);  % Adjust the parameter order as needed    
            [af_signal, ~, ~] = rdsamp(filePath, [], endInfo+fs*60*5, endInfo+1);  % Adjust the parameter order as needed    
            [ann,anntype,~,~,~,~] = rdann(filePath, 'qrsc');
            ann(ismember(anntype, ['|','~'])) = [];
            anntype(ismember(anntype, ['|','~'])) = [];

            validIdx = (ann >= startInfo) & (ann <= endInfo);  % Logical indexing for annotations
            rri = ann(validIdx) - startInfo;  % Adjust annotations relative to the startIndex

            savefile = fullfile("data_preprocessed/MIT-BIH_AF/",['MIT-BIH_AF_', currentSubject{1},'_',num2str(i),'.mat']);

            save(savefile, 'signal','rri','startInfo','endInfo','fs','af_signal');
        end            
    end 
end