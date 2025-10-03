clear all;
close all;
clc;

folderPath = fullfile(pwd,'data_iridia');
savePath = fullfile(pwd,"data_preprocessed/","IRIDIA/");
recordString = strings(1,167);
fs = 200;

metadata = readtable(fullfile(folderPath,"iridia-af-metadata-v1.0.1.csv"));

for i = 0:166
    recordString(i+1) = sprintf('record_%03d',i);
end

segments = 60*600; % 180min
for i = 1:length(recordString)
    folderName = fullfile(folderPath, recordString(i)); % Full path to the file
    ecgTable = sprintf('record_%03d_ecg_labels',i-1);
    rriTable = sprintf('record_%03d_rr_labels',i-1);        
    ecg_AF_label = readtable(fullfile(folderName,ecgTable));
    rri_AF_label = readtable(fullfile(folderName,rriTable));

    signal = []; rri = [];
    for j = 1:metadata.record_files(i)
        ecgString = sprintf('record_%03d_ecg_%02d.h5',i-1,j-1);
        rriString = sprintf('record_%03d_rr_%02d.h5',i-1,j-1);
        
        raw_signal = h5read(fullfile(folderName,ecgString),'/ecg');
        signal = [signal, raw_signal(1,:)];
        
        idx_start = find(ecg_AF_label.start_file_index >= j);
        ecg_AF_label.start_qrs_index(idx_start) = ecg_AF_label.start_qrs_index(idx_start) + length(raw_signal);
        idx_end = find(ecg_AF_label.end_file_index >= j);
        ecg_AF_label.end_qrs_index(idx_end) = ecg_AF_label.end_qrs_index(idx_end) + length(raw_signal);

        raw_rri = h5read(fullfile(folderName,rriString),'/rr');
        rri = [rri; raw_rri];

        idx_start = find(rri_AF_label.start_file_index >= j);
        rri_AF_label.start_rr_index(idx_start) = rri_AF_label.start_rr_index(idx_start) + length(raw_rri);
        idx_end = find(rri_AF_label.end_file_index >= j);
        rri_AF_label.end_rr_index(idx_end) = rri_AF_label.end_rr_index(idx_end) + length(raw_rri);
    end
    clearvars idx_start idx_end raw_signal raw_rri;

    afIdx = find(ecg_AF_label.nsr_before_duration >= segments);
    if(isempty(afIdx))
        continue;
    end
    
    for idx = 1:length(afIdx)
        signal_AF = signal(ecg_AF_label.start_qrs_index(afIdx(idx)):ecg_AF_label.end_qrs_index(afIdx(idx)));    
        rri_AF = rri(rri_AF_label.start_rr_index(afIdx(idx)):rri_AF_label.end_rr_index(afIdx(idx)));
            
        signal_before = signal(1,ecg_AF_label.start_qrs_index(afIdx(idx))-fs*segments:ecg_AF_label.start_qrs_index(afIdx(idx))-1);
        rri_fs = 1000;
        sum_rri = 0;
        rri_idx = rri_AF_label.start_rr_index(afIdx(idx))-1;
        target_duration = rri_fs*segments;
        
        while(sum_rri < target_duration) && (rri_idx > 0)
        sum_rri = sum_rri + rri(rri_idx);
        if(sum_rri > target_duration)
            sum_rri = sum_rri - rri(rri_idx);
            rri_idx = rri_idx + 1;
            break;
        end
            rri_idx = rri_idx-1;
        end
        rri_before = rri(rri_idx:rri_AF_label.start_rr_index(afIdx(idx))-1);
        fileName = fullfile(savePath, sprintf("IRIDIA_%d_%d.mat", i-1, j));
        save(fileName,"rri_before","signal_before","signal_AF","rri_AF","fs","rri_fs");
    end
end