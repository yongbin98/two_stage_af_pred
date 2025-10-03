clear all;
close all;
clc;

folderPath = fullfile(pwd, "data_preprocessed/longterm_AF/");
files = dir(fullfile(folderPath, '*.mat')); % Adjust '*.mat' based on your file type

for i = 1:length(files)
    filePath = fullfile(folderPath, files(i).name);
    
    data = load(filePath);

    outputDir = fullfile(folderPath,'RRI_sequential_2h');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    save_rri = [];
    for j = 1:12
        fs = 128;
        ST = 60*(j-1)*10*fs+1;
        ED = 60*(j)*10*fs;
    
        rPeak_5min = data.rri(data.rri > ST & data.rri < ED);
        rri = diff(rPeak_5min/fs);
        HR = 60./rri;
        HR_diff = diff(HR);
        
        fs_hrv = 1;
        hrtime = linspace(rPeak_5min(2), rPeak_5min(end), 600)';
        rri = spline(rPeak_5min(2:end), rri, hrtime);

        save_rri(end+1,:) = rri;
    end

    rri = save_rri;
    rriFilename = ['RRI',files(i).name(12:end-4),'.mat'];
    rriPath = fullfile(outputDir,rriFilename);
    save(rriPath,'rri');

    close all;
    clearvars -except folderPath files i
end