function [Regression] = makeTable(Day)
time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
time_LPON_1 = -1000;
time_LPON_2 = 0;
time_LPOFF_1 = 0;
time_LPOFF_2 = 1000;
% Mouse and Unit Counters
curr_mouse = 0;
curr_unit  = 1;
curr_LP_ON_up_unit = 1;
curr_LP_ON_down_unit = 1;
curr_LP_OFF_up_unit = 1;
curr_LP_OFF_down_unit = 1;

curr_unit_success  = 1;
curr_unit_failure  = 1;
curr_unit_after_success  = 1;
curr_unit_after_failure  = 1;
curr_unit_before_success  = 1;
curr_unit_before_failure  = 1;

curr_LP_ON_up_unit_success = 1;
curr_LP_ON_up_unit_failure = 1;
curr_LP_ON_up_unit_after_success = 1;
curr_LP_ON_up_unit_after_failure = 1;

curr_LP_ON_down_unit_success = 1;
curr_LP_ON_down_unit_failure = 1;
curr_LP_ON_down_unit_after_success = 1;
curr_LP_ON_down_unit_after_failure = 1;

curr_LP_OFF_up_unit_success = 1;
curr_LP_OFF_up_unit_failure = 1;
curr_LP_OFF_up_unit_after_success = 1;
curr_LP_OFF_up_unit_after_failure = 1;

curr_LP_OFF_down_unit_success = 1;
curr_LP_OFF_down_unit_failure = 1;
curr_LP_OFF_down_unit_after_success = 1;
curr_LP_OFF_down_unit_after_failure = 1;

All_Units_Array = [];
LP_ON_Up_Units_Array = [];
LP_ON_Down_Units_Array = [];
LP_OFF_Up_Units_Array = [];
LP_OFF_Down_Units_Array = [];

All_Units_Array_Success = [];
LP_ON_Up_Units_Array_Success = [];
LP_ON_Down_Units_Array_Success = [];
LP_OFF_Up_Units_Array_Success = [];
LP_OFF_Down_Units_Array_Success = [];

All_Units_Array_Failure = [];
LP_ON_Up_Units_Array_Failure = [];
LP_ON_Down_Units_Array_Failure = [];
LP_OFF_Up_Units_Array_Failure = [];
LP_OFF_Down_Units_Array_Failure = [];

All_Units_Array_After_Success = [];
LP_ON_Up_Units_Array_After_Success = [];
LP_ON_Down_Units_Array_After_Success = [];
LP_OFF_Up_Units_Array_After_Success = [];
LP_OFF_Down_Units_Array_After_Success = [];

All_Units_Array_After_Failure = [];
LP_ON_Up_Units_Array_After_Failure = [];
LP_ON_Down_Units_Array_After_Failure = [];
LP_OFF_Up_Units_Array_After_Failure = [];
LP_OFF_Down_Units_Array_After_Failure = [];

All_Units_Array_Before_Success = [];
LP_ON_Up_Units_Array_Before_Success = [];
LP_ON_Down_Units_Array_Before_Success = [];
LP_OFF_Up_Units_Array_Before_Success = [];
LP_OFF_Down_Units_Array_Before_Success = [];

All_Units_Array_Before_Failure = [];
LP_ON_Up_Units_Array_Before_Failure = [];
LP_ON_Down_Units_Array_Before_Failure = [];
LP_OFF_Up_Units_Array_Before_Failure = [];
LP_OFF_Down_Units_Array_Before_Failure = [];

for mouse = 1:size(Day.Mouse ,2)
    % Find indices of success, failure, and following lever press
    success_idx = find(Day.Mouse(mouse).Session.LP_Length >= Day.Mouse(mouse).Session.Criteria);
    failure_idx = find(Day.Mouse(mouse).Session.LP_Length < Day.Mouse(mouse).Session.Criteria);
    after_success_idx = find(Day.Mouse(mouse).Session.LP_Length >= Day.Mouse(mouse).Session.Criteria) + 1;
    after_failure_idx = find(Day.Mouse(mouse).Session.LP_Length < Day.Mouse(mouse).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(Day.Mouse(mouse).Session.LP_Length))) = [];
    after_failure_idx(find(after_failure_idx > length(Day.Mouse(mouse).Session.LP_Length))) = [];
    success_idx(find(success_idx == length(Day.Mouse(mouse).Session.LP_Length))) = [];
    failure_idx(find(failure_idx == length(Day.Mouse(mouse).Session.LP_Length))) = [];
    before_success_idx = find(Day.Mouse(mouse).Session.LP_Length >= Day.Mouse(mouse).Session.Criteria) - 1;
    before_failure_idx = find(Day.Mouse(mouse).Session.LP_Length < Day.Mouse(mouse).Session.Criteria) - 1;
    before_success_idx(find(before_success_idx <= 0)) = []; 
    before_failure_idx(find(before_failure_idx <= 0)) = [];
    
    %% Update Mouse and Session Counters
    if rem(mouse,2) == 0
        session = 2;
    else
        session = 1;
        curr_mouse = curr_mouse + 1;
    end
    % Total Lever Presses
    Total_LPs = ones(length(Day.Mouse(mouse).Session.LP_Length),1);
    % All units (including non-significant)
    for unit = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data)
        Pre_LP_Rate = nan(length(Total_LPs),1);
        Post_LP_Rate = nan(length(Total_LPs),1);
        for lever_press = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2)); 
        end
        Duration = Day.Mouse(mouse).Session.LP_Length;
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(:,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(:,1);
        
        Hold_1_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,1);
        Hold_2_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,2);
        Hold_3_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,3);
        Hold_4_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,4);
        Hold_1_Rate = Hold_1_Count ./ (Duration ./ 4);
        Hold_2_Rate = Hold_2_Count ./ (Duration ./ 4);
        Hold_3_Rate = Hold_3_Count ./ (Duration ./ 4);
        Hold_4_Rate = Hold_4_Count ./ (Duration ./ 4);
        
        
        Hold_1_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,1);
        Hold_2_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,2);
        Hold_3_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,3);
        Hold_4_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,4);
        
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array = [All_Units_Array; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File Hold_1_Count Hold_2_Count Hold_3_Count Hold_4_Count Hold_1_Z_Mean Hold_2_Z_Mean Hold_3_Z_Mean Hold_4_Z_Mean];
        % Update Unit Counter
        curr_unit  = curr_unit + 1;
    end
    
    % LP Onset Significant units
    LP_ON_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}))]);
    LP_ON_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}))]);
    for unit = LP_ON_Up_Sig_Units_Idx
        Pre_LP_Rate = nan(length(Total_LPs),1);
        Post_LP_Rate = nan(length(Total_LPs),1);
        for lever_press = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2)); 
        end
        Duration = Day.Mouse(mouse).Session.LP_Length;
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(:,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(:,1);
        
        Hold_1_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,1);
        Hold_2_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,2);
        Hold_3_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,3);
        Hold_4_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,4);
        Hold_1_Rate = Hold_1_Count ./ (Duration ./ 4);
        Hold_2_Rate = Hold_2_Count ./ (Duration ./ 4);
        Hold_3_Rate = Hold_3_Count ./ (Duration ./ 4);
        Hold_4_Rate = Hold_4_Count ./ (Duration ./ 4);
        
        Hold_1_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,1);
        Hold_2_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,2);
        Hold_3_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,3);
        Hold_4_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,4);
        
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_ON_up_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array = [LP_ON_Up_Units_Array; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File Hold_1_Count Hold_2_Count Hold_3_Count Hold_4_Count Hold_1_Z_Mean Hold_2_Z_Mean Hold_3_Z_Mean Hold_4_Z_Mean];
        % Update Unit Counter
        curr_LP_ON_up_unit  = curr_LP_ON_up_unit + 1;
    end
    for unit = LP_ON_Down_Sig_Units_Idx
        Pre_LP_Rate = nan(length(Total_LPs),1);
        Post_LP_Rate = nan(length(Total_LPs),1);
        for lever_press = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2)); 
        end
        Duration = Day.Mouse(mouse).Session.LP_Length;
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(:,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(:,1);
        
        Hold_1_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,1);
        Hold_2_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,2);
        Hold_3_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,3);
        Hold_4_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,4);
        Hold_1_Rate = Hold_1_Count ./ (Duration ./ 4);
        Hold_2_Rate = Hold_2_Count ./ (Duration ./ 4);
        Hold_3_Rate = Hold_3_Count ./ (Duration ./ 4);
        Hold_4_Rate = Hold_4_Count ./ (Duration ./ 4);
        
        Hold_1_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,1);
        Hold_2_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,2);
        Hold_3_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,3);
        Hold_4_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,4);
        
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_ON_down_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array = [LP_ON_Down_Units_Array; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File Hold_1_Count Hold_2_Count Hold_3_Count Hold_4_Count Hold_1_Z_Mean Hold_2_Z_Mean Hold_3_Z_Mean Hold_4_Z_Mean];
        % Update Unit Counter
        curr_LP_ON_down_unit  = curr_LP_ON_down_unit + 1;
    end
    
    % LP Offset Significant units
    LP_OFF_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Up_Mod_Window}))]);
    LP_OFF_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Down_Mod_Window}))]);
    for unit = LP_OFF_Up_Sig_Units_Idx
        Pre_LP_Rate = nan(length(Total_LPs),1);
        Post_LP_Rate = nan(length(Total_LPs),1);
        for lever_press = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
        end
        Duration = Day.Mouse(mouse).Session.LP_Length;
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(:,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(:,1);
        
        Hold_1_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,1);
        Hold_2_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,2);
        Hold_3_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,3);
        Hold_4_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,4);
        Hold_1_Rate = Hold_1_Count ./ (Duration ./ 4);
        Hold_2_Rate = Hold_2_Count ./ (Duration ./ 4);
        Hold_3_Rate = Hold_3_Count ./ (Duration ./ 4);
        Hold_4_Rate = Hold_4_Count ./ (Duration ./ 4);
        
        Hold_1_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,1);
        Hold_2_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,2);
        Hold_3_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,3);
        Hold_4_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,4);
        
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_OFF_up_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Up_Units_Array = [LP_OFF_Up_Units_Array; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File Hold_1_Count Hold_2_Count Hold_3_Count Hold_4_Count Hold_1_Z_Mean Hold_2_Z_Mean Hold_3_Z_Mean Hold_4_Z_Mean];
        % Update Unit Counter
        curr_LP_OFF_up_unit  = curr_LP_OFF_up_unit + 1;
    end
    for unit = LP_OFF_Down_Sig_Units_Idx
        Pre_LP_Rate = nan(length(Total_LPs),1);
        Post_LP_Rate = nan(length(Total_LPs),1);
        for lever_press = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(lever_press).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2)); 
        end
        Duration = Day.Mouse(mouse).Session.LP_Length;
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(:,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(:,1);
        
        Hold_1_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,1);
        Hold_2_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,2);
        Hold_3_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,3);
        Hold_4_Count = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_segmented_count(:,4);
        Hold_1_Rate = Hold_1_Count ./ (Duration ./ 4);
        Hold_2_Rate = Hold_2_Count ./ (Duration ./ 4);
        Hold_3_Rate = Hold_3_Count ./ (Duration ./ 4);
        Hold_4_Rate = Hold_4_Count ./ (Duration ./ 4);
        
        Hold_1_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,1);
        Hold_2_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,2);
        Hold_3_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,3);
        Hold_4_Z_Mean = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_all_z_count_mean(:,4);
        
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_OFF_down_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Down_Units_Array = [LP_OFF_Down_Units_Array; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File Hold_1_Count Hold_2_Count Hold_3_Count Hold_4_Count Hold_1_Z_Mean Hold_2_Z_Mean Hold_3_Z_Mean Hold_4_Z_Mean];
        % Update Unit Counter
        curr_LP_OFF_down_unit  = curr_LP_OFF_down_unit + 1;
    end
    
    %% Find spike rates following success and failures
    %% All Units
    % Total Lever Presses of each type of duration
    Total_LPs_Success = ones(length(success_idx),1);
    Total_LPs_Failure = ones(length(failure_idx),1);
    Total_LPs_After_Success = ones(length(after_success_idx),1);
    Total_LPs_After_Failure = ones(length(after_failure_idx),1);
    Total_LPs_Before_Success = ones(length(before_success_idx),1);
    Total_LPs_Before_Failure = ones(length(before_failure_idx),1);
    for unit = 1:length(Day.Mouse(mouse).Session.Events.LPON.PETH_data)
        %% Success
        Pre_LP_Rate = nan(length(Total_LPs_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Success),1);
        for lever_press = 1:length(success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
            
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(success_idx,1);
        Mouse = Total_LPs_Success*curr_mouse;
        Session = Total_LPs_Success*session;
        Unit = Total_LPs_Success*curr_unit_success;
        True_Unit = Total_LPs_Success*unit;
        File = Total_LPs_Success*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_Success = [All_Units_Array_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_success   = curr_unit_success  + 1;
        %% Failure
        Pre_LP_Rate = nan(length(Total_LPs_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Failure),1);
        for lever_press = 1:length(failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(failure_idx,1);
        Mouse = Total_LPs_Failure*curr_mouse;
        Session = Total_LPs_Failure*session;
        Unit = Total_LPs_Failure*curr_unit_failure;
        True_Unit = Total_LPs_Failure*unit;
        File = Total_LPs_Failure*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_Failure = [All_Units_Array_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_failure   = curr_unit_failure  + 1;
        %% After Success, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Success),1);
        for lever_press = 1:length(after_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_success_idx,1);
        Mouse = Total_LPs_After_Success*curr_mouse;
        Session = Total_LPs_After_Success*session;
        Unit = Total_LPs_After_Success*curr_unit_after_success;
        True_Unit = Total_LPs_After_Success*unit;
        File = Total_LPs_After_Success*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_After_Success = [All_Units_Array_After_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_after_success   = curr_unit_after_success  + 1;
        %% After Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        for lever_press = 1:length(after_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_failure_idx,1);
        Mouse = Total_LPs_After_Failure*curr_mouse;
        Session = Total_LPs_After_Failure*session;
        Unit = Total_LPs_After_Failure*curr_unit_after_failure;
        True_Unit = Total_LPs_After_Failure*unit;
        File = Total_LPs_After_Failure*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_After_Failure = [All_Units_Array_After_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_after_failure   = curr_unit_after_failure  + 1;
        
        %% Before Success, All
        Pre_LP_Rate = nan(length(Total_LPs_Before_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Before_Success),1);
        for lever_press = 1:length(before_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(before_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(before_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
            
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(before_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(before_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(before_success_idx,1);
        Mouse = Total_LPs_Before_Success*curr_mouse;
        Session = Total_LPs_Before_Success*session;
        Unit = Total_LPs_Before_Success*curr_unit_before_success;
        True_Unit = Total_LPs_Before_Success*unit;
        File = Total_LPs_Before_Success*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_Before_Success = [All_Units_Array_Before_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_before_success   = curr_unit_before_success  + 1;
        %% Before Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_Before_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Before_Failure),1);
        for lever_press = 1:length(before_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(before_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(before_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
            
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(before_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(before_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(before_failure_idx,1);
        Mouse = Total_LPs_Before_Failure*curr_mouse;
        Session = Total_LPs_Before_Failure*session;
        Unit = Total_LPs_Before_Failure*curr_unit_before_failure;
        True_Unit = Total_LPs_Before_Failure*unit;
        File = Total_LPs_Before_Failure*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array_Before_Failure = [All_Units_Array_Before_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit_before_failure   = curr_unit_before_failure  + 1;
        
    end
    %% LP ON UP Units
    % Total Lever Presses of each type of duration
    Total_LPs_Success = ones(length(success_idx),1);
    Total_LPs_Failure = ones(length(failure_idx),1);
    Total_LPs_After_Success = ones(length(after_success_idx),1);
    Total_LPs_After_Failure = ones(length(failure_idx),1);
    for unit = LP_ON_Up_Sig_Units_Idx
        %% Success
        Pre_LP_Rate = nan(length(Total_LPs_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Success),1);
        for lever_press = 1:length(success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(success_idx,1);
        Mouse = Total_LPs_Success*curr_mouse;
        Session = Total_LPs_Success*session;
        Unit = Total_LPs_Success*curr_LP_ON_up_unit_success;
        True_Unit = Total_LPs_Success*unit;
        File = Total_LPs_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array_Success = [LP_ON_Up_Units_Array_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_up_unit_success   = curr_LP_ON_up_unit_success  + 1;
        %% Failure
        Pre_LP_Rate = nan(length(Total_LPs_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Failure),1);
        for lever_press = 1:length(failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));
        end
        Duration = Day.Mouse(mouse).Session.LP_Length(failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(failure_idx,1);
        Mouse = Total_LPs_Failure*curr_mouse;
        Session = Total_LPs_Failure*session;
        Unit = Total_LPs_Failure*curr_LP_ON_up_unit_failure;
        True_Unit = Total_LPs_Failure*unit;
        File = Total_LPs_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array_Failure = [LP_ON_Up_Units_Array_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_up_unit_failure  = curr_LP_ON_up_unit_failure  + 1;
        %% After Success, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Success),1);
        for lever_press = 1:length(after_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_success_idx,1);
        Mouse = Total_LPs_After_Success*curr_mouse;
        Session = Total_LPs_After_Success*session;
        Unit = Total_LPs_After_Success*curr_LP_ON_up_unit_after_success;
        True_Unit = Total_LPs_After_Success*unit;
        File = Total_LPs_After_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array_After_Success = [LP_ON_Up_Units_Array_After_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_up_unit_after_success   = curr_LP_ON_up_unit_after_success  + 1;
        %% After Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        for lever_press = 1:length(after_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_failure_idx,1);
        Mouse = Total_LPs_After_Failure*curr_mouse;
        Session = Total_LPs_After_Failure*session;
        Unit = Total_LPs_After_Failure*curr_LP_ON_up_unit_after_failure;
        True_Unit = Total_LPs_After_Failure*unit;
        File = Total_LPs_After_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array_After_Failure = [LP_ON_Up_Units_Array_After_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_up_unit_after_failure   = curr_LP_ON_up_unit_after_failure  + 1;
    end
    
    %% LP ON DOWN Units
    % Total Lever Presses of each type of duration
    Total_LPs_Success = ones(length(success_idx),1);
    Total_LPs_Failure = ones(length(failure_idx),1);
    Total_LPs_After_Success = ones(length(after_success_idx),1);
    Total_LPs_After_Failure = ones(length(failure_idx),1);
    for unit = LP_ON_Down_Sig_Units_Idx
        %% Success
        Pre_LP_Rate = nan(length(Total_LPs_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Success),1);
        for lever_press = 1:length(success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(success_idx,1);
        Mouse = Total_LPs_Success*curr_mouse;
        Session = Total_LPs_Success*session;
        Unit = Total_LPs_Success*curr_LP_ON_down_unit_success;
        True_Unit = Total_LPs_Success*unit;
        File = Total_LPs_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array_Success = [LP_ON_Down_Units_Array_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_down_unit_success   = curr_LP_ON_down_unit_success  + 1;
        %% Failure
        Pre_LP_Rate = nan(length(Total_LPs_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Failure),1);
        for lever_press = 1:length(failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(failure_idx,1);
        Mouse = Total_LPs_Failure*curr_mouse;
        Session = Total_LPs_Failure*session;
        Unit = Total_LPs_Failure*curr_LP_ON_down_unit_failure;
        True_Unit = Total_LPs_Failure*unit;
        File = Total_LPs_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array_Failure = [LP_ON_Down_Units_Array_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_down_unit_failure  = curr_LP_ON_down_unit_failure  + 1;
        %% After Success, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Success),1);
        for lever_press = 1:length(after_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_success_idx,1);
        Mouse = Total_LPs_After_Success*curr_mouse;
        Session = Total_LPs_After_Success*session;
        Unit = Total_LPs_After_Success*curr_LP_ON_down_unit_after_success;
        True_Unit = Total_LPs_After_Success*unit;
        File = Total_LPs_After_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array_After_Success = [LP_ON_Down_Units_Array_After_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_down_unit_after_success   = curr_LP_ON_down_unit_after_success  + 1;
        %% After Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        for lever_press = 1:length(after_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_failure_idx,1);
        Mouse = Total_LPs_After_Failure*curr_mouse;
        Session = Total_LPs_After_Failure*session;
        Unit = Total_LPs_After_Failure*curr_LP_ON_down_unit_after_failure;
        True_Unit = Total_LPs_After_Failure*unit;
        File = Total_LPs_After_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array_After_Failure = [LP_ON_Down_Units_Array_After_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_down_unit_after_failure   = curr_LP_ON_down_unit_after_failure  + 1;
    end
    
    %% LP OFF UP Units
    % Total Lever Presses of each type of duration
    Total_LPs_Success = ones(length(success_idx),1);
    Total_LPs_Failure = ones(length(failure_idx),1);
    Total_LPs_After_Success = ones(length(after_success_idx),1);
    Total_LPs_After_Failure = ones(length(failure_idx),1);
    for unit = LP_OFF_Up_Sig_Units_Idx
        %% Success
        Pre_LP_Rate = nan(length(Total_LPs_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Success),1);
        for lever_press = 1:length(success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(success_idx,1);
        Mouse = Total_LPs_Success*curr_mouse;
        Session = Total_LPs_Success*session;
        Unit = Total_LPs_Success*curr_LP_OFF_up_unit_success;
        True_Unit = Total_LPs_Success*unit;
        File = Total_LPs_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Up_Units_Array_Success = [LP_OFF_Up_Units_Array_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_up_unit_success   = curr_LP_OFF_up_unit_success  + 1;
        %% Failure
        Pre_LP_Rate = nan(length(Total_LPs_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Failure),1);
        for lever_press = 1:length(failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(failure_idx,1);
        Mouse = Total_LPs_Failure*curr_mouse;
        Session = Total_LPs_Failure*session;
        Unit = Total_LPs_Failure*curr_LP_OFF_up_unit_failure;
        True_Unit = Total_LPs_Failure*unit;
        File = Total_LPs_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Up_Units_Array_Failure = [LP_OFF_Up_Units_Array_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_up_unit_failure  = curr_LP_OFF_up_unit_failure  + 1;
        %% After Success, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Success),1);
        for lever_press = 1:length(after_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_success_idx,1);
        Mouse = Total_LPs_After_Success*curr_mouse;
        Session = Total_LPs_After_Success*session;
        Unit = Total_LPs_After_Success*curr_LP_OFF_up_unit_after_success;
        True_Unit = Total_LPs_After_Success*unit;
        File = Total_LPs_After_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Up_Units_Array_After_Success = [LP_OFF_Up_Units_Array_After_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_up_unit_after_success   = curr_LP_OFF_up_unit_after_success  + 1;
        %% After Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        for lever_press = 1:length(after_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_failure_idx,1);
        Mouse = Total_LPs_After_Failure*curr_mouse;
        Session = Total_LPs_After_Failure*session;
        Unit = Total_LPs_After_Failure*curr_LP_OFF_up_unit_after_failure;
        True_Unit = Total_LPs_After_Failure*unit;
        File = Total_LPs_After_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Up_Units_Array_After_Failure = [LP_OFF_Up_Units_Array_After_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_up_unit_after_failure   = curr_LP_OFF_up_unit_after_failure  + 1;
    end
    
    %% LP OFF DOWN Units
    % Total Lever Presses of each type of duration
    Total_LPs_Success = ones(length(success_idx),1);
    Total_LPs_Failure = ones(length(failure_idx),1);
    Total_LPs_After_Success = ones(length(after_success_idx),1);
    Total_LPs_After_Failure = ones(length(failure_idx),1);
    for unit = LP_ON_Down_Sig_Units_Idx
        %% Success
        Pre_LP_Rate = nan(length(Total_LPs_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_Success),1);
        for lever_press = 1:length(success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(success_idx,1);
        Mouse = Total_LPs_Success*curr_mouse;
        Session = Total_LPs_Success*session;
        Unit = Total_LPs_Success*curr_LP_OFF_down_unit_success;
        True_Unit = Total_LPs_Success*unit;
        File = Total_LPs_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Down_Units_Array_Success = [LP_OFF_Down_Units_Array_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_down_unit_success   = curr_LP_OFF_down_unit_success  + 1;
        %% Failure
        Pre_LP_Rate = nan(length(Total_LPs_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_Failure),1);
        for lever_press = 1:length(failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(failure_idx,1);
        Mouse = Total_LPs_Failure*curr_mouse;
        Session = Total_LPs_Failure*session;
        Unit = Total_LPs_Failure*curr_LP_OFF_down_unit_failure;
        True_Unit = Total_LPs_Failure*unit;
        File = Total_LPs_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Down_Units_Array_Failure = [LP_OFF_Down_Units_Array_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_down_unit_failure  = curr_LP_OFF_down_unit_failure  + 1;
        %% After Success, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Success),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Success),1);
        for lever_press = 1:length(after_success_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_success_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_success_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_success_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_success_idx,1);
        Mouse = Total_LPs_After_Success*curr_mouse;
        Session = Total_LPs_After_Success*session;
        Unit = Total_LPs_After_Success*curr_LP_OFF_down_unit_after_success;
        True_Unit = Total_LPs_After_Success*unit;
        File = Total_LPs_After_Success*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Down_Units_Array_After_Success = [LP_OFF_Down_Units_Array_After_Success; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_down_unit_after_success   = curr_LP_OFF_down_unit_after_success  + 1;
        %% After Failure, All
        Pre_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        Post_LP_Rate = nan(length(Total_LPs_After_Failure),1);
        for lever_press = 1:length(after_failure_idx)
            spike_times_ON = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            spike_times_OFF = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial(after_failure_idx(lever_press)).spikes;
            Pre_LP_Rate(lever_press) = sum((spike_times_ON >= time_LPON_1) & (spike_times_ON <= time_LPON_2));
            Post_LP_Rate(lever_press) = sum((spike_times_OFF >= time_LPOFF_1) & (spike_times_OFF <= time_LPOFF_2));

        end
        Duration = Day.Mouse(mouse).Session.LP_Length(after_failure_idx);
        HoldCount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_bincount(after_failure_idx,1);
        HoldRate = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_interp_rate(after_failure_idx,1);
        Mouse = Total_LPs_After_Failure*curr_mouse;
        Session = Total_LPs_After_Failure*session;
        Unit = Total_LPs_After_Failure*curr_LP_OFF_down_unit_after_failure;
        True_Unit = Total_LPs_After_Failure*unit;
        File = Total_LPs_After_Failure*mouse;
        
        % Concatenate Information into Arracy
        LP_OFF_Down_Units_Array_After_Failure = [LP_OFF_Down_Units_Array_After_Failure; Duration HoldCount HoldRate Pre_LP_Rate Post_LP_Rate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_OFF_down_unit_after_failure   = curr_LP_OFF_down_unit_after_failure  + 1;
    end
end

%% All LPs
% All Units
Regression.All_LPs.All_Units_All_Trials = array2table(All_Units_Array,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP On Up Units
Regression.All_LPs.LPON_Up_Units_All_Trials = array2table(LP_ON_Up_Units_Array,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP On Down Units
Regression.All_LPs.LPON_Down_Units_All_Trials = array2table(LP_ON_Down_Units_Array,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP Off Up Units
Regression.All_LPs.LPOFF_Up_Units_All_Trials = array2table(LP_OFF_Up_Units_Array,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP Off Down Units
Regression.All_LPs.LPOFF_Down_Units_All_Trials = array2table(LP_OFF_Down_Units_Array,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% %% Minimum 1 Spike during LPs
% array2table(Regression.All_Count,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPCount', 'PreLPRate',...
%     'PostLPCount', 'PostLPRate', 'Unit','Mouse','Session'});
% %% Minimum 500 Second LPs
% array2table(Regression.All_Count,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPCount', 'PreLPRate',...
%     'PostLPCount', 'PostLPRate', 'Unit','Mouse','Session'});

%% Type of Trials
%% Minimum of .5 seconds (LP)
% All Units
All_Units_Array_Min = All_Units_Array(All_Units_Array(:,1)>=0.5,:);
Regression.Min_LPs.All_Units_All_Trials = array2table(All_Units_Array_Min,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP On Up Units
All_Units_Array_Min = LP_ON_Up_Units_Array(LP_ON_Up_Units_Array(:,1)>=0.5,:);
Regression.Min_LPs.LPON_Up_Units_All_Trials = array2table(All_Units_Array_Min,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP On Down Units
LP_ON_Down_Units_Array_Min = LP_ON_Down_Units_Array(LP_ON_Down_Units_Array(:,1)>=0.5,:);
Regression.Min_LPs.LPON_Down_Units_All_Trials = array2table(LP_ON_Down_Units_Array_Min,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP Off Up Units
LP_OFF_Up_Units_Array_Min = LP_OFF_Up_Units_Array(LP_OFF_Up_Units_Array(:,1)>=0.5,:);
Regression.Min_LPs.LPOFF_Up_Units_All_Trials = array2table(LP_OFF_Up_Units_Array_Min,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});
% LP Off Down Units
LP_OFF_Down_Units_Array_Min = LP_OFF_Down_Units_Array(LP_OFF_Down_Units_Array(:,1)>=0.5,:);
Regression.Min_LPs.LPOFF_Down_Units_All_Trials = array2table(LP_OFF_Down_Units_Array_Min,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File', 'Hold_1_Count', 'Hold_2_Count', 'Hold_3_Count', 'Hold_4_Count', 'Hold_1_Z_Mean', 'Hold_2_Z_Mean', 'Hold_3_Z_Mean', 'Hold_4_Z_Mean'});

%% All units
%% At Success
Regression.Perform_LPs.All_Units_Array_Success = array2table(All_Units_Array_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% At Failure
Regression.Perform_LPs.All_Units_Array_Failure = array2table(All_Units_Array_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, All
Regression.Perform_LPs.All_Units_Array_After_Success = array2table(All_Units_Array_After_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, All
Regression.Perform_LPs.All_Units_Array_After_Failure = array2table(All_Units_Array_After_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Success
All_Units_Array_After_Success_Success = All_Units_Array_After_Success(All_Units_Array_After_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_After_Success_Success = array2table(All_Units_Array_After_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Failure
All_Units_Array_After_Success_Failure = All_Units_Array_After_Success(All_Units_Array_After_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_After_Success_Failure = array2table(All_Units_Array_After_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Success
All_Units_Array_After_Failure_Success = All_Units_Array_After_Failure(All_Units_Array_After_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_After_Failure_Success = array2table(All_Units_Array_After_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Failure
All_Units_Array_After_Failure_Failure = All_Units_Array_After_Failure(All_Units_Array_After_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_After_Failure_Failure = array2table(All_Units_Array_After_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Success, All
Regression.Perform_LPs.All_Units_Array_Before_Success = array2table(All_Units_Array_Before_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Failure, All
Regression.Perform_LPs.All_Units_Array_Before_Failure = array2table(All_Units_Array_Before_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Success, Success
All_Units_Array_Before_Success_Success = All_Units_Array_Before_Success(All_Units_Array_Before_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_Before_Success_Success = array2table(All_Units_Array_Before_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Success, Failure
All_Units_Array_Before_Success_Failure = All_Units_Array_Before_Success(All_Units_Array_Before_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_Before_Success_Failure = array2table(All_Units_Array_Before_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Failure, Success
All_Units_Array_Before_Failure_Success = All_Units_Array_Before_Failure(All_Units_Array_Before_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_Before_Failure_Success = array2table(All_Units_Array_Before_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% Before Failure, Failure
All_Units_Array_Before_Failure_Failure = All_Units_Array_Before_Failure(All_Units_Array_Before_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.All_Units_Array_Before_Failure_Failure = array2table(All_Units_Array_Before_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

%% LP ON UP Units
%% At Success
Regression.Perform_LPs.LP_ON_Up_Units_Array_Success = array2table(LP_ON_Up_Units_Array_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% At Failure
Regression.Perform_LPs.LP_ON_Up_Units_Array_Failure= array2table(LP_ON_Up_Units_Array_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, All
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Success = array2table(LP_ON_Up_Units_Array_After_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, All
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Failure = array2table(LP_ON_Up_Units_Array_After_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Success
LP_ON_Up_Units_Array_After_Success_Success = LP_ON_Up_Units_Array_After_Success(LP_ON_Up_Units_Array_After_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Success_Success = array2table(LP_ON_Up_Units_Array_After_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Failure
LP_ON_Up_Units_Array_After_Success_Failure = LP_ON_Up_Units_Array_After_Success(LP_ON_Up_Units_Array_After_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Success_Failure = array2table(LP_ON_Up_Units_Array_After_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Success
LP_ON_Up_Units_Array_After_Failure_Success = LP_ON_Up_Units_Array_After_Failure(LP_ON_Up_Units_Array_After_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Failure_Success = array2table(LP_ON_Up_Units_Array_After_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Failure
LP_ON_Up_Units_Array_After_Failure_Failure = LP_ON_Up_Units_Array_After_Failure(LP_ON_Up_Units_Array_After_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Up_Units_Array_After_Failure_Failure = array2table(LP_ON_Up_Units_Array_After_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

%% LP ON DOWN Units
%% At Success
Regression.Perform_LPs.LP_ON_Down_Units_Array_Success = array2table(LP_ON_Down_Units_Array_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% At Failure
Regression.Perform_LPs.LP_ON_Down_Units_Array_Failure= array2table(LP_ON_Down_Units_Array_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, All
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Success = array2table(LP_ON_Down_Units_Array_After_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, All
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Failure = array2table(LP_ON_Down_Units_Array_After_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Success
LP_ON_Down_Units_Array_After_Success_Success = LP_ON_Down_Units_Array_After_Success(LP_ON_Down_Units_Array_After_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Success_Success = array2table(LP_ON_Down_Units_Array_After_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Failure
LP_ON_Down_Units_Array_After_Success_Failure = LP_ON_Down_Units_Array_After_Success(LP_ON_Down_Units_Array_After_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Success_Failure = array2table(LP_ON_Down_Units_Array_After_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Success
LP_ON_Down_Units_Array_After_Failure_Success = LP_ON_Down_Units_Array_After_Failure(LP_ON_Down_Units_Array_After_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Failure_Success = array2table(LP_ON_Down_Units_Array_After_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Failure
LP_ON_Down_Units_Array_After_Failure_Failure = LP_ON_Down_Units_Array_After_Failure(LP_ON_Down_Units_Array_After_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_ON_Down_Units_Array_After_Failure_Failure = array2table(LP_ON_Down_Units_Array_After_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

%% LP OFF UP Units
%% At Success
Regression.Perform_LPs.LP_OFF_Up_Units_Array_Success = array2table(LP_OFF_Up_Units_Array_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% At Failure
Regression.Perform_LPs.LP_OFF_Up_Units_Array_Failure= array2table(LP_OFF_Up_Units_Array_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, All
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Success = array2table(LP_OFF_Up_Units_Array_After_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, All
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Failure = array2table(LP_OFF_Up_Units_Array_After_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Success
LP_OFF_Up_Units_Array_After_Success_Success = LP_OFF_Up_Units_Array_After_Success(LP_OFF_Up_Units_Array_After_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Success_Success = array2table(LP_OFF_Up_Units_Array_After_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Failure
LP_OFF_Up_Units_Array_After_Success_Failure = LP_OFF_Up_Units_Array_After_Success(LP_OFF_Up_Units_Array_After_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Success_Failure = array2table(LP_OFF_Up_Units_Array_After_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Success
LP_OFF_Up_Units_Array_After_Failure_Success = LP_OFF_Up_Units_Array_After_Failure(LP_OFF_Up_Units_Array_After_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Failure_Success = array2table(LP_OFF_Up_Units_Array_After_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Failure
LP_OFF_Up_Units_Array_After_Failure_Failure = LP_OFF_Up_Units_Array_After_Failure(LP_OFF_Up_Units_Array_After_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Up_Units_Array_After_Failure_Failure = array2table(LP_OFF_Up_Units_Array_After_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

%% LP OFF DOWN Units
%% At Success
Regression.Perform_LPs.LP_OFF_Down_Units_Array_Success = array2table(LP_OFF_Down_Units_Array_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% At Failure
Regression.Perform_LPs.LP_OFF_Down_Units_Array_Failure= array2table(LP_OFF_Down_Units_Array_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, All
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Success = array2table(LP_OFF_Down_Units_Array_After_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, All
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Failure = array2table(LP_OFF_Down_Units_Array_After_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Success
LP_OFF_Down_Units_Array_After_Success_Success = LP_OFF_Down_Units_Array_After_Success(LP_OFF_Down_Units_Array_After_Success(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Success_Success = array2table(LP_OFF_Down_Units_Array_After_Success_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Success, Failure
LP_OFF_Down_Units_Array_After_Success_Failure = LP_OFF_Down_Units_Array_After_Success(LP_OFF_Down_Units_Array_After_Success(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Success_Failure = array2table(LP_OFF_Down_Units_Array_After_Success_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Success
LP_OFF_Down_Units_Array_After_Failure_Success = LP_OFF_Down_Units_Array_After_Failure(LP_OFF_Down_Units_Array_After_Failure(:,1) >= Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Failure_Success = array2table(LP_OFF_Down_Units_Array_After_Failure_Success,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
%% After Failure, Failure
LP_OFF_Down_Units_Array_After_Failure_Failure = LP_OFF_Down_Units_Array_After_Failure(LP_OFF_Down_Units_Array_After_Failure(:,1) < Day.Mouse(mouse).Session.Criteria,:);
Regression.Perform_LPs.LP_OFF_Down_Units_Array_After_Failure_Failure = array2table(LP_OFF_Down_Units_Array_After_Failure_Failure,'VariableNames',{'Duration','HoldCount','HoldRate', 'PreLPRate',...
    'PostLPRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});
end

