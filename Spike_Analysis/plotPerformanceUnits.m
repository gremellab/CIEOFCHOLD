function [D] = plotPerformanceUnits(Day)
%% Figure properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 10;
LineWidth = 2;
LineWidth_Legend = 3;
size_w = 350;
size_h = 350;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
smooth_win = 400;
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
%
% All Units
%
%%%%%%%%%%%%%
%% After Success vs After Failure
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Success_vs_After_Failure;
After_Success_Data_PreLP = [];
After_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Data_PreLP = [After_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Failure_Data_PreLP = [After_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Success_vs_After_Failure;
After_Success_Data_PostLP = [];
After_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Data_PostLP = [After_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Failure_Data_PostLP = [After_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end

%% After Success Success vs After Success Failure
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Success_Success_vs_After_Success_Failure;
After_Success_Success_Data_PreLP = [];
After_Success_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PreLP = [After_Success_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Success_Failure_Data_PreLP = [After_Success_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PreLP,1)
    figure('Name',['All Units: LP Onset: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Success_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Success_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Onset:', 'After Success'};
figNames = 'LP Onset: All Units: After Success Success vs After Success Failure';
data_success = [After_Success_Success_Data_PreLP];
data_failure = [After_Success_Failure_Data_PreLP];
[D.PreLP_After_Success_Success_vs_After_Success_Failure] = primeCalculation(data_success,data_failure, plot_time_onset, titles, figNames );
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Success_Success_vs_After_Success_Failure;
After_Success_Success_Data_PostLP = [];
After_Success_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PostLP = [After_Success_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Success_Failure_Data_PostLP = [After_Success_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PostLP,1)
    figure('Name',['All Units: LP Offset: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Success_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Success_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Onset:', 'After Success'};
figNames = 'LP Onset: All Units: After Success Success vs After Success Failure';
data_success = [After_Success_Success_Data_PostLP];
data_failure = [After_Success_Failure_Data_PostLP];
[D.PostLP_After_Success_Success_vs_After_Success_Failure] = primeCalculation(data_success,data_failure, plot_time_offset, titles, figNames );

%% After Failure Success vs After Failure Failure
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Failure_Success_vs_After_Failure_Failure;
After_Failure_Success_Data_PreLP = [];
After_Failure_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PreLP = [After_Failure_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PreLP = [After_Failure_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PreLP,1)
    figure('Name',['All Units: LP Onset: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Failure_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Failure_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Onset:', 'After Failure'};
figNames = 'LP Onset: All Units: After Failure Success vs After Failure Failure';
data_success = [After_Failure_Success_Data_PreLP];
data_failure = [After_Failure_Failure_Data_PreLP];
[D.PreLP_After_Failure_Success_vs_After_Failure_Failure] = primeCalculation(data_success,data_failure, plot_time_onset, titles, figNames );
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Failure_Success_vs_After_Failure_Failure;
After_Failure_Success_Data_PostLP = [];
After_Failure_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PostLP = [After_Failure_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PostLP = [After_Failure_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PostLP,1)
    figure('Name',['All Units: LP Offset: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Failure_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Failure_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Offset:', 'After Failure'};
figNames = 'LP Offset: All Units: After Failure Success vs After Failure Failure';
data_success = [After_Failure_Success_Data_PostLP];
data_failure = [After_Failure_Failure_Data_PostLP];
[D.PostLP_After_Failure_Success_vs_After_Failure_Failure] = primeCalculation(data_success,data_failure, plot_time_offset, titles, figNames );







%% Before Success Success vs Before Success Failure
%% Pre Lever Press Onset
Table = Day.Prime.preLP_Before_Success_Success_vs_Before_Success_Failure;
Before_Success_Success_Data_PreLP = [];
Before_Success_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    before_success_idx = find(Day.Mouse(file).Session.LP_Length >= Day.Mouse(file).Session.Criteria) - 1;
    before_failure_idx = find(Day.Mouse(file).Session.LP_Length < Day.Mouse(file).Session.Criteria) - 1;
    before_success_idx(find(before_success_idx <= 0)) = []; 
    before_failure_idx(find(before_failure_idx <= 0)) = [];
    before_success_success_idx = before_success_idx(LP_Lengths(before_success_idx) >= Day.Mouse(file).Session.Criteria);
    before_success_failure_idx = before_success_idx(LP_Lengths(before_success_idx) < Day.Mouse(file).Session.Criteria);
    before_failure_success_idx = before_failure_idx(LP_Lengths(before_failure_idx) >= Day.Mouse(file).Session.Criteria);
    before_failure_failure_idx = before_failure_idx(LP_Lengths(before_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        Before_Success_Success_Data_PreLP = [Before_Success_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(before_success_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        Before_Success_Failure_Data_PreLP = [Before_Success_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(before_success_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1:size(Before_Success_Success_Data_PreLP,1)
    figure('Name',['All Units: LP Onset: Before Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(Before_Success_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(Before_Success_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'Before Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Onset:', 'Before Success'};
figNames = 'LP Onset: All Units: Before Success Success vs Before Success Failure';
data_success = [Before_Success_Success_Data_PreLP];
data_failure = [Before_Success_Failure_Data_PreLP];
[D.PreLP_Before_Success_Success_vs_Before_Success_Failure] = primeCalculation(data_success,data_failure, plot_time_onset, titles, figNames );
%% Post Lever Press Offset
Table = Day.Prime.postLP_Before_Success_Success_vs_Before_Success_Failure;
Before_Success_Success_Data_PostLP = [];
Before_Success_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    before_success_idx = find(Day.Mouse(file).Session.LP_Length >= Day.Mouse(file).Session.Criteria) - 1;
    before_failure_idx = find(Day.Mouse(file).Session.LP_Length < Day.Mouse(file).Session.Criteria) - 1;
    before_success_idx(find(before_success_idx <= 0)) = []; 
    before_failure_idx(find(before_failure_idx <= 0)) = [];
    before_success_success_idx = before_success_idx(LP_Lengths(before_success_idx) >= Day.Mouse(file).Session.Criteria);
    before_success_failure_idx = before_success_idx(LP_Lengths(before_success_idx) < Day.Mouse(file).Session.Criteria);
    before_failure_success_idx = before_failure_idx(LP_Lengths(before_failure_idx) >= Day.Mouse(file).Session.Criteria);
    before_failure_failure_idx = before_failure_idx(LP_Lengths(before_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        Before_Success_Success_Data_PostLP = [Before_Success_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(before_success_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        Before_Success_Failure_Data_PostLP = [Before_Success_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(before_success_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1:20%size(Before_Success_Failure_Data_PostLP,1)
    figure('Name',['All Units: LP Offset: Before Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(Before_Success_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(Before_Success_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'Before Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Offset:', 'Before Success'};
figNames = 'LP Offset: All Units: Before Success Success vs Before Success Failure';
data_success = [Before_Success_Success_Data_PostLP];
data_failure = [Before_Success_Failure_Data_PostLP];
[D.PostLP_Before_Success_Success_vs_Before_Success_Failure] = primeCalculation(data_success,data_failure, plot_time_offset, titles, figNames );


%% Before Failure Success vs Before Failure Failure
%% Pre Lever Press Onset
Table = Day.Prime.preLP_Before_Failure_Success_vs_Before_Failure_Failure;
Before_Failure_Success_Data_PreLP = [];
Before_Failure_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    before_success_idx = find(Day.Mouse(file).Session.LP_Length >= Day.Mouse(file).Session.Criteria) - 1;
    before_failure_idx = find(Day.Mouse(file).Session.LP_Length < Day.Mouse(file).Session.Criteria) - 1;
    before_success_idx(find(before_success_idx <= 0)) = []; 
    before_failure_idx(find(before_failure_idx <= 0)) = [];
    before_success_success_idx = before_success_idx(LP_Lengths(before_success_idx) >= Day.Mouse(file).Session.Criteria);
    before_success_failure_idx = before_success_idx(LP_Lengths(before_success_idx) < Day.Mouse(file).Session.Criteria);
    before_failure_success_idx = before_failure_idx(LP_Lengths(before_failure_idx) >= Day.Mouse(file).Session.Criteria);
    before_failure_failure_idx = before_failure_idx(LP_Lengths(before_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        Before_Failure_Success_Data_PreLP = [Before_Failure_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(before_failure_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        Before_Failure_Failure_Data_PreLP = [Before_Failure_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(before_failure_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1:size(Before_Failure_Success_Data_PreLP,1)
    figure('Name',['All Units: LP Onset: Before Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(Before_Failure_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(Before_Failure_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'Before Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Onset:', 'Before Failure'};
figNames = 'LP Onset: All Units: Before Failure Success vs Before Failure Failure';
data_success = [Before_Failure_Success_Data_PreLP];
data_failure = [Before_Failure_Failure_Data_PreLP];
[D.PreLP_Before_Failure_Success_vs_Before_Failure_Failure] = primeCalculation(data_success,data_failure, plot_time_onset, titles, figNames );
%% Post Lever Press Offset
Table = Day.Prime.postLP_Before_Failure_Success_vs_Before_Failure_Failure;
Before_Failure_Success_Data_PostLP = [];
Before_Failure_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    before_success_idx = find(Day.Mouse(file).Session.LP_Length >= Day.Mouse(file).Session.Criteria) - 1;
    before_failure_idx = find(Day.Mouse(file).Session.LP_Length < Day.Mouse(file).Session.Criteria) - 1;
    before_success_idx(find(before_success_idx <= 0)) = []; 
    before_failure_idx(find(before_failure_idx <= 0)) = [];
    before_success_success_idx = before_success_idx(LP_Lengths(before_success_idx) >= Day.Mouse(file).Session.Criteria);
    before_success_failure_idx = before_success_idx(LP_Lengths(before_success_idx) < Day.Mouse(file).Session.Criteria);
    before_failure_success_idx = before_failure_idx(LP_Lengths(before_failure_idx) >= Day.Mouse(file).Session.Criteria);
    before_failure_failure_idx = before_failure_idx(LP_Lengths(before_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        Before_Failure_Success_Data_PostLP = [Before_Failure_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(before_failure_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        Before_Failure_Failure_Data_PostLP = [Before_Failure_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(before_failure_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1:20%size(Before_Failure_Failure_Data_PostLP,1)
    figure('Name',['All Units: LP Offset: Before Failure Success vs Before Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(Before_Failure_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(Before_Failure_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'Before Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% Plot Prime
titles = {'Lever Press Offset:', 'Before Failure'};
figNames = 'LP Offset: All Units: Before Failure Success vs Before Failure Failure';
data_success = [Before_Failure_Success_Data_PostLP];
data_failure = [Before_Failure_Failure_Data_PostLP];
[D.PostLP_Before_Failure_Success_vs_Before_Failure_Failure] = primeCalculation(data_success,data_failure, plot_time_offset, titles, figNames );









%%%%%%%%%%%%%%%%%
%
% Up & Down Units
%
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% After Success Success vs After Success Failure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Up Units
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Success_Success_vs_After_Success_Failure_LPON_Up;
After_Success_Success_Data_PreLP = [];
After_Success_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PreLP = [After_Success_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Success_Failure_Data_PreLP = [After_Success_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PreLP,1)
    figure('Name',['LP Onset: Up Modulated: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Success_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Success_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
%% UP Units
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Success_Success_vs_After_Success_Failure_LPOFF_Up;
After_Success_Success_Data_PostLP = [];
After_Success_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PostLP = [After_Success_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Success_Failure_Data_PostLP = [After_Success_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PostLP,1)
    figure('Name',['LP Offset: Up Modulated: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Success_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Success_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
%% Down Units
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Success_Success_vs_After_Success_Failure_LPON_Down;
After_Success_Success_Data_PreLP = [];
After_Success_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PreLP = [After_Success_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Success_Failure_Data_PreLP = [After_Success_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_success_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PreLP,1)
    figure('Name',['LP Onset: Down Modulated: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Success_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Success_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
%% Down Units
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Success_Success_vs_After_Success_Failure_LPOFF_Down;
After_Success_Success_Data_PostLP = [];
After_Success_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Success_Success_Data_PostLP = [After_Success_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Success_Failure_Data_PostLP = [After_Success_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_success_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Success_Success_Data_PostLP,1)
    figure('Name',['LP Offset: Down Modulated: After Success Success vs After Success Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Success_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Success_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Success'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% After Failure Success vs After Failure Failure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Up Units
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Failure_Success_vs_After_Failure_Failure_LPON_Up;
After_Failure_Success_Data_PreLP = [];
After_Failure_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PreLP = [After_Failure_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PreLP = [After_Failure_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PreLP,1)
    figure('Name',['LP Onset: Up Modulated: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Failure_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Failure_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
%% UP Units
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Failure_Success_vs_After_Failure_Failure_LPOFF_Up;
After_Failure_Success_Data_PostLP = [];
After_Failure_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PostLP = [After_Failure_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PostLP = [After_Failure_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PostLP,1)
    figure('Name',['LP Offset: Up Modulated: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Failure_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Failure_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
% % Plot Prime
% titles = {'Lever Press Offset:', 'After Failure'};
% figNames = 'LP Offset: Up Modulated: After Failure Success vs After Failure Failure';
% data_success = [After_Failure_Success_Data_PreLP ; After_Failure_Success_Data_PostLP];
% data_failure = [After_Failure_Failure_Data_PreLP ; After_Failure_Failure_Data_PostLP];
% primeCalculation(data_success,data_failure, plot_time_offset, titles, figNames );
%% Down Units
%% Pre Lever Press Onset
Table = Day.Prime.preLP_After_Failure_Success_vs_After_Failure_Failure_LPON_Down;
After_Failure_Success_Data_PreLP = [];
After_Failure_Failure_Data_PreLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PreLP = [After_Failure_Success_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_success_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PreLP = [After_Failure_Failure_Data_PreLP; mean(Day.Mouse(file).Session.Events.LPON.PETH_data(unit).bincount(after_failure_failure_idx,time_LPON_1:time_LPON_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PreLP,1)
    figure('Name',['LP Onset: Down Modulated: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_onset,smoothdata(After_Failure_Success_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_onset,smoothdata(After_Failure_Failure_Data_PreLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Onset:', 'After Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
%% Down Units
%% Post Lever Press Offset
Table = Day.Prime.postLP_After_Failure_Success_vs_After_Failure_Failure_LPOFF_Down;
After_Failure_Success_Data_PostLP = [];
After_Failure_Failure_Data_PostLP = [];
files_with_units = [unique(Table.File)]';
for file = files_with_units
% Find indices of success, failure, and following lever press
    LP_Lengths = Day.Mouse(file).Session.LP_Length;
    success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria);
    failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria);
    after_success_idx = find(LP_Lengths >= Day.Mouse(file).Session.Criteria) + 1;
    after_failure_idx = find(LP_Lengths < Day.Mouse(file).Session.Criteria) + 1;
    after_success_idx(find(after_success_idx > length(LP_Lengths))) = [];
    after_failure_idx(find(after_failure_idx > length(LP_Lengths))) = [];
    success_idx(find(success_idx == length(LP_Lengths))) = [];
    failure_idx(find(failure_idx == length(LP_Lengths))) = [];
    after_success_success_idx = after_success_idx(LP_Lengths(after_success_idx) >= Day.Mouse(file).Session.Criteria);
    after_success_failure_idx = after_success_idx(LP_Lengths(after_success_idx) < Day.Mouse(file).Session.Criteria);
    after_failure_success_idx = after_failure_idx(LP_Lengths(after_failure_idx) >= Day.Mouse(file).Session.Criteria);
    after_failure_failure_idx = after_failure_idx(LP_Lengths(after_failure_idx) < Day.Mouse(file).Session.Criteria);
    
    units_in_file = Table.True_Unit(Table.File == file)';
    for unit = units_in_file
        After_Failure_Success_Data_PostLP = [After_Failure_Success_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_success_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
        After_Failure_Failure_Data_PostLP = [After_Failure_Failure_Data_PostLP; mean(Day.Mouse(file).Session.Events.LPOFF.PETH_data(unit).bincount(after_failure_failure_idx,time_LPOFF_1:time_LPOFF_2))*(1000/bin_w)];
    end
end
% Plot it
for unit = 1%:size(After_Failure_Success_Data_PostLP,1)
    figure('Name',['LP Offset: Down Modulated: After Failure Success vs After Failure Failure'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
    hold on
    
    n = xline(0);
    n.LineWidth = LineWidth;
    n.Color = 'k';
    n.Color(4) = 0.8;

    plot(plot_time_offset,smoothdata(After_Failure_Success_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', blue);
    plot(plot_time_offset,smoothdata(After_Failure_Failure_Data_PostLP(unit,:),2,smooth_type,smooth_win), 'LineWidth', LineWidth, 'Color', red);
    
    ylabel('Firing Rate', 'FontWeight','bold')
    zl = ylim;
 
    
    xlabel('Time from Event (ms)')
    title({'Lever Press Offset:', 'After Failure'})
    set(gca,'FontSize', FontSize)
    set(gca, 'FontName', 'Arial')
    axis tight
    h = zeros(2, 1);
    h(1) = plot(NaN,NaN,'-', 'Color', blue);
    h(2) = plot(NaN,NaN,'-', 'Color', red);
    legend(h,{'Success', 'Fail'})
    set(h,'LineWidth',LineWidth_Legend);
    legend boxoff
end
