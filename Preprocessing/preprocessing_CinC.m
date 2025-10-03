clear all;
close all;
clc;

folderPath = fullfile(pwd,'data_preprocessed/','CinC2001/');
fileList = dir(fullfile(folderPath, '*.mat'));

fs = 128;

for i = 1:50
    ECG = load(fullfile(folderPath,fileList(i).name));
    ECG = ECG.val(1,:);

    outputDir = fullfile(folderPath,'RRI_10min');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    duration = 10;
    save_rri = [];
    for j = 1:(30/duration)
        ST = 60*(j-1)*duration*fs+1; % 0 30 50
        ED = 60*(j)*duration*fs; % 5 35 55.

        min_5_ECG = ECG(ST:ED);
        
        [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(min_5_ECG,128,0);
        Rtimes = qrs_i_raw(:)/fs;
        r_diff = diff(Rtimes);
        noiseIDX = r_diff(r_diff>5);     
        Rtimes_filtered = Rtimes([true; r_diff < 5 & r_diff > 0.2]);
        if(sum(noiseIDX) > 10)
            plot(diff(Rtimes_filtered));
            continue;
        end
        rri = diff(Rtimes_filtered);
        HR = 60./rri;
        HR_diff = diff(HR);

        hrtime = linspace(Rtimes_filtered(2), Rtimes_filtered(end), 60*duration)';
        rri = spline(Rtimes_filtered(2:end), rri, hrtime);        

        if(contains(fileList(i).name,'n'))
            y_label = 0;
        elseif((contains(fileList(i).name,'p')))
            y_label = 1;
        else
            print("error");
        end    

        save_rri(end+1,:) = rri;
    end
    rri = save_rri;
    if(isempty(rri))
        continue;
    end
    rriFilename = ['RRI_',num2str(i),'_',num2str(j),'.mat'];
    rriPath = fullfile(outputDir,rriFilename);
    save(rriPath,'rri','y_label');

    close all;
    clearvars -except folderPath i fileList fs
end 