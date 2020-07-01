function [Mod_Values] = modulation_values(Day)
time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
pre_event_time_idx = find(time == -1000);
event_time_idx = find(time == 0);
post_event_time_idx = find(time == 1000);
time_LPON_1 = find(time == -750);
time_LPON_2 = find(time == -500);
time_LPON_3 = find(time == -250);
time_LPOFF_1 = find(time == 250);
time_LPOFF_2 = find(time == 500);
time_LPOFF_3 = find(time == 750);
time_Rein_1 = find(time == 250);
time_Rein_2 = find(time == 500);
time_Rein_3 = find(time == 750);
%% LPON Quantile Up modulated
Quant_Mean = nan(size(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPON_PETH_20_Quant_2_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPON_PETH_20_Quant_3_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPON_PETH_20_Quant_4_Up_Mod_All_LPs(unit, event_time_idx));
end
Mod_Values.LPON_Quant_Up = Quant_Mean;
%% LPON Quantile Down modulated
Quant_Mean = nan(size(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPON_PETH_20_Quant_2_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPON_PETH_20_Quant_3_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPON_PETH_20_Quant_4_Down_Mod_All_LPs(unit, event_time_idx));
end
Mod_Values.LPON_Quant_Down = Quant_Mean;
%% LPOFF Quantile Up modulated
Quant_Mean = nan(size(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs(unit, event_time_idx));
end
Mod_Values.LPOFF_Quant_Up = Quant_Mean;
%% LPOFF Quantile Down modulated
Quant_Mean = nan(size(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs(unit, event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs(unit, event_time_idx));
end
Mod_Values.LPOFF_Quant_Down = Quant_Mean;










%% LPON Quantile Up modulated Pre
Quant_Mean = nan(size(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPON_PETH_20_Quant_2_Up_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPON_PETH_20_Quant_3_Up_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPON_PETH_20_Quant_4_Up_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
end
Mod_Values.LPON_Quant_Up_Pre = Quant_Mean;

%% LPON Quantile Down modulated Pre
Quant_Mean = nan(size(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPON_PETH_20_Quant_2_Down_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPON_PETH_20_Quant_3_Down_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPON_PETH_20_Quant_4_Down_Mod_All_LPs(unit, pre_event_time_idx:event_time_idx));
end
Mod_Values.LPON_Quant_Down_Pre = Quant_Mean;


%% LPOFF Quantile Up modulated Post
Quant_Mean = nan(size(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
end
Mod_Values.LPOFF_Quant_Up_Post = Quant_Mean;

%% LPOFF Quantile Down modulated Post
Quant_Mean = nan(size(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1)
    Quant_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
    Quant_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs(unit, event_time_idx:post_event_time_idx));
end
Mod_Values.LPOFF_Quant_Down_Post = Quant_Mean;









%% All lever Presses
%% LPON Up modulated 
% Mod_Mean = nan(size(Day.LPON_PETH_20_Up_Mod_All_LPs,1),1);
% for unit = 1:size(Day.LPON_PETH_20_Up_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Up_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.LPON_Up = Mod_Mean;
% %% LPON Down modulated 
% Mod_Mean = nan(size(Day.LPON_PETH_20_Down_Mod_All_LPs,1),1);
% for unit = 1:size(Day.LPON_PETH_20_Down_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Down_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.LPON_Down = Mod_Mean;
%% LPON Up modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Up_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Up_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Up_Mod_All_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Up_Mod_All_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Up_Mod_All_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Up_Mod_All_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Up_Pre = Mod_Summary;
%% LPON Down modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Down_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Down_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Down_Mod_All_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Down_Mod_All_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Down_Mod_All_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Down_Mod_All_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Down_Pre = Mod_Summary;
% %% LPOFF Up modulated 
% Mod_Mean = nan(size(Day.LPOFF_PETH_20_Up_Mod_All_LPs,1),1);
% for unit = 1:size(Day.LPOFF_PETH_20_Up_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Up_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.LPOFF_Up = Mod_Mean;
% %% LPOFF Down modulated 
% Mod_Mean = nan(size(Day.LPOFF_PETH_20_Down_Mod_All_LPs,1),1);
% for unit = 1:size(Day.LPOFF_PETH_20_Down_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Down_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.LPOFF_Down = Mod_Mean;
%% LPOFF Up modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Up_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Up_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Up_Mod_All_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Up_Mod_All_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Up_Mod_All_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Up_Mod_All_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Up_Post = Mod_Summary;
%% LPOFF Down modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Down_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Down_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Down_Mod_All_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Down_Mod_All_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Down_Mod_All_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Down_Mod_All_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Down_Post = Mod_Summary;
% %% ReinON Up modulated 
% Mod_Mean = nan(size(Day.Rein_ON_PETH_20_Up_Mod_All_LPs,1),1);
% for unit = 1:size(Day.Rein_ON_PETH_20_Up_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.Rein_ON_PETH_20_Up_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.ReinON_Up = Mod_Mean;
% %% ReinON Down modulated 
% Mod_Mean = nan(size(Day.Rein_ON_PETH_20_Down_Mod_All_LPs,1),1);
% for unit = 1:size(Day.Rein_ON_PETH_20_Down_Mod_All_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.Rein_ON_PETH_20_Down_Mod_All_LPs(unit, event_time_idx));
% end
% Mod_Values.ReinON_Down = Mod_Mean;
%% ReinON Up modulated Post
Mod_Mean = nan(size(Day.Rein_ON_PETH_20_Up_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.Rein_ON_PETH_20_Up_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.Rein_ON_PETH_20_Up_Mod_All_LPs(unit, event_time_idx:time_Rein_1));
    Mod_Mean(unit,2) = mean(Day.Rein_ON_PETH_20_Up_Mod_All_LPs(unit, time_Rein_1:time_Rein_2));
    Mod_Mean(unit,3) = mean(Day.Rein_ON_PETH_20_Up_Mod_All_LPs(unit, time_Rein_2:time_Rein_3));
    Mod_Mean(unit,4) = mean(Day.Rein_ON_PETH_20_Up_Mod_All_LPs(unit, time_Rein_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.ReinON_Up_Post = Mod_Summary;
%% ReinON Down modulated Post
Mod_Mean = nan(size(Day.Rein_ON_PETH_20_Down_Mod_All_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.Rein_ON_PETH_20_Down_Mod_All_LPs,1)
    Mod_Mean(unit,1) = mean(Day.Rein_ON_PETH_20_Down_Mod_All_LPs(unit, event_time_idx:time_Rein_1));
    Mod_Mean(unit,2) = mean(Day.Rein_ON_PETH_20_Down_Mod_All_LPs(unit, time_Rein_1:time_Rein_2));
    Mod_Mean(unit,3) = mean(Day.Rein_ON_PETH_20_Down_Mod_All_LPs(unit, time_Rein_2:time_Rein_3));
    Mod_Mean(unit,4) = mean(Day.Rein_ON_PETH_20_Down_Mod_All_LPs(unit, time_Rein_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.ReinON_Down_Post = Mod_Summary;









%% Met vs Fail lever Presses
%% LPON Up modulated 
% Mod_Mean = nan(size(Day.LPON_PETH_20_Up_Mod_Met_LPs,1),2);
% for unit = 1:size(Day.LPON_PETH_20_Up_Mod_Met_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Up_Mod_Met_LPs(unit, event_time_idx));
%     Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Up_Mod_Fail_LPs(unit, event_time_idx));
% end
% Mod_Values.LPON_Up_Met_Fail = Mod_Mean;
% %% LPON Down modulated 
% Mod_Mean = nan(size(Day.LPON_PETH_20_Down_Mod_Met_LPs,1),2);
% for unit = 1:size(Day.LPON_PETH_20_Down_Mod_Met_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Down_Mod_Met_LPs(unit, event_time_idx));
%     Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Down_Mod_Fail_LPs(unit, event_time_idx));
% end
% Mod_Values.LPON_Down_Met_Fail = Mod_Mean;
% %% LPOFF Up modulated 
% Mod_Mean = nan(size(Day.LPOFF_PETH_20_Up_Mod_Met_LPs,1),2);
% for unit = 1:size(Day.LPOFF_PETH_20_Up_Mod_Met_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Up_Mod_Met_LPs(unit, event_time_idx));
%     Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs(unit, event_time_idx));
% end
% Mod_Values.LPOFF_Up_Met_Fail = Mod_Mean;
% %% LPOFF Down modulated 
% Mod_Mean = nan(size(Day.LPOFF_PETH_20_Down_Mod_Met_LPs,1),2);
% for unit = 1:size(Day.LPOFF_PETH_20_Down_Mod_Met_LPs,1)
%     Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Down_Mod_Met_LPs(unit, event_time_idx));
%     Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs(unit, event_time_idx));
% end
% Mod_Values.LPOFF_Down_Met_Fail = Mod_Mean;



%% Met
%% LPON Up modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Up_Mod_Met_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Up_Mod_Met_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Up_Mod_Met_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Up_Mod_Met_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Up_Mod_Met_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Up_Mod_Met_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Up_Met_Pre = Mod_Summary;
%% LPON Down modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Down_Mod_Met_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Down_Mod_Met_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Down_Mod_Met_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Down_Mod_Met_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Down_Mod_Met_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Down_Mod_Met_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Down_Met_Pre = Mod_Summary;
%% LPOFF Up modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Up_Mod_Met_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Up_Mod_Met_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Up_Mod_Met_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Up_Mod_Met_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Up_Mod_Met_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Up_Mod_Met_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Up_Met_Post = Mod_Summary;
%% LPOFF Down modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Down_Mod_Met_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Down_Mod_Met_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Down_Mod_Met_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Down_Mod_Met_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Down_Mod_Met_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Down_Mod_Met_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Down_Met_Post = Mod_Summary;




%% Fail
%% LPON Up modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Up_Mod_Fail_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Up_Mod_Fail_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Up_Mod_Fail_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Up_Mod_Fail_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Up_Mod_Fail_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Up_Mod_Fail_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Up_Fail_Pre = Mod_Summary;
%% LPON Down modulated Pre
Mod_Mean = nan(size(Day.LPON_PETH_20_Down_Mod_Fail_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPON_PETH_20_Down_Mod_Fail_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPON_PETH_20_Down_Mod_Fail_LPs(unit, pre_event_time_idx:time_LPON_1));
    Mod_Mean(unit,2) = mean(Day.LPON_PETH_20_Down_Mod_Fail_LPs(unit, time_LPON_1:time_LPON_2));
    Mod_Mean(unit,3) = mean(Day.LPON_PETH_20_Down_Mod_Fail_LPs(unit, time_LPON_2:time_LPON_3));
    Mod_Mean(unit,4) = mean(Day.LPON_PETH_20_Down_Mod_Fail_LPs(unit, time_LPON_3:event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPON_Down_Fail_Pre = Mod_Summary;
%% LPOFF Up modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Up_Mod_Fail_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Up_Fail_Post = Mod_Summary;
%% LPOFF Down modulated Post
Mod_Mean = nan(size(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs,1),4);
Mod_Summary = nan(4,3);
for unit = 1:size(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs,1)
    Mod_Mean(unit,1) = mean(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs(unit, event_time_idx:time_LPOFF_1));
    Mod_Mean(unit,2) = mean(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs(unit, time_LPOFF_1:time_LPOFF_2));
    Mod_Mean(unit,3) = mean(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs(unit, time_LPOFF_2:time_LPOFF_3));
    Mod_Mean(unit,4) = mean(Day.LPOFF_PETH_20_Down_Mod_Fail_LPs(unit, time_LPOFF_3:post_event_time_idx));
end
Mod_Summary(:,1) = mean(Mod_Mean);
Mod_Summary(:,2) = std(Mod_Mean);
Mod_Summary(:,3) = size(Mod_Mean,1);
Mod_Values.LPOFF_Down_Fail_Post = Mod_Summary;







%% Interpolation (Area under curve from 0)
norm_plot_time = linspace(0,100,length(Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_interp_all));
%% LPON Up modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,2) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,3) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,4) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Up_Interp_Quant_Area = Interp_Area;
%% LPON Down modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1),4);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,2) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,3) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,4) = trapz(norm_plot_time, Day.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Down_Interp_Quant_Area = Interp_Area;

%% Met vs Fail
%% LPON Up modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1),2);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.PETH_Interp_Up_Mod_Met_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,2) = trapz(norm_plot_time, Day.PETH_Interp_Up_Mod_Fail_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Up_Interp_Met_Fail = Interp_Area;
%% LPON Down modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1),2);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.PETH_Interp_Down_Mod_Met_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
    Interp_Area(unit,2) = trapz(norm_plot_time, Day.PETH_Interp_Down_Mod_Fail_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Down_Interp_Met_Fail = Interp_Area;
%% All
%% LPON Up modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1),1);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.PETH_Interp_Up_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Up_Interp_All = Interp_Area;
%% LPON Down modulated 
Interp_Area = nan(size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1),1);
for unit = 1:size(Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1)
    Interp_Area(unit,1) = trapz(norm_plot_time, Day.PETH_Interp_Down_Mod_All_LPs(unit, :)) - trapz(norm_plot_time, zeros(1, length(norm_plot_time)));
end
Mod_Values.LPON_Down_Interp_All = Interp_Area;
end




