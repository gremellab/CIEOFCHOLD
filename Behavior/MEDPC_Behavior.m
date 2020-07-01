function [Data] = MEDPC_Behavior()
%BEHAVIOR Summary of this function goes here
% The goal of this program is to take raw MEDPC data and produce usable
% information on the timing of each event type (licks, lever presses, head
% entries, reinforcements) and the intervals between events. There is
% optional code that is commented out for more variables or figures. This
% was last updated 3/18/19 by Christian Cazares & Drew Schreiner.
%(Gremel Lab, UCSD Dept of Psychology. Support: Please contact cazares at
% ucsd.edu)
format long %make sure matlab doesn't truncate your numbers or use scientific notation
%% -----Specify what behavior you want to extract by letter assignment with MEDPC variables as reference (i.e. LP, HE, REIN)----- %%
Alphabet = 'ABDEFGHIJKLMNOPQRSTUVWXYZC';%modified alphabet because for some reason MEDPC puts C last
LP_var = 'Q'; HE_var = 'B'; REIN_var = 'D'; Hold_Criteria_var = 'L'; %specify MEDPC variable for your behavior
LP = []; HE = []; REIN = []; % iniatialize individual behavior matrices
LP_idx = strfind(Alphabet, LP_var); HE_idx = strfind(Alphabet, HE_var); REIN_idx = strfind(Alphabet, REIN_var); % index of behaviors in MEDPC file
Hold_Criteria_idx = strfind(Alphabet, Hold_Criteria_var);
%% -----Set path of your folders containing MEDPC files----- %%
Experiment_name = 'CC-EXP35-CIE-OFC-HOLD-Recording-Behavior'; % Name of experiment (will be named of saved .mat for all of the following)
PathName_Master = 'I:\Christian\MedPC Master';
PathName_Folders = uigetdir(PathName_Master); % Path with MEDPC Folders, click on 'Select Folder' DO NOT DOUBLE CLICK
MedPCFolders = dir(PathName_Folders); % get names of MEDPC Folders
MedPCFolders = MedPCFolders(3:end); %remove invalid directory entries '.' and '..'
cd(PathName_Folders) %change directory to where MEDPC Folders are
Events = cell(1, length(MedPCFolders)); % initialize cell matrix where MEDPC data will be stored
Names = cell(1, length(MedPCFolders));
%% -----Loop through each folder (i.e. experiment day) and within it, each subject to extract event (i.e. timing) and behavior data (i.e. # LPs)----- %%
for day = 1:length(MedPCFolders) % For each MEDPC Folder (day)
    cd([MedPCFolders(day).folder '\' MedPCFolders(day).name]) % Change directory to that folder
    PathName_Folder = cd; % get path of current directory (folder)
    MedPCFiles = dir(PathName_Folder); % get names of individual MEDPC files within that folder
    MedPCFiles = MedPCFiles(3:end); %remove invalid directory entries '.' and '..'
    for mouse = 1:length(MedPCFiles) % for each MEDPC file in this folder (mouse)
        MedPCFileName = MedPCFiles(mouse).name % get MEDPC filename
        subject_vars = importfile_MEDPC(MedPCFileName, 11, 35); % Import first chunk of MEDPC file
        subject_vars = subject_vars(:,1); % remove NaNs in matrix
        %--Get data from first chunk of MEDPC file variables--%
        Data.Day(day).Mouse(mouse).Name = MedPCFileName;
%         Data.Day(day).Mouse(mouse).Total_Lever_Presses = subject_vars (LP_idx); % get Lever presses
%         Data.Day(day).Mouse(mouse).Total_Head_Entries = subject_vars (HE_idx); % get Head entries
%         Data.Day(day).Mouse(mouse).Total_Reinforcers_Earned = subject_vars (REIN_idx); % get Reinforcers earned
        Data.Day(day).Mouse(mouse).Hold_Criteria = subject_vars(Hold_Criteria_idx) * 10; % Criteria in milliseconds
        Data.Day(day).Mouse(mouse).Events_Matrix = importfile_MEDPC(MedPCFileName, 37, 500000); % Import event and timing data
        subject_beh = Data.Day(day).Mouse(mouse).Events_Matrix; % MEDPC Event and Timing matrix of current subject
        %% Get Timestamps of Each Event
        time = reshape(((floor(subject_beh))'),[],1); % Get the integer part of the number (ie: timestamp from previous event)
        time(isnan(time)) = []; % Remove NaNs
        time = cumsum(time)*10; % Cumulative sum of event timestamps
        event = (reshape(((subject_beh-floor(subject_beh))'),[],1)) * 100; %Get the decimal part of the number (ie: the type of event)
        event(isnan(event)) = []; % Remove NaNs
        time_with_events = cat(2,event,time);   % Concatenate time and events
        time_with_events(any(isnan(time_with_events), 2), :) = []; % Remove NaNs
        time_with_events(:,1) = round(time_with_events(:,1)); % Round all the event types to remove decimal notation
        time_with_events = unique(time_with_events,'rows','stable'); % Remove duplicates due to med-pc time resolution
        time_with_events(find(time_with_events(:,1) == 30),:) = []; % Removes event code 30
        
        

        %make a for loop to exlude any times there is a lever press that is not
        %paired with a stop variable, due to med-pc time resolution
        for z = 1:length(time_with_events)
            if time_with_events(z,1) ==10
                if isempty(find(time_with_events(z:end) == 15))
                    time_with_events(z,:) = NaN;
                end
            end
        end
        %find the last time the .15 variable shows up, add 1 to include the reinforcer .20 if it is there 
        eventlengthARRAY = []; j = 1; lastleverstop =  find(time_with_events(1:end,1)==31,1,'last');
        while j<lastleverstop  %while loop to go through alllpevents up until just before the 31 session en variable
%            %loop through all the events and find how much time elapses
%            between pairs of events
             eventtime = time_with_events(j,2);
             eventafter = time_with_events(j+1,1);
             eventaftertime = time_with_events(j+1,2);
             eventlength = (eventaftertime-eventtime);
             eventlengthARRAY = [eventlengthARRAY eventlength];
            j = j +1;
        end
        time_with_events(find(time_with_events(:,1) == 31,1,'last'):end,:) = []; % Removes event code 31
        try
            time_with_events = [time_with_events [(eventlengthARRAY)'; NaN]];
        catch
            time_with_events = [time_with_events [(eventlengthARRAY)']];
        end
        Data.Day(day).Mouse(mouse).Events_Time_Matrix = time_with_events; % Add to structure array
        
                %% First 5 mins DV test
%         if day == 11 || day == 12
%             1
%             first_5_mins_idx = find(time_with_events(:,2) <= 300000);
%             time_with_events = time_with_events(first_5_mins_idx,:);
%         end
        %% Lever Press
        Lever_Press_Matrix = time_with_events(find(time_with_events(:,1) == 10),:); % Matrix of event code, timestamp, and lenght
        Lever_Press_idx = find(time_with_events(:,1) == 10); % Index of when Lever Press Ocurred
        Lever_Press_Lengths = Lever_Press_Matrix(:,3)-20; % Subtract 20 to get true resolution of lever press lenghts
        Lever_Press_True_End = Lever_Press_Matrix(:,2) + Lever_Press_Matrix(:,3); % Lever Press Stop Timestamp
        Lever_Press_IPI = Lever_Press_Matrix(2:end,2) - Lever_Press_True_End(1:end-1); % Lever Press Inter Press Interval
        Lever_Press_ts = Lever_Press_Matrix(:,2); % Timestamps of when Lever Press Ocurred
        %Lever_Press_Rate_per_Sec = (time(end) / 1000) / length(Lever_Press_Lengths)
        Lever_Press_Rate_per_Min = length(Lever_Press_Lengths) / ((time(end) / 1000) /60);
        
        Data.Day(day).Mouse(mouse).Lever_Press_ts = Lever_Press_ts;
        Data.Day(day).Mouse(mouse).Lever_Press_Lengths = Lever_Press_Lengths;
        Data.Day(day).Mouse(mouse).Lever_Press_IPI = Lever_Press_IPI;
        Data.Day(day).Mouse(mouse).Lever_Press_idx = Lever_Press_idx;
        
        Data.Day(day).Mouse(mouse).Means.Lever_Press_rate = Lever_Press_Rate_per_Min;
        Data.Day(day).Mouse(mouse).Means.Total_Lever_Presses = length(Lever_Press_ts); % get total Lever presses
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Lengths_Mean = mean(Lever_Press_Lengths);
        Data.Day(day).Mouse(mouse).Means.Lever_Press_IPI_Mean = mean(Lever_Press_IPI);
        %% Lever Press Performance
        Lever_Press_Rewarded_idx = find(Lever_Press_Lengths >= Data.Day(day).Mouse(mouse).Hold_Criteria); % Index of when successful Lever Press Ocurred
        Lever_Press_Rewarded_Lengths = Lever_Press_Lengths(Lever_Press_Rewarded_idx); % Length successful Lever Press
        Lever_Press_Not_Rewarded_idx = find(~(Lever_Press_Lengths >= Data.Day(day).Mouse(mouse).Hold_Criteria)); % Index of when unsuccessful Lever Press Ocurred
        Lever_Press_Not_Rewarded_Lengths = Lever_Press_Lengths(Lever_Press_Not_Rewarded_idx); % Length unsuccessful Lever Press
        
        Data.Day(day).Mouse(mouse).Lever_Press_Rewarded_idx = Lever_Press_Rewarded_idx;
        Data.Day(day).Mouse(mouse).Lever_Press_Rewarded_Lengths = Lever_Press_Rewarded_Lengths;
        Data.Day(day).Mouse(mouse).Lever_Press_Not_Rewarded_idx = Lever_Press_Not_Rewarded_idx;
        Data.Day(day).Mouse(mouse).Lever_Press_Not_Rewarded_Lengths = Lever_Press_Not_Rewarded_Lengths;
        
        Data.Day(day).Mouse(mouse).Means.Total_Reinforcers_Earned = length(Lever_Press_Rewarded_Lengths); % get Reinforcers earned
        Data.Day(day).Mouse(mouse).Means.Criteria_Met_Percent = (length(Lever_Press_Rewarded_Lengths)/length(Lever_Press_ts))*100; % get Reinforcers earned
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Rewarded_Lengths_Mean = mean(Lever_Press_Rewarded_Lengths);
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Not_Rewarded_Lengths_Mean = mean(Lever_Press_Not_Rewarded_Lengths);
        %% Feedback
        Lever_Press_Length_After_Success_idx = Lever_Press_Rewarded_idx + 1; % Look for lever press index after success
        Lever_Press_Length_After_Failure_idx = Lever_Press_Not_Rewarded_idx + 1; % Look for lever press index after failure
        Lever_Press_Length_After_Success_remove_idx = find(Lever_Press_Length_After_Success_idx > length(Lever_Press_ts)); % Remove indices outside total lever presses
        Lever_Press_Length_After_Failure_remove_idx = find(Lever_Press_Length_After_Failure_idx > length(Lever_Press_ts)); % Remove indices outside total lever presses
        Lever_Press_Length_After_Success = Lever_Press_Lengths(Lever_Press_Length_After_Success_idx(1:end-length(Lever_Press_Length_After_Success_remove_idx))); % Lever Press Length at n+1 after success
        Lever_Press_Length_After_Failure = Lever_Press_Lengths(Lever_Press_Length_After_Failure_idx(1:end-length(Lever_Press_Length_After_Failure_remove_idx))); % Lever Press Length at n+1 after failure
        Lever_Press_Length_After_Success_Change = Lever_Press_Length_After_Success... % Lever Press Duration change at n+1 after success
            - Lever_Press_Lengths(Lever_Press_Rewarded_idx(1:end-length(Lever_Press_Length_After_Success_remove_idx)));
        Lever_Press_Length_After_Failure_Change = Lever_Press_Length_After_Failure...% Lever Press Duration change at n+1 after failure
            - Lever_Press_Lengths(Lever_Press_Not_Rewarded_idx(1:end-length(Lever_Press_Length_After_Failure_remove_idx)));
        
        Data.Day(day).Mouse(mouse).Lever_Press_Length_After_Success = Lever_Press_Length_After_Success;
        Data.Day(day).Mouse(mouse).Lever_Press_Length_After_Failure = Lever_Press_Length_After_Failure;
        Data.Day(day).Mouse(mouse).Lever_Press_Length_After_Success_Change = Lever_Press_Length_After_Success_Change;
        Data.Day(day).Mouse(mouse).Lever_Press_Length_After_Failure_Change = Lever_Press_Length_After_Failure_Change;
        
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Length_After_Success_Mean = mean(Lever_Press_Length_After_Success);
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Length_After_Failure_Mean = mean(Lever_Press_Length_After_Failure);
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Length_After_Success_Change_Mean = mean(Lever_Press_Length_After_Success_Change);
        Data.Day(day).Mouse(mouse).Means.Lever_Press_Length_After_Failure_Change_Mean = mean(Lever_Press_Length_After_Failure_Change);
        
        %% Duration Distributions
        if Data.Day(day).Mouse(mouse).Hold_Criteria == 800
            %edges_end = 2000;
            %edges = 0:200:edges_end;
            edges_end = 4000;
            edges = 0:400:edges_end;
        elseif Data.Day(day).Mouse(mouse).Hold_Criteria == 1600
            edges_end = 4000;
            edges = 0:400:edges_end;
        end

        Data.Day(day).Mouse(mouse).Duration_Distribution = histcounts(Lever_Press_Lengths,edges, 'Normalization', 'probability');
        Data.Day(day).Mouse(mouse).Median_Duration = median(Lever_Press_Lengths);
        %% State Performance
        % Determine States via cumulative sum of lever press lengths
        [Up_State_idx] = cusum(Lever_Press_Lengths,2,1,mean(Lever_Press_Lengths),std(Lever_Press_Lengths),'all');
        %[Up_State_idx,ilower,uppersum,lowersum] = cusum(Lever_Press_Lengths,2,1,mean(Lever_Press_Lengths),std(Lever_Press_Lengths),'all');
        Up_State_Lengths = Lever_Press_Lengths(Up_State_idx); % Lever Press Lengths in upstate
        Up_State_ts = Lever_Press_ts(Up_State_idx); % Timestamp of Lever Press in upstate
        
        Up_State_Reward_idx = intersect(Lever_Press_Rewarded_idx,Up_State_idx); % Index of up-state rewarded presses
        Up_State_Reward_Lengths = Lever_Press_Lengths(Up_State_Reward_idx); % Length of up-state rewarded presses
        Up_State_Reward_ts = Lever_Press_ts(Up_State_Reward_idx); % Timestamp of up-state rewarded presses
        
        Up_State_Fail_idx = intersect(Lever_Press_Not_Rewarded_idx,Up_State_idx); % Index of up-state unrewarded presses
        Up_State_Fail_Lengths = Lever_Press_Lengths(Up_State_Fail_idx); % Length of up-state unrewarded presses
        Up_State_Fail_ts = Lever_Press_ts(Up_State_Fail_idx); % Timestamp of up-state unrewarded presses
        

        Down_State_idx = setxor(1:length(Lever_Press_Lengths),Up_State_idx); % Index of down-state presses
        Down_State_Lengths = Lever_Press_Lengths(Down_State_idx); % Length of down-state presses
        Down_State_ts =  Lever_Press_ts(Down_State_idx); % Timestamp of down-state presses
        
        Down_State_Reward_idx = intersect(Lever_Press_Rewarded_idx,Down_State_idx); % Index of down-state rewarded presses
        Down_State_Reward_Lengths = Lever_Press_Lengths(Down_State_Reward_idx); % Length of down-state rewarded presses
        Down_State_Reward_ts = Lever_Press_ts(Down_State_Reward_idx); % Timestamp of down-state rewarded presses
        
        Down_State_Fail_idx = intersect(Lever_Press_Not_Rewarded_idx,Down_State_idx); % Index of down-state unrewarded presses
        Down_State_Fail_Lengths = Lever_Press_Lengths(Down_State_Fail_idx); % Length of down-state unrewarded presses
        Down_State_Fail_ts = Lever_Press_ts(Down_State_Fail_idx); % Timestamp of down-state unrewarded presses
        
        Consecutive_Up_State_LPs = diff( [0; find(diff(Up_State_idx) ~= 1); length(Up_State_idx)]); % chunked # of consecutive LPs in Up State
        Consecutive_Down_State_LPs = diff( [0; find(diff(Down_State_idx) ~= 1); length(Down_State_idx)]); % chunked # of consecutive LPs in Up State
        
        %Consecutive_Up_State_LPs_Lengths = sort([find(diff(Up_State_idx) ~= 1); find(diff(Up_State_idx) == 1)]); % chunked # of consecutive LPs in Up State
        %Consecutive_Down_State_LPs_Lengths = diff( [0; find(diff(Down_State_idx) ~= 1); length(Down_State_idx)]); % chunked # of consecutive LPs in Up State
        
        Data.Day(day).Mouse(mouse).Up_State_idx = Up_State_idx;
        Data.Day(day).Mouse(mouse).Up_State_Lengths = Up_State_Lengths;
        Data.Day(day).Mouse(mouse).Up_State_ts = Up_State_ts;
        Data.Day(day).Mouse(mouse).Up_State_Reward_idx = Up_State_Reward_idx;
        Data.Day(day).Mouse(mouse).Up_State_Reward_Lengths = Up_State_Reward_Lengths;
        Data.Day(day).Mouse(mouse).Up_State_Reward_ts = Up_State_Reward_ts;
        Data.Day(day).Mouse(mouse).Up_State_Fail_idx = Up_State_Fail_idx;
        Data.Day(day).Mouse(mouse).Up_State_Fail_Lengths = Up_State_Fail_Lengths;
        Data.Day(day).Mouse(mouse).Up_State_Fail_ts = Up_State_Fail_ts;
        Data.Day(day).Mouse(mouse).Consecutive_Up_State_LPs = Consecutive_Up_State_LPs ;
        
        Data.Day(day).Mouse(mouse).Means.Up_State_Lengths_Mean = mean(Up_State_Lengths);
        Data.Day(day).Mouse(mouse).Means.Up_State_Reward_Lengths_Mean = mean(Up_State_Reward_Lengths);
        Data.Day(day).Mouse(mouse).Means.Up_State_Fail_Lengths_Mean = mean(Up_State_Fail_Lengths);
        Data.Day(day).Mouse(mouse).Means.Consecutive_Up_State_LPs_Mean = mean(Consecutive_Up_State_LPs);
        
        Data.Day(day).Mouse(mouse).Down_State_idx = Down_State_idx;
        Data.Day(day).Mouse(mouse).Down_State_Lengths = Down_State_Lengths;
        Data.Day(day).Mouse(mouse).Down_State_ts = Down_State_ts;
        Data.Day(day).Mouse(mouse).Down_State_Reward_idx = Down_State_Reward_idx;
        Data.Day(day).Mouse(mouse).Down_State_Reward_Lengths = Down_State_Reward_Lengths;
        Data.Day(day).Mouse(mouse).Down_State_Reward_ts = Down_State_Reward_ts;
        Data.Day(day).Mouse(mouse).Down_State_Fail_idx = Down_State_Fail_idx;
        Data.Day(day).Mouse(mouse).Down_State_Fail_Lengths = Down_State_Fail_Lengths;
        Data.Day(day).Mouse(mouse).Down_State_Fail_ts = Down_State_Fail_ts;
        Data.Day(day).Mouse(mouse).Consecutive_Down_State_LPs = Consecutive_Down_State_LPs;
        
        Data.Day(day).Mouse(mouse).Means.Down_State_Lengths_Mean = mean(Down_State_Lengths);
        Data.Day(day).Mouse(mouse).Means.Down_State_Reward_Lengths_Mean = mean(Down_State_Reward_Lengths);
        Data.Day(day).Mouse(mouse).Means.Down_State_Fail_Lengths_Mean = mean(Down_State_Fail_Lengths);
        Data.Day(day).Mouse(mouse).Means.Consecutive_Down_State_LPs_Mean = mean(Consecutive_Down_State_LPs);
        %% n-x lever press lengths
        
        x = 1 ;
        Lever_Press_n_1_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_1_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_1_Lengths = Lever_Press_n_1_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_1_Lengths_Mean = nanmean(Lever_Press_n_1_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_1_ts = Lever_Press_n_1_ts;
        
        x = 2 ;
        Lever_Press_n_2_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_2_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_2_Lengths = Lever_Press_n_2_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_2_Lengths_Mean = nanmean(Lever_Press_n_2_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_2_ts = Lever_Press_n_2_ts;
        
        x = 3 ;
        Lever_Press_n_3_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_3_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_3_Lengths = Lever_Press_n_3_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_3_Lengths_Mean = nanmean(Lever_Press_n_3_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_3_ts = Lever_Press_n_3_ts;
        
        x = 4 ;
        Lever_Press_n_4_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_4_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_4_Lengths = Lever_Press_n_4_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_4_Lengths_Mean = nanmean(Lever_Press_n_4_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_4_ts = Lever_Press_n_4_ts;
        
        x = 5 ;
        Lever_Press_n_5_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_5_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_5_Lengths = Lever_Press_n_5_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_5_Lengths_Mean = nanmean(Lever_Press_n_5_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_5_ts = Lever_Press_n_5_ts;
        
        x = 10 ;
        Lever_Press_n_10_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_10_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_10_Lengths = Lever_Press_n_10_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_10_Lengths_Mean = nanmean(Lever_Press_n_10_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_10_ts = Lever_Press_n_10_ts;
        
        x = 20 ;
        Lever_Press_n_20_Lengths = [nan(1,x)'; Lever_Press_Lengths(1:end-x)]; % n-x lever press lengths
        Lever_Press_n_20_ts = [nan(1,x)'; Lever_Press_ts(1:end-x)]; % n-x lever press timestamps
        Data.Day(day).Mouse(mouse).Lever_Press_n_20_Lengths = Lever_Press_n_20_Lengths;
        Data.Day(day).Mouse(mouse).Means.Lever_Press_n_20_Lengths_Mean = nanmean(Lever_Press_n_20_Lengths);
        Data.Day(day).Mouse(mouse).Lever_Press_n_20_ts = Lever_Press_n_20_ts;
        %% Proportion of correct lever presses for 10 equidistant bins across session
        Criteria = Data.Day(day).Mouse(mouse).Hold_Criteria;
        Timestamps = Lever_Press_ts;
        end_ts = Data.Day(day).Mouse(mouse).Events_Time_Matrix(end,2);
        if isnan(end_ts)
            end_ts = Data.Day(day).Mouse(mouse).Events_Time_Matrix(end-1,2);
        end
        durations = Lever_Press_Lengths;
        met_Timestamps = Timestamps(durations >= Criteria);
        bin_size = end_ts / 10;
        all_lps = histcounts(Timestamps,0:bin_size:end_ts);
        success_lps = histcounts(met_Timestamps,0:bin_size:end_ts);
        ratio = (success_lps ./ all_lps) * 100;
        Data.Day(day).Mouse(mouse).Ratio_Success = ratio;
        
    end
end
    
    cd(PathName_Folders)


%% ----- Choose where you save your extracted MEDPC data -----%%
cd(PathName_Master) % Change directory to one above each day's folder
save(Experiment_name , 'Data')

%% OPTIONAL: Save data segmented by treatment group

[Air, Eth, Air_Grouped, Eth_Grouped] = Separate_Behavior_Data(Data);
save(Experiment_name , 'Air', 'Eth', 'Air_Grouped', 'Eth_Grouped')

% [Sham, OFC, Sham_Grouped, OFC_Grouped] = Separate_Behavior_Data(Data);
% save(Experiment_name , 'Sham', 'OFC', 'Sham_Grouped', 'OFC_Grouped')
end