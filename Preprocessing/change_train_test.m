clear all;
close all;
clc;

%% for Result 1
% bihPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_AF/','RRI_5min/'); % af2
% cincPath = fullfile(pwd,'data_preprocessed/','CinC2001/','RRI_5min/'); % af3 nsr1
% autoPath = fullfile(pwd,'data_preprocessed/','autonomic/','RRI_5min/'); % nsr2
% afPath = fullfile(pwd,'data_preprocessed/','IRIDIA/','RRI_Sequential_2h/');
% nsrPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_NSR2/','RRI_Sequential_2h/');
% 
% bihFiles = dir(fullfile(bihPath, '*.mat')); 
% cincFiles = dir(fullfile(cincPath, '*.mat')); 
% autoFiles = dir(fullfile(autoPath, '*.mat')); 
% afFiles = dir(fullfile(afPath, '*.mat')); 
% nsrFiles = dir(fullfile(nsrPath, '*.mat')); 
% 
% duration = 5;
% train_data = [];
% train_label = [];
% for i = 1:length(bihFiles)
%     filePath = fullfile(bihPath, bihFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(:,1))
%         train_data(end+1,:) = rri(j,:);
%         train_label(end+1) = 1;
%     end
% end
% 
% train2_data = [];
% train2_label = [];
% for i = 1:length(cincFiles)
%     filePath = fullfile(cincPath, cincFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(:,1))
%         train2_data(end+1,:) = rri(j,:);
%         train2_label(end+1) = y_label;
%     end
% end
% 
% train3_data = [];
% train3_label = [];
% for i = 1:length(autoFiles)
%     filePath = fullfile(autoPath, autoFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(1,:))
%         train3_data(end+1,:) = rri(:,j);
%         train3_label(end+1) = 0;
%     end
% end
% 
% train4_subject = [];
% train4_data = [];
% train4_label = [];
% for i = 1:length(afFiles)
%     filePath = fullfile(afPath, afFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(afFiles(i).name, '_');
%     subject_str = afFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     rri_15min = [];
%     for j = 10:12
%         rri_15min(end+1:end+600) = rri(j,:);
%     end
% 
%     for z = 1:(30/duration)
%         train4_subject(end+1) = 10000+subject_num;
%         train4_data(end+1,:) = rri_15min(1,(z-1)*(duration*60)+1:z*duration*60);
%         train4_label(end+1) = 1;
%     end
% 
% end
% 
% train5_subject = [];
% train5_data = [];
% train5_label = [];
% for i = 1:length(nsrFiles)
%     filePath = fullfile(nsrPath, nsrFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(nsrFiles(i).name, '_');
%     subject_str = nsrFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     rri_15min = [];
%     for j = 7:12
%         rri_15min(end+1:end+600) = rri(j,:);
%     end
% 
%     for z = 1:(60/duration)
%         train5_subject(end+1) = 11000+subject_num;
%         train5_data(end+1,:) = rri_15min(1,(z-1)*(duration*60)+1:z*duration*60);
%         train5_label(end+1) = 0;
%     end
% 
% end
% 
% save("data_RRI_short_term_5min_final.mat");


%% for result 2
% bihPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_AF/','RRI_10min/'); % af2
% cincPath = fullfile(pwd,'data_preprocessed/','CinC2001/','RRI_10min/'); % af3 nsr1
% autoPath = fullfile(pwd,'data_preprocessed/','autonomic/','RRI_10min/'); % nsr2
% afPath = fullfile(pwd,'data_preprocessed/','IRIDIA/','RRI_Sequential_30min/');
% nsrPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_NSR2/','RRI_Sequential_3h/');
% 
% bihFiles = dir(fullfile(bihPath, '*.mat')); 
% cincFiles = dir(fullfile(cincPath, '*.mat')); 
% autoFiles = dir(fullfile(autoPath, '*.mat')); 
% afFiles = dir(fullfile(afPath, '*.mat')); 
% nsrFiles = dir(fullfile(nsrPath, '*.mat')); 
% 
% duration = 10;
% train_data = [];
% train_label = [];
% for i = 1:length(bihFiles)
%     filePath = fullfile(bihPath, bihFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(:,1))
%         train_data(end+1,:) = rri(j,:);
%         train_label(end+1) = 1;
%     end
% end
% 
% train2_data = [];
% train2_label = [];
% for i = 1:length(cincFiles)
%     filePath = fullfile(cincPath, cincFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(:,1))
%         train2_data(end+1,:) = rri(j,:);
%         train2_label(end+1) = y_label;
%     end
% end
% 
% train3_data = [];
% train3_label = [];
% for i = 1:length(autoFiles)
%     filePath = fullfile(autoPath, autoFiles(i).name);
%     load(filePath);
% 
%     for j = 1:length(rri(1,:))
%         train3_data(end+1,:) = rri;
%         train3_label(end+1) = 0;
%     end
% end
% 
% train4_subject = [];
% train4_data = [];
% train4_label = [];
% for i = 1:length(afFiles)
%     filePath = fullfile(afPath, afFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(afFiles(i).name, '_');
%     subject_str = afFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train4_subject(end+1) = 10000+subject_num;
%         train4_data(end+1,:) = rri(j,:);
%         train4_label(end+1) = 1;
%     end
% end
% 
% train5_subject = [];
% train5_data = [];
% train5_label = [];
% for i = 1:length(nsrFiles)
%     filePath = fullfile(nsrPath, nsrFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(nsrFiles(i).name, '_');
%     subject_str = nsrFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 13:18
%         train5_subject(end+1) = 11000+subject_num;
%         train5_data(end+1,:) = rri(j,:);
%         train5_label(end+1) = 0;
%     end
% end
% 
% save("data_RRI_short_term_final_3h.mat");

%% for result 2
% afPath = fullfile(pwd,'data_preprocessed/','IRIDIA/','RRI_Sequential_3h/');
% nsrPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_NSR2/','RRI_Sequential_3h/');
% 
% train_subject = [];
% train_data = [];
% train_label = [];
% train2_subject = [];
% train2_data = [];
% train2_label = [];
% 
% afFiles = dir(fullfile(afPath, '*.mat')); 
% nsrFiles = dir(fullfile(nsrPath, '*.mat')); 
% 
% for i = 1:length(afFiles)
%     filePath = fullfile(afPath, afFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(afFiles(i).name, '_');
%     subject_str = afFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train_subject(i) = 10000+subject_num;
%         train_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train_label(i) = 1;
%     end
% end
% 
% for i = 1:length(nsrFiles)
%     filePath = fullfile(nsrPath, nsrFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(nsrFiles(i).name, '_');
%     subject_str = nsrFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train2_subject(i) = 11000+subject_num;
%         train2_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train2_label(i) = 0;
%     end
% end
% 
% save('data_RRI_long_term_3h.mat');

%% for Result 3
% afPath = fullfile(pwd,'data_preprocessed/','IRIDIA/','RRI_Sequential_3h/');
% af2Path = fullfile(pwd,'data_preprocessed/','longterm_AF/','RRI_Sequential_3h/');
% nsrPath = fullfile(pwd,'data_preprocessed/','MIT-BIH_NSR2/','RRI_Sequential_3h/');
% nsr2Path = fullfile(pwd,'data_preprocessed/','MIT-BIH_NSR/','RRI_Sequential_3h/');
% 
% train_subject = [];
% train_data = [];
% train_label = [];
% train2_subject = [];
% train2_data = [];
% train2_label = [];
% 
% afFiles = dir(fullfile(afPath, '*.mat')); 
% af2Files = dir(fullfile(af2Path, '*.mat')); 
% nsrFiles = dir(fullfile(nsrPath, '*.mat')); 
% nsr2Files = dir(fullfile(nsr2Path, '*.mat')); 
% 
% 
% for i = 1:length(af2Files)
%     filePath = fullfile(af2Path, af2Files(i).name);
%     load(filePath)
%     underscore_idx = strfind(af2Files(i).name, '_');
%     subject_str = af2Files(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train_subject(i) = subject_num;
%         train_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train_label(i) = 1;
%     end
% end
% 
% for i = 1:length(nsr2Files)
%     filePath = fullfile(nsr2Path, nsr2Files(i).name);
%     load(filePath)
%     underscore_idx = strfind(nsr2Files(i).name, '_');
%     subject_str = nsr2Files(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train2_subject(i) = 1000+subject_num;
%         train2_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train2_label(i) = 0;
%     end
% end
% 
% for i = 1:length(afFiles)
%     filePath = fullfile(afPath, afFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(afFiles(i).name, '_');
%     subject_str = afFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train3_subject(i) = 10000+subject_num;
%         train3_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train3_label(i) = 1;
%     end
% end
% 
% for i = 1:length(nsrFiles)
%     filePath = fullfile(nsrPath, nsrFiles(i).name);
%     load(filePath)
%     underscore_idx = strfind(nsrFiles(i).name, '_');
%     subject_str = nsrFiles(i).name(4:underscore_idx-1);
%     subject_num = str2double(subject_str);
% 
%     for j = 1:length(rri(:,1))
%         train4_subject(i) = 11000+subject_num;
%         train4_data(i,(j-1)*600+1:(j)*600) = rri(j,:);
%         train4_label(i) = 0;
%     end
% end
% 
% save('data_RRI_long_term_2h.mat');

