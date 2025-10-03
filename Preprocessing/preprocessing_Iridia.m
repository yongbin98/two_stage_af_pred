clear all;
close all;
clc;

folderPath = fullfile(pwd, "data_preprocessed/","IRIDIA/");
files = dir(fullfile(folderPath, '*.mat')); % Adjust '*.mat' based on your file type

for i = 1:length(files)
    filePath = fullfile(folderPath, files(i).name);
    
    data = load(filePath);

    fs = data.fs;
    rri_fs = fs*5;

    Rpeaks(1) = 0;
    % Convert RRI to R-peak indices
    for j = 2:length(data.rri_before)+1
        Rpeaks(j) = Rpeaks(j-1) + data.rri_before(j-1);
    end

    outputDir = fullfile(folderPath,'BSN_2h');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    %% ecg
    fs_out = 128;
    t_original = (0:length(data.signal_before)-1)/fs;
    t_target = 0 : 1/fs_out : t_original(end);
    
    duration = 12;
    save_rri = [];
    for j = 1:duration
        fs = data.fs;
        rri_fs = fs*5;
        ST = rri_fs*60*(j-1)*10+1;
        ED = rri_fs*60*(j)*10;
    
        rPeak_10min = Rpeaks(Rpeaks > ST & Rpeaks < ED).';
        r_diff = diff(rPeak_10min/rri_fs);
        rPeak_5min_filtered = rPeak_10min./rri_fs;
        rri = diff(rPeak_5min_filtered);    
        HR = 60./rri;
        HR_diff = diff(HR);
        
        hrtime = linspace(rPeak_5min_filtered(2), rPeak_5min_filtered(end), 600)';
        rri = spline(rPeak_5min_filtered(2:end), rri, hrtime);  

        save_rri(end+1,:) = rri;
    end

    rri = save_rri;
    rriFilename = ['RRI',files(i).name(8:end-4),'.mat'];
    rriPath = fullfile(outputDir,rriFilename);
    save(rriPath,'rri');

    close all;
    clearvars -except folderPath files i
end