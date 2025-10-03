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

    % save_rri = [];
    % for j = 1:61
    %     fs = 128;
    %     ST = (j-1)*fs*60*10+1;
    %     ED = (j)*fs*60*10;
    % 
    %     rPeak_5min = data.rri(data.rri > ST & data.rri < ED);
    %     r_diff = diff(rPeak_5min/fs);
    %     rPeak_5min_filtered = rPeak_5min([true; r_diff>0.2 & r_diff<5])./fs;
    %     rri = diff(rPeak_5min_filtered);    
    %     HR = 60./rri;
    %     HR_diff = diff(HR);
    % 
    %     fs_hrv = 1;
    %     hrtime = linspace(rPeak_5min_filtered(2), rPeak_5min_filtered(end), 600)';
    %     rri = spline(rPeak_5min_filtered(2:end), rri, hrtime);  
    % 
    %     save_rri(end+1,:) = rri;
    % end
    % 
    % rri = save_rri;
    % rriFilename = ['RRI_1_',num2str(i),'.mat'];
    % rriPath = fullfile(outputDir,rriFilename);
    % save(rriPath,'rri');
    % 

    % if(data.rri(end)-data.rri(1) > fs*3600*20)
    %     save_rri = [];
    %     for j = 1:61
    %         fs = 128;
    %         ST = (j-1)*fs*60*10+1 + fs*3600*10;
    %         ED = (j)*fs*60*10 + fs*3600*10;
    % 
    %         rPeak_5min = data.rri(data.rri > ST & data.rri < ED);
    %         r_diff = diff(rPeak_5min/fs);
    %         rPeak_5min_filtered = rPeak_5min([true; r_diff>0.2 & r_diff<5])./fs;
    %         rri = diff(rPeak_5min_filtered);    
    %         HR = 60./rri;
    %         HR_diff = diff(HR);
    % 
    %         fs_hrv = 1;
    %         hrtime = linspace(rPeak_5min_filtered(2), rPeak_5min_filtered(end), 600)';
    %         rri = spline(rPeak_5min_filtered(2:end), rri, hrtime);  
    % 
    %         save_rri(end+1,:) = rri;
    %     end
    % 
    %     rri = save_rri;
    %     rriFilename = ['RRI_2_',num2str(i),'.mat'];
    %     rriPath = fullfile(outputDir,rriFilename);
    %     save(rriPath,'rri');
    % end
            
    %% HRV
    % NN = diff(rri);
    % 
    % RMSSD = sqrt(mean(NN .^ 2));  % Correct RMSSD formula
    % NN50 = sum(NN > 0.05);         % 50ms = 0.05s
    % pNN50 = (NN50 / length(NN)) * 100; % Check for division by zero
    % sampleEn = Function_SampleEntropy(rri);
    % normRMSSD = Function_NormalizedRMSSD(rri);
    % shannonEN = Function_ShannonEntropy(rri);
    % 
    % hrvFolderPath = fullfile(folderPath, 'HRV');
    % 
    % if ~exist(hrvFolderPath, 'dir')
    %     mkdir(hrvFolderPath);
    % end
    % 
    % hrvFilename = ['HRV',num2str(i),'.mat'];
    % hrvPath = fullfile(folderPath,'HRV',hrvFilename);
    % 
    % save(hrvPath,'RMSSD','NN50','pNN50','sampleEn',"normRMSSD","shannonEN"); 
    % 
    % %% RRI
    % fs_hrv = 1;
    % % hrtime = (rri_5min_filtered(2):1/fs_hrv:rri_5min_filtered(end))'; % Start from the second R-peak
    % hrtime = linspace(rPeak_5min_filtered(2), rPeak_5min_filtered(end), 300)';
    % rri = spline(rPeak_5min_filtered(2:end), rri, hrtime);    
    % 
    % rriFilename = ['RRI',num2str(i),'.mat'];
    % rriPath = fullfile(folderPath,'RRI',rriFilename);
    % save(rriPath,'rri');
    
    %% STFT
    % [b, a] = butter(2, [0.5 40] / (fs / 2), 'bandpass');
    % ECG = data.signal(:,1);
    % ECG = ECG(60*fs*15+1:60*fs*20);
    % ECG_filtered = filtfilt(b, a, ECG);
    % 
    % fs_new = 32;
    % ECG_resampled = resample(ECG_filtered,fs_new,fs);
    % [stft_sig, f, t] =stft(ECG_resampled,fs_new,'Window',kaiser(32,5),'OverlapLength',24,'FFTLength',128);%** 
    % stft_abs(:,:)=abs(stft_sig);
    % stft_angle(:,:)=angle(stft_sig);  
    % 
    % stftFilename = ['STFT',num2str(i),'.mat'];
    % stftPath = fullfile(folderPath,'STFT',stftFilename);
    % save(stftPath,'stft_abs','stft_angle');   
    % 
    % %STFT plot
    % magnitude_stft = abs(stft_sig);
    % surf(t, f, 20*log10(magnitude_stft), 'EdgeColor', 'none'); % Convert magnitude to dB scale
    % axis tight;
    % view(2); % Set view to 2D
    % colorbar; % Display colorbar
    % xlabel('Time (s)');
    % ylabel('Frequency (Hz)');
    % title('Time-Frequency Representation of ECG Signal');

    %% Poincare plot
    % figure;
    % plot(HR_diff(2:end), HR_diff(1:end-1),'-','LineWidth',1.5,'Color','k'); 
    % xlim([-96 96]);
    % ylim([-96 96]);
    % set(gca,'XColor', 'none','YColor','none');
    % set(gca, 'Position', [0, 0, 1, 1]); % Make the plot fill the entire figure
    % set(gcf, 'Position', [0, 0, 256, 256]); % Set the figure size to 256x256 pixels
    % frame = getframe(gcf);
    % img_rgb = frame2im(frame); % Convert the captured frame to an image
    % img_gray = rgb2gray(img_rgb);
    % 
    % outputDir = fullfile(folderPath, "Poincare");
    % output_file = fullfile(outputDir, ['Poincare', num2str(i), '.jpg']);
    % imwrite(img_gray,output_file);

    close all;
    clearvars -except folderPath files i
end