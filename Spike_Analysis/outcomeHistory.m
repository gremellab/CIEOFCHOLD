function [OutcomeHistory] = outcomeHistory(Day)

Table = Day.Regression.All_LPs.All_Units_All_Trials;
Criteria = Day.Mouse(1).Session.Criteria;

%% Figure properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 10;
LineWidth = 2;
LineWidth_Legend = 3;
size_w = 500;
size_h = 250;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
smooth_win = 600;
time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
time_LPON_1 = find(time == -1000);
time_LPON_2 = find(time == 100);
time_LPOFF_1 = find(time == -100);
time_LPOFF_2 = find(time == 1000);
bin_w = 10;
smooth_type = 'sgolay';
plot_time_offset = time(time_LPOFF_1:time_LPOFF_2);
plot_time_onset = time(time_LPON_1:time_LPON_2);
%%%%%%%%%%%%%
% n vs n-1
%%%%%%%%%%%%%
%% n = succes n-1 = Success or Failure
sigs_PreLP_S_S = [];
sigs_PreLP_F_S = [];

sigs_PreLP_S_F = [];
sigs_PreLP_F_F = [];

sigs_PostLP_S_S = [];
sigs_PostLP_F_S = [];

sigs_PostLP_S_F = [];
sigs_PostLP_F_F = [];


outcome_PreLP_S = [];
outcome_PreLP_F = [];

outcome_PostLP_S = [];
outcome_PostLP_F = [];

for unit = 1:max(Table.Unit)
    n_idx = find(Table.Unit == unit);
    n_durations = Table.Duration(n_idx);
    n_success_idx = n_idx(find(n_durations >= Criteria));
    n_failure_idx = n_idx(find(n_durations < Criteria));
    n_1_success_idx = n_success_idx - 1;
    n_1_failure_idx = n_failure_idx - 1;
    n_1_success_idx(find(n_1_success_idx < min(n_idx))) = []; % remove outside index
    n_1_failure_idx(find(n_1_failure_idx < min(n_idx))) = []; % remove outside index
    
    n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
    n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
    
    n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
    n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));

    True_Unit = unique(Table.True_Unit(n_idx));
    Mouse = unique(Table.Mouse(n_idx));
    Session = unique(Table.Session(n_idx));
    File = unique(Table.File(n_idx));
    
    %%%%%%%%%%%%%%%%%%%%
    % Pre LP Onset Tests
    %%%%%%%%%%%%%%%%%%%%
    
    % Compare Successes before Succeses to the Success after it
    n_FRs_S_S = Table.PreLPRate([n_1_success_success + 1]);
    n_1_FRs_S_S = Table.PreLPRate([n_1_success_success]);
    try
        [p,h] = signrank(n_FRs_S_S,n_1_FRs_S_S);
        if h == 1
            sigs_PreLP_S_S = [sigs_PreLP_S_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PreLP_S_S = [sigs_PreLP_S_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures before Succeses to the Success after it
    n_FRs_F_S = Table.PreLPRate([n_1_success_failure + 1]);
    n_1_FRs_F_S = Table.PreLPRate([n_1_success_failure]);   
    try
        [p,h] = signrank(n_FRs_F_S,n_1_FRs_F_S);
        if h == 1
            sigs_PreLP_F_S = [sigs_PreLP_F_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PreLP_F_S = [sigs_PreLP_F_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Successes before Failures to the Failures after it
    n_FRs_S_S = Table.PreLPRate([n_1_failure_success + 1]);
    n_1_FRs_S_S = Table.PreLPRate([n_1_failure_success]);    
    try
        [p,h] = signrank(n_FRs_S_S,n_1_FRs_S_S);
        if h == 1
            sigs_PreLP_S_F = [sigs_PreLP_S_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PreLP_S_F = [sigs_PreLP_S_F ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures before Failures to the Failures after it
    n_FRs_F_S = Table.PreLPRate([n_1_failure_failure + 1]);
    n_1_FRs_F_S = Table.PreLPRate([n_1_failure_failure]);
    try
        [p,h] = signrank(n_FRs_F_S,n_1_FRs_F_S);
        if h == 1
            sigs_PreLP_F_F = [sigs_PreLP_F_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PreLP_F_F = [sigs_PreLP_F_F ; Mouse Session True_Unit unit File];
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Post LP Offset Tests
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Compare Successes before Succeses to the Success after it
    n_FRs_S_S = Table.PostLPRate([n_1_success_success + 1]);
    n_1_FRs_S_S = Table.PostLPRate([n_1_success_success]);
    try
        [p,h] = signrank(n_FRs_S_S,n_1_FRs_S_S);
        if h == 1
            sigs_PostLP_S_S = [sigs_PostLP_S_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PostLP_S_S = [sigs_PostLP_S_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures before Succeses to the Success after it
    n_FRs_F_S = Table.PostLPRate([n_1_success_failure + 1]);
    n_1_FRs_F_S = Table.PostLPRate([n_1_success_failure]);
    try
        [p,h] = signrank(n_FRs_F_S,n_1_FRs_F_S);
        if h == 1
            sigs_PostLP_F_S = [sigs_PostLP_F_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PostLP_F_S = [sigs_PostLP_F_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Successes before Failures to the Failures after it
    n_FRs_S_S = Table.PostLPRate([n_1_failure_success + 1]);
    n_1_FRs_S_S = Table.PostLPRate([n_1_failure_success]);    
    try
        [p,h] = signrank(n_FRs_S_S,n_1_FRs_S_S);
        if h == 1
            sigs_PostLP_S_F = [sigs_PostLP_S_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PostLP_S_F = [sigs_PostLP_S_F ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures before Failures to the Failures after it
    n_FRs_F_S = Table.PostLPRate([n_1_failure_failure + 1]);
    n_1_FRs_F_S = Table.PostLPRate([n_1_failure_failure]);
    try
        [p,h] = signrank(n_FRs_F_S,n_1_FRs_F_S);
        if h == 1
            sigs_PostLP_F_F = [sigs_PostLP_F_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            sigs_PostLP_F_F = [sigs_PostLP_F_F ; Mouse Session True_Unit unit File];
        end
    end
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%
    % Pre LP Onset Tests
    %%%%%%%%%%%%%%%%%%%%
    
    % Compare Successes after Successes before Succeses to Successes after Failrues before Succeses
    n_FRs_S_S = Table.PreLPRate([n_1_success_success + 1]);
    n_FRs_F_S = Table.PreLPRate([n_1_failure_success + 1]);
    try
        [p,h] = ranksum(n_FRs_S_S,n_FRs_F_S);
        if h == 1
            outcome_PreLP_S = [outcome_PreLP_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            outcome_PreLP_S= [outcome_PreLP_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures after Successes before Failures to Failures after Failrues before Failures
    n_FRs_S_F = Table.PreLPRate([n_1_success_failure + 1]);
    n_FRs_F_F = Table.PreLPRate([n_1_failure_failure + 1]);   
    try
        [p,h] = ranksum(n_FRs_S_F,n_FRs_F_F);
        if h == 1
            outcome_PreLP_F = [outcome_PreLP_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            outcome_PreLP_F = [outcome_PreLP_F ; Mouse Session True_Unit unit File];
        end
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Post LP Offset Tests
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Compare Successes after Successes before Succeses to Successes after Failrues before Succeses
    n_FRs_S_S = Table.PostLPRate([n_1_success_success + 1]);
    n_FRs_F_S = Table.PostLPRate([n_1_failure_success + 1]);
    try
        [p,h] = ranksum(n_FRs_S_S,n_FRs_F_S);
        if h == 1
            outcome_PostLP_S = [outcome_PostLP_S ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            outcome_PostLP_S= [outcome_PostLP_S ; Mouse Session True_Unit unit File];
        end
    end
    
    % Compare Failures after Successes before Failures to Failures after Failrues before Failures
    n_FRs_S_F = Table.PostLPRate([n_1_success_failure + 1]);
    n_FRs_F_F = Table.PostLPRate([n_1_failure_failure + 1]);   
    try
        [p,h] = ranksum(n_FRs_S_F,n_FRs_F_F);
        if h == 1
            outcome_PostLP_F = [outcome_PostLP_F ; Mouse Session True_Unit unit File];
        end
    catch
        h = 0;
        if h == 1
            outcome_PostLP_F = [outcome_PostLP_F ; Mouse Session True_Unit unit File];
        end
    end


    
    
    
    
    
    
end








































%% Turn into Tables

OutcomeHistory.PreLP_S_S = array2table(sigs_PreLP_S_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PreLP_F_S = array2table(sigs_PreLP_F_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PreLP_S_F = array2table(sigs_PreLP_S_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PreLP_F_F = array2table(sigs_PreLP_F_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

OutcomeHistory.PostLP_S_S = array2table(sigs_PostLP_S_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PostLP_F_S = array2table(sigs_PostLP_F_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PostLP_S_F = array2table(sigs_PostLP_S_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.PostLP_F_F = array2table(sigs_PostLP_F_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});


OutcomeHistory.outcome_PreLP_S = array2table(outcome_PreLP_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.outcome_PreLP_F = array2table(outcome_PreLP_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.outcome_PostLP_S = array2table(outcome_PostLP_S,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
OutcomeHistory.outcome_PostLP_F = array2table(outcome_PostLP_F,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});


%% Plot

%     %%%%%%%%%%%%%%%%%%%%
%     % Pre LP Onset Plots
%     %%%%%%%%%%%%%%%%%%%%
%     
%     % Compare Successes before Succeses to the Success after it
%     files_with_units = [unique(OutcomeHistory.PreLP_S_S.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PreLP_S_S.Unit(OutcomeHistory.PreLP_S_S.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_success + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_success],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Onset: Compare Successes before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Onset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Success', 'N-1: Success'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
% 
%         end
%         
%     end
%     
%     % Compare Failures before Succeses to the Success after it
%     files_with_units = [unique(OutcomeHistory.PreLP_F_S.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PreLP_F_S.Unit(OutcomeHistory.PreLP_F_S.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_failure + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_failure],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Onset: Compare Failures before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Onset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Success', 'N-1: Failure'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
%             
%         end
%         
%     end
% 
%     % Compare Successes before Failures to the Failures after it
%     files_with_units = [unique(OutcomeHistory.PreLP_S_F.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PreLP_S_F.Unit(OutcomeHistory.PreLP_S_F.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_success + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_success],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Onset: Compare Successes before Failures to the Failures after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Onset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Failure', 'N-1: Success'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
% 
%         end
%         
%     end
%     
%     % Compare Failures before Failures to the Failures after it
%     files_with_units = [unique(OutcomeHistory.PreLP_F_F.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PreLP_F_F.Unit(OutcomeHistory.PreLP_F_F.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_failure + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_failure],time_LPON_1:time_LPON_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Onset: Compare Failures before Failures to the Failures after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Onset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Failure', 'N-1: Failure'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
% 
%         end
%         
%     end
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Post LP Offset Plots
%     %%%%%%%%%%%%%%%%%%%%%%
%     
%     % Compare Successes before Succeses to the Success after it
%     files_with_units = [unique(OutcomeHistory.PostLP_S_S.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PostLP_S_S.Unit(OutcomeHistory.PostLP_S_S.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_success + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_success],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Offset: Compare Successes before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Offset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Success', 'N-1: Success'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
%             
%         end
%         
%     end
%     
%     % Compare Failures before Succeses to the Success after it
%     files_with_units = [unique(OutcomeHistory.PostLP_F_S.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PostLP_F_S.Unit(OutcomeHistory.PostLP_F_S.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_failure + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_failure],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Offset: Compare Failures before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Offset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Success', 'N-1: Failure'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
%             
%         end
%         
%     end
%     
%     % Compare Successes before Failures to the Failures after it
%     files_with_units = [unique(OutcomeHistory.PostLP_S_F.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PostLP_S_F.Unit(OutcomeHistory.PostLP_S_F.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_success + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_success],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Offset: Compare Successes before Failures to the Failures after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Offset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Failure', 'N-1: Success'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
% 
%         end
%         
%     end
%       
%     % Compare Failures before Failures to the Failures after it
%     files_with_units = [unique(OutcomeHistory.PostLP_F_F.File)]';
%     for file = files_with_units
%         
%         units_in_file = unique([OutcomeHistory.PostLP_F_F.Unit(OutcomeHistory.PostLP_F_F.File == file)])';
%         for unit = units_in_file
%             n_idx = find(Table.Unit == unit);
%             n_durations = Table.Duration(n_idx);
%             %n_success_idx = n_idx(find(n_durations >= Criteria));
%             %n_failure_idx = n_idx(find(n_durations < Criteria));
%             n_success_idx = find(n_durations >= Criteria);
%             n_failure_idx = find(n_durations < Criteria);
%             n_1_success_idx = n_success_idx - 1;
%             n_1_failure_idx = n_failure_idx - 1;
%             n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
%             n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
%             
%             n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
%             n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
%             
%             n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
%             n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
%             
%             True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
%             
%             y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_failure + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_failure],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
%             
%             %% Plot it
%             figure('Name',['All Units: LP Offset: Compare Failures before Failures to the Failures after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
%             hold on
%             
%             n = xline(0);
%             n.LineWidth = LineWidth;
%             n.Color = 'k';
%             n.Color(4) = 0.8;
%             
%             plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
%             plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
%             
%             ylabel('Firing Rate', 'FontWeight','bold')
%             zl = ylim;
%             
%             
%             xlabel('Time from Event (ms)')
%             title({'Lever Press Offset:'})
%             set(gca,'FontSize', FontSize)
%             set(gca, 'FontName', 'Arial')
%             axis tight
%             h = zeros(2, 1);
%             h(1) = plot(NaN,NaN,'-', 'Color', blue);
%             h(2) = plot(NaN,NaN,'-', 'Color', red);
%             legend(h,{'N: Failure', 'N-1: Failure'})
%             set(h,'LineWidth',LineWidth_Legend);
%             legend boxoff
%             
% 
%         end
%         
%     end
%     
%     
    
    
    %%%%%%% HISTORY
    
    
    %%%%%%%%%%%%%%%%%%%%
    % Pre LP Onset Plots
    %%%%%%%%%%%%%%%%%%%%
    
    
     % Compare Successes before Succeses to the Success after it
    files_with_units = [unique(OutcomeHistory.outcome_PreLP_S.File)]';
    for file = files_with_units
        
        units_in_file = unique([OutcomeHistory.outcome_PreLP_S.Unit(OutcomeHistory.outcome_PreLP_S.File == file)])';
        for unit = units_in_file
            n_idx = find(Table.Unit == unit);
            n_durations = Table.Duration(n_idx);
            %n_success_idx = n_idx(find(n_durations >= Criteria));
            %n_failure_idx = n_idx(find(n_durations < Criteria));
            n_success_idx = find(n_durations >= Criteria);
            n_failure_idx = find(n_durations < Criteria);
            n_1_success_idx = n_success_idx - 1;
            n_1_failure_idx = n_failure_idx - 1;
            n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
            n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
            
            n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
            n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
            
            n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
            n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
            
            True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
            
            y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_success + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
            y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_success + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
            
            %% Plot it
            figure('Name',['All Units: LP Onset: Compare Successes before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
            hold on
            
            n = xline(0);
            n.LineWidth = LineWidth;
            n.Color = 'k';
            n.Color(4) = 0.8;
            
            plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
            plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
            
            ylabel('Firing Rate', 'FontWeight','bold')
            zl = ylim;
            
            
            xlabel('Time from Event (ms)')
            title({'Lever Press Onset: N = Success'})
            set(gca,'FontSize', FontSize)
            set(gca, 'FontName', 'Arial')
            axis tight
            h = zeros(2, 1);
            h(1) = plot(NaN,NaN,'-', 'Color', blue);
            h(2) = plot(NaN,NaN,'-', 'Color', red);
            legend(h,{'N-1: Success', 'N-1: Failure'})
            set(h,'LineWidth',LineWidth_Legend);
            legend boxoff
            

        end
        
    end
    
    
    % Compare Failures before Succeses to the Success after it
    files_with_units = [unique(OutcomeHistory.outcome_PreLP_F.File)]';
    for file = files_with_units
        
        units_in_file = unique([OutcomeHistory.outcome_PreLP_F.Unit(OutcomeHistory.outcome_PreLP_F.File == file)])';
        for unit = units_in_file
            n_idx = find(Table.Unit == unit);
            n_durations = Table.Duration(n_idx);
            %n_success_idx = n_idx(find(n_durations >= Criteria));
            %n_failure_idx = n_idx(find(n_durations < Criteria));
            n_success_idx = find(n_durations >= Criteria);
            n_failure_idx = find(n_durations < Criteria);
            n_1_success_idx = n_success_idx - 1;
            n_1_failure_idx = n_failure_idx - 1;
            n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
            n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
            
            n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
            n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
            
            n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
            n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
            
            True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
            
            y1 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_success_failure + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
            y2 = mean(Day.Mouse(file).Session.Events.LPON.PETH_data(True_Unit).bincount([n_1_failure_failure + 1],time_LPON_1:time_LPON_2))*(1000/bin_w);
            
            %% Plot it
            figure('Name',['All Units: LP Onset: Compare Failures before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
            hold on
            
            n = xline(0);
            n.LineWidth = LineWidth;
            n.Color = 'k';
            n.Color(4) = 0.8;
            
            plot(plot_time_onset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
            plot(plot_time_onset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
            
            ylabel('Firing Rate', 'FontWeight','bold')
            zl = ylim;
            
            
            xlabel('Time from Event (ms)')
            title({'Lever Press Onset: N = Failure'})
            set(gca,'FontSize', FontSize)
            set(gca, 'FontName', 'Arial')
            axis tight
            h = zeros(2, 1);
            h(1) = plot(NaN,NaN,'-', 'Color', blue);
            h(2) = plot(NaN,NaN,'-', 'Color', red);
            legend(h,{'N-1: Success', 'N-1: Failure'})
            set(h,'LineWidth',LineWidth_Legend);
            legend boxoff
            
            
        end
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Post LP Offset Plots
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Compare Successes before Succeses to the Success after it
    files_with_units = [unique(OutcomeHistory.outcome_PostLP_S.File)]';
    for file = files_with_units
        
        units_in_file = unique([OutcomeHistory.outcome_PostLP_S.Unit(OutcomeHistory.outcome_PostLP_S.File == file)])';
        for unit = units_in_file
            n_idx = find(Table.Unit == unit);
            n_durations = Table.Duration(n_idx);
            %n_success_idx = n_idx(find(n_durations >= Criteria));
            %n_failure_idx = n_idx(find(n_durations < Criteria));
            n_success_idx = find(n_durations >= Criteria);
            n_failure_idx = find(n_durations < Criteria);
            n_1_success_idx = n_success_idx - 1;
            n_1_failure_idx = n_failure_idx - 1;
            n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
            n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
            
            n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
            n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
            
            n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
            n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
            
            True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
            
            y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_success + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
            y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_success + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
            
            %% Plot it
            figure('Name',['All Units: LP Offset: Compare Successes before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
            hold on
            
            n = xline(0);
            n.LineWidth = LineWidth;
            n.Color = 'k';
            n.Color(4) = 0.8;
            
            plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
            plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
            
            ylabel('Firing Rate', 'FontWeight','bold')
            zl = ylim;
            
            
            xlabel('Time from Event (ms)')
            title({'Lever Press Offset: N = Success'})
            set(gca,'FontSize', FontSize)
            set(gca, 'FontName', 'Arial')
            axis tight
            h = zeros(2, 1);
            h(1) = plot(NaN,NaN,'-', 'Color', blue);
            h(2) = plot(NaN,NaN,'-', 'Color', red);
            legend(h,{'N-1: Success', 'N-1: Failure'})
            set(h,'LineWidth',LineWidth_Legend);
            legend boxoff
            
            
        end
        
    end
    
    
    % Compare Successes before Succeses to the Success after it
    files_with_units = [unique(OutcomeHistory.outcome_PostLP_F.File)]';
    for file = files_with_units
        
        units_in_file = unique([OutcomeHistory.outcome_PostLP_F.Unit(OutcomeHistory.outcome_PostLP_F.File == file)])';
        for unit = units_in_file
            n_idx = find(Table.Unit == unit);
            n_durations = Table.Duration(n_idx);
            %n_success_idx = n_idx(find(n_durations >= Criteria));
            %n_failure_idx = n_idx(find(n_durations < Criteria));
            n_success_idx = find(n_durations >= Criteria);
            n_failure_idx = find(n_durations < Criteria);
            n_1_success_idx = n_success_idx - 1;
            n_1_failure_idx = n_failure_idx - 1;
            n_1_success_idx(find(n_1_success_idx < 1)) = []; % remove outside index
            n_1_failure_idx(find(n_1_failure_idx < 1)) = []; % remove outside index
            
            n_1_success_success = n_1_success_idx(find(Table.Duration(n_1_success_idx) >= Criteria));
            n_1_success_failure = n_1_success_idx(find(Table.Duration(n_1_success_idx) < Criteria));
            
            n_1_failure_success = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) >= Criteria));
            n_1_failure_failure = n_1_failure_idx(find(Table.Duration(n_1_failure_idx) < Criteria));
            
            True_Unit = unique(Table.True_Unit(find(Table.Unit == unit)));
            
            y1 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_success_failure + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
            y2 = mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(True_Unit).bincount([n_1_failure_failure + 1],time_LPOFF_1:time_LPOFF_2))*(1000/bin_w);
            
            %% Plot it
            figure('Name',['All Units: LP Offset: Compare Successes before Succeses to the Success after it'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
            hold on
            
            n = xline(0);
            n.LineWidth = LineWidth;
            n.Color = 'k';
            n.Color(4) = 0.8;
            
            plot(plot_time_offset,smoothdata(y1,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
            plot(plot_time_offset,smoothdata(y2,2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
            
            ylabel('Firing Rate', 'FontWeight','bold')
            zl = ylim;
            
            
            xlabel('Time from Event (ms)')
            title({'Lever Press Offset: N = Failure'})
            set(gca,'FontSize', FontSize)
            set(gca, 'FontName', 'Arial')
            axis tight
            h = zeros(2, 1);
            h(1) = plot(NaN,NaN,'-', 'Color', blue);
            h(2) = plot(NaN,NaN,'-', 'Color', red);
            legend(h,{'N-1: Success', 'N-1: Failure'})
            set(h,'LineWidth',LineWidth_Legend);
            legend boxoff
            
            
        end
        
    end
    

end

