clear all;
close all;
clc;

folderPath = fullfile(pwd, "data_preprocessed/MIT-BIH_AF/");
files = dir(fullfile(folderPath, '*.mat')); % Adjust '*.mat' based on your file type

for i = 1:length(files)
    filePath = fullfile(folderPath, files(i).name);
    
    data = load(filePath);

    outputDir = fullfile(folderPath,'RRI_30min');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    duration = 30;
    save_rri = [];
    for j = 1:(30/duration)
        fs = 250;
        ST = 60*(j-1)*duration*fs+1; % 0 30 50
        ED = 60*(j)*duration*fs; % 5 35 55.

        rPeak_5min = data.rri(data.rri > ST & data.rri < ED);
        rPeak_5min_filtered = rPeak_5min([true; diff(rPeak_5min)>0.2*fs & diff(rPeak_5min)<5*fs])./fs;
        rri = diff(rPeak_5min_filtered);    
        HR = 60./rri;
        HR_diff = diff(HR);

        hrtime = linspace(rPeak_5min_filtered(2), rPeak_5min_filtered(end), duration*60)';
        rri = spline(rPeak_5min_filtered(2:end), rri, hrtime);    
    
        save_rri(end+1,:) = rri;
    end
    rri = save_rri;
    rriFilename = ['RRI',num2str(i),'.mat'];
    rriPath = fullfile(outputDir,rriFilename);
    save(rriPath,'rri');
    

    close all;
    clearvars -except folderPath files i
end