function [Air, Eth, Air_Grouped, Eth_Grouped] = Separate_Behavior_Data(Data)
%% Separate Data Structure by Group Identifiers
% Air_mice = {'1919', '2043', '2214', '2215', '2365', '2528', '2525', '2677', '2676'};
% Eth_mice = {'1991', '2044', '2045', '2210', '2364', '2366', '2527', '2526', '2623', '2624'};

% OFC Lesion (Angela Cohort)
% Air_mice = {'2610', '2611', '2612', '2671', '2672', '2673'}; % OFC Lesion
% Eth_mice = {'2613', '2618', '2619', '2620', '2621', '2670'};

% Recordings Cohort
Air_mice = {'2043', '2214', '2215', '2365', '2528', '2525', '2677', '2676', '2753'};
Eth_mice = {'2044', '2045', '2210', '2364', '2527', '2526', '2754', '2755', '2708'};

% DREADD Cohort
% Air_mice = {'2970', '2972', '3068', '2960', '2962', '2963'};
% Eth_mice = {'2969', '2971', '2973', '3066', '3067', '2961'};

% Pure Behavior Cohort
% Air_mice = {'3176', '3177', '3211', '3212','3225', '3226', '3227', '3228'};
% Eth_mice = {'3213', '3214', '3215', '3216', '3221', '3222', '3223'};

for day = 1:length(Data.Day)
    Mouse_Names = {Data.Day(day).Mouse(:).Name};
    air_mouse_count = 1;
    eth_mouse_count = 1;
    for mouse = 1:length(Mouse_Names)
        Current_Mouse = Data.Day(day).Mouse(mouse).Name;
        Index = find(contains(Mouse_Names,Current_Mouse));
        if ~isempty(find(contains(Current_Mouse, Air_mice)))
            %% Raw Values
            Air.Day(day).Mouse(air_mouse_count) = Data.Day(day).Mouse(Index);
            %% Grouped Values
            Air_Grouped.Day(day).Name(air_mouse_count) = {Data.Day(day).Mouse(Index).Name(1:end)};
            Air_Grouped.Day(day).Total_Lever_Presses(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Total_Lever_Presses;
            Air_Grouped.Day(day).Lever_Press_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_IPI_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_IPI_Mean;
            Air_Grouped.Day(day).Total_Reinforcers_Earned(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Total_Reinforcers_Earned; % get Reinforcers earned
            Air_Grouped.Day(day).Criteria_Met_Percent(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Criteria_Met_Percent;
            Air_Grouped.Day(day).Lever_Press_rate(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_rate;
            
            Air_Grouped.Day(day).Lever_Press_Rewarded_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Rewarded_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_Not_Rewarded_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Not_Rewarded_Lengths_Mean;
            
            Air_Grouped.Day(day).Lever_Press_Length_After_Success_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Success_Mean;
            Air_Grouped.Day(day).Lever_Press_Length_After_Failure_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Failure_Mean;
            Air_Grouped.Day(day).Lever_Press_Length_After_Success_Change_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Success_Change_Mean;
            Air_Grouped.Day(day).Lever_Press_Length_After_Failure_Change_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Failure_Change_Mean;
            
            Air_Grouped.Day(day).Up_State_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Lengths_Mean;
            Air_Grouped.Day(day).Up_State_Reward_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Reward_Lengths_Mean;
            Air_Grouped.Day(day).Up_State_Fail_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Fail_Lengths_Mean;
            Air_Grouped.Day(day).Consecutive_Up_State_LPs_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Consecutive_Up_State_LPs_Mean;
            
            Air_Grouped.Day(day).Down_State_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Lengths_Mean;
            Air_Grouped.Day(day).Down_State_Reward_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Reward_Lengths_Mean;
            Air_Grouped.Day(day).Down_State_Fail_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Fail_Lengths_Mean;
            Air_Grouped.Day(day).Consecutive_Down_State_LPs(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Consecutive_Down_State_LPs_Mean;
       
            Air_Grouped.Day(day).Lever_Press_n_1_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_1_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_2_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_2_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_3_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_3_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_4_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_4_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_5_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_5_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_10_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_10_Lengths_Mean;
            Air_Grouped.Day(day).Lever_Press_n_20_Lengths_Mean(air_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_20_Lengths_Mean;
            
            Air_Grouped.Day(day).Ratio_Success(air_mouse_count) = {Data.Day(day).Mouse(Index).Ratio_Success};
            
            Air_Grouped.Day(day).Duration_Distribution(air_mouse_count) = {Data.Day(day).Mouse(Index).Duration_Distribution};
            Air_Grouped.Day(day).Median_Duration(air_mouse_count) = {Data.Day(day).Mouse(Index).Median_Duration};
            
            air_mouse_count = air_mouse_count + 1;
        end
        if ~isempty(find(contains(Current_Mouse, Eth_mice)))
            %% Raw Values
            Eth.Day(day).Mouse(eth_mouse_count) = Data.Day(day).Mouse(Index);
            %% Grouped Valies
             %% Grouped Values
            Eth_Grouped.Day(day).Name(eth_mouse_count) = {Data.Day(day).Mouse(Index).Name(1:end)};
            Eth_Grouped.Day(day).Total_Lever_Presses(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Total_Lever_Presses;
            Eth_Grouped.Day(day).Lever_Press_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_IPI_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_IPI_Mean;
            Eth_Grouped.Day(day).Total_Reinforcers_Earned(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Total_Reinforcers_Earned; % get Reinforcers earned
            Eth_Grouped.Day(day).Criteria_Met_Percent(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Criteria_Met_Percent;
            Eth_Grouped.Day(day).Lever_Press_rate(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_rate;
            
            Eth_Grouped.Day(day).Lever_Press_Rewarded_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Rewarded_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_Not_Rewarded_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Not_Rewarded_Lengths_Mean;
            
            Eth_Grouped.Day(day).Lever_Press_Length_After_Success_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Success_Mean;
            Eth_Grouped.Day(day).Lever_Press_Length_After_Failure_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Failure_Mean;
            Eth_Grouped.Day(day).Lever_Press_Length_After_Success_Change_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Success_Change_Mean;
            Eth_Grouped.Day(day).Lever_Press_Length_After_Failure_Change_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_Length_After_Failure_Change_Mean;
            
            Eth_Grouped.Day(day).Up_State_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Lengths_Mean;
            Eth_Grouped.Day(day).Up_State_Reward_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Reward_Lengths_Mean;
            Eth_Grouped.Day(day).Up_State_Fail_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Up_State_Fail_Lengths_Mean;
            Eth_Grouped.Day(day).Consecutive_Up_State_LPs_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Consecutive_Up_State_LPs_Mean;
            
            Eth_Grouped.Day(day).Down_State_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Lengths_Mean;
            Eth_Grouped.Day(day).Down_State_Reward_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Reward_Lengths_Mean;
            Eth_Grouped.Day(day).Down_State_Fail_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Down_State_Fail_Lengths_Mean;
            Eth_Grouped.Day(day).Consecutive_Down_State_LPs(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Consecutive_Down_State_LPs_Mean;
       
            Eth_Grouped.Day(day).Lever_Press_n_1_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_1_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_2_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_2_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_3_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_3_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_4_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_4_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_5_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_5_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_10_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_10_Lengths_Mean;
            Eth_Grouped.Day(day).Lever_Press_n_20_Lengths_Mean(eth_mouse_count) = Data.Day(day).Mouse(Index).Means.Lever_Press_n_20_Lengths_Mean;

            Eth_Grouped.Day(day).Ratio_Success(eth_mouse_count) = {Data.Day(day).Mouse(Index).Ratio_Success};
            
            Eth_Grouped.Day(day).Duration_Distribution(eth_mouse_count) = {Data.Day(day).Mouse(Index).Duration_Distribution};
            Eth_Grouped.Day(day).Median_Duration(eth_mouse_count) = {Data.Day(day).Mouse(Index).Median_Duration};
            
            eth_mouse_count = eth_mouse_count + 1;
        end
    end
end
end
