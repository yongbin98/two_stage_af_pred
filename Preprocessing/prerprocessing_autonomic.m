clear all;
close all;
clc;

folderPath = fullfile(pwd, 'data_preprocessed','autonomic/');
files = dir(fullfile(folderPath, '*.mat')); % Adjust '*.mat' based on your file type

for i = 366:length(files)
    filePath = fullfile(folderPath, files(i).name);
    
    data = load(filePath);
    fs = data.fs;
    fs_new = 128;
    duration = 30;

    ECG_signal = data.signal(:,1);
    t_original = (0:length(ECG_signal)-1) / fs; % Original time vector
    t_new = (0:1/fs_new:t_original(end)); % New time vector    
    ECG_resampled = spline(t_original, ECG_signal, t_new); % Spline interpolation

    if(length(ECG_resampled) < 128*60*duration)
        continue;
    end
    cut = floor(length(ECG_resampled)/2);
    ECG_resampled = ECG_resampled(cut-128*60*(duration/2)+1:cut+128*60*(duration/2));
    
    [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ECG_resampled,fs_new,0);    
    Rtimes = qrs_i_raw(:)/fs_new;
    r_diff = diff(Rtimes);
    noiseIDX = r_diff(r_diff>5);     
    Rtimes_filtered = Rtimes([true; r_diff < 5 & r_diff > 0.2]);
    if(sum(noiseIDX) > 10 || isempty(r_diff))
        plot(diff(Rtimes_filtered));
        continue;
    end
    rri = diff(Rtimes_filtered);
    HR = 60./rri;
    HR_diff = diff(HR);
    
    fs_hrv = 1;
    hrtime = linspace(Rtimes_filtered(2), Rtimes_filtered(end), duration*60)';
    rri = spline(Rtimes_filtered(2:end), rri, hrtime);    

    rriFilename = ['RRI',num2str(i),'.mat'];
    rriPath = fullfile(folderPath,'RRI_30min',rriFilename);
    save(rriPath,'rri');
    
    close all;
    clearvars -except folderPath files i
end