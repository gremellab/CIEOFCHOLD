function [Baselines] = baseline_FR(Day)

Up_Baselines = [];
Up_Mean_Baselines = [];
Down_Baselines = [];
Down_Mean_Baselines = [];
All_Baselines = [];
All_Mean_Baselines = [];
for mouse = 1:size(Day.Mouse ,2)
    LP_ON_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}))]);
    LP_ON_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}))]);
    for unit = LP_ON_Up_Sig_Units_Idx
        Up_Baseline = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).Baseline;
        Up_Baselines = [Up_Baselines; Up_Baseline]; % use unsmoothed mean PETH
        mu = mean(Up_Baseline);
        Up_Mean_Baselines = [Up_Mean_Baselines ; mu];
    end
    for unit = LP_ON_Down_Sig_Units_Idx
        Down_Baseline = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).Baseline;
        Down_Baselines = [Down_Baselines; Down_Baseline]; % use unsmoothed mean PETH
        mu = mean(Down_Baseline);
        Down_Mean_Baselines = [Down_Mean_Baselines ; mu];
    end
    
    for unit = 1:length(Day.Mouse(mouse).Session.ValidUnitsIdx)
        All_Baseline = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).Baseline;
        All_Baselines = [All_Baselines; All_Baseline]; % use unsmoothed mean PETH
        mu = mean(All_Baseline);
        All_Mean_Baselines = [All_Mean_Baselines ; mu];
    end
end

Baselines.All_Mean_Baselines = All_Mean_Baselines;
Baselines.Up_Mean_Baselines = Up_Mean_Baselines;
Baselines.Down_Mean_Baselines = Down_Mean_Baselines;

end

