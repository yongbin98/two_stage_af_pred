clear all;
close all;
clc;

folderPath = fullfile(pwd, "data_preprocessed/MIT-BIH_NSR2/");
files = dir(fullfile(folderPath, '*.mat')); % Adjust '*.mat' based on your file type

for i = 1:length(files)
    filePath = fullfile(folderPath, files(i).name);
    
    data = load(filePath);
    data.rri = data.rri- data.rri(1);

    outputDir = fullfile(folderPath,'RRI_sequential_2h');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    segments_time = 12;
    cnt = 0;
    while (1)
        save_rri = [];
        for j = 1:segments_time
            fs = 128;
            ST = (j-1)*fs*60*10+1 + cnt*fs*60*10*segments_time;
            ED = (j)*fs*60*10 + cnt*fs*60*10*segments_time;
        
            rPeak_10min = data.rri(data.rri > ST & data.rri < ED);
            rri = diff(rPeak_10min/fs);
            falseIdx = [find(rri>5), find(rri<0.2)];
            for idxFalse = 1:length(falseIdx)
                currentFalse = falseIdx(idxFalse) - idxFalse+1;
                rPeak_10min(currentFalse+1:end) = rPeak_10min(currentFalse+1:end)-diff(rPeak_10min(currentFalse:currentFalse+1));
                rPeak_10min(currentFalse+1) = [];
                rri(currentFalse) = [];
            end
            HR = 60./rri;
            HR_diff = diff(HR);
        
            fs_hrv = 1;
            hrtime = linspace(rPeak_10min(2), rPeak_10min(end), 600)';
            rri = spline(rPeak_10min(2:end), rri, hrtime);  

            plot(rri);
            falseIdx = [find(rri>5); find(rri<0.2)];
            if(~isempty(falseIdx))
                validIdx = find(rri <= 5 & rri >= 0.2);
                meanValid = mean(rri(validIdx));
                rri(falseIdx) = meanValid;
            end
            % plot(rri);
    
            save_rri(end+1,:) = rri;
        end
        cnt = cnt+1;
        rri = save_rri;
        rriFilename = ['RRI',num2str(i),'_',num2str(cnt),'.mat'];
        rriPath = fullfile(outputDir,rriFilename);
        save(rriPath,'rri');

        if(data.rri(end)-ED <= fs*60*10*segments_time)
            break;
        end
    end

    close all;
    clearvars -except folderPath files i

end
