function [] = plot_SingleSession(mouse, unit, Day)
%Plots Single Recording session unit raster and PETH alongside behavior
%mouse = 11;
%unit = 4;
% Down Unit Example:
%mouse = 17;
%unit = 1;
%mouse = 12;
%unit = 4;
% Up Unit Example:
%mouse = 12;
%unit = 9;
%mouse = 16; % lengths hug criteria
%unit = 1;
% Figure properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 8;
LineWidth_Behavior = 1;
LineWidth = 2;
LineWidth_Z = 1;
LineWidth_Legend = 3;
LineWidth_Raster = 1;
MarkerSize = 3;
size_w = 125;
size_h = 250; % used to be 350
size_w_rast = 185; %size_w_rast = 150; paper
size_h_rast = 200; %size_h_rast = 350; paper
size_w_peth = 150;
size_h_peth = 200;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
green = [0.4660, 0.6740, 0.1880];
purple = [0.4940, 0.1840, 0.5560];
other_blue = [0.3010, 0.7450, 0.9330];
yellow = [0.9290, 0.6940, 0.1250];
other_red = [0.6350, 0.0780, 0.1840];
smooth_win = 20;
time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
%time = Day.Mouse(1).Session.plot_time;
start_time_idx = find(time == -2000); % from 2000 ms before event
end_time_idx = find(time == 5000); % to 4980 ms after event
criteria = Day.Mouse(1).Session.Criteria * 1000;
plot_time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time(start_time_idx:end_time_idx);
%plot_time = time(start_time_idx:end_time_idx);
%% Plot Met vs Fail Lever Press Length Distribution
figure('Name',['Lever Press Durations Met vs Fail Example'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
hold on
s = xline([Day.Mouse(mouse).Session.Criteria*1000]);
s.LineWidth = LineWidth;
s.Color = 'k';
s.Color(4) = 0.8;
for lever_press = length(Day.Mouse(mouse).Session.LP_Length):-1:1
    %sorted_times = sort(Day.Mouse(7).Session.LP_Length, 'descend');

    if Day.Mouse(mouse).Session.LP_Length(lever_press)*1000 >= (Day.Mouse(mouse).Session.Criteria*1000)
        t = plot([0 Day.Mouse(mouse).Session.LP_Length(lever_press)*1000],[lever_press lever_press], '-b');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Behavior;
    else
        t = plot([0 Day.Mouse(mouse).Session.LP_Length(lever_press)*1000],[lever_press lever_press], '-r');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',red)
        t.LineWidth = LineWidth_Behavior;
    end
    
end
set ( gca, 'ydir', 'reverse' )
set(gca,'TickDir','out')
yticks([100:100:400])
ylim([1 length(Day.Mouse(mouse).Session.LP_Length)+1])
xlim([0 3000])
xticks([0:1*1000:5*1000])
%axis tight
xlabel('Duration (ms)')
%ylabel({'Lever Press', '(in Order of Occurrence)'})
ylabel({'Lever Press'})
title({'Lever Press Durations','within a Session'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [0.3 0.3 0.3]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off
%% Plot Quantile Split Lever Press Length Distribution
Lengths = Day.Mouse(mouse).Session.LP_Length; % seconds
edge_start = [0 0.25 0.50 0.75];
edge_end = [0.25 0.50 0.75 1];
Counts = [];
True_edges = zeros(4,2);
for quart = 1:4
    edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
    if quart == 1
        quart_lenghts = Lengths(Lengths >= edges(1) & Lengths <= edges(2));
    else
        quart_lenghts = Lengths(Lengths > edges(1) & Lengths <= edges(2));
    end
    True_edges(quart,:) = edges;
end
quant_1_idx = find(Lengths >= True_edges(1,1) & Lengths <= True_edges(1,2));
quant_1_duration = Lengths(quant_1_idx);
quant_2_idx = find(Lengths > True_edges(2,1) & Lengths <= True_edges(2,2));
quant_2_duration = Lengths(quant_2_idx);
quant_3_idx = find(Lengths > True_edges(3,1) & Lengths <= True_edges(3,2));
quant_3_duration = Lengths(quant_3_idx);
quant_4_idx = find(Lengths > True_edges(4,1) & Lengths <= True_edges(4,2));
quant_4_duration = Lengths(quant_4_idx);

figure('Name',['Lever Press Durations Quantile Example'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast 400])
hold on
s = xline([Day.Mouse(mouse).Session.Criteria*1000]);
s.LineWidth = LineWidth;
s.Color = 'k';
s.Color(4) = 0.8;
for lever_press = length(Day.Mouse(mouse).Session.LP_Length):-1:1
    %sorted_times = sort(Day.Mouse(7).Session.LP_Length, 'descend');
 
    if any(lever_press == quant_1_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-b');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_2_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-r');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',red)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_3_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-g');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',green)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_4_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-m');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',purple)
        t.LineWidth = LineWidth_Behavior;
    end
end

set ( gca, 'ydir', 'reverse' )
set(gca,'TickDir','out')

yticks([100:100:400])
ylim([1 length(Day.Mouse(mouse).Session.LP_Length)+1])
xlim([0 3000])
xticks([0:1*1000:5*1000])
%axis tight
xlabel('Duration (ms)')
%ylabel({'Lever Press', '(in Order of Occurrence)'})
ylabel({'Lever Press'})
title({'Lever Press Durations','within a Session'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'}, 'Location', 'eastoutside');
% set(h,'LineWidth',LineWidth_Legend);
% title(hleg, 'Quantile')
% legend boxoff
hold off
%% Plot Single Session Raster (Met vs Fail)
%% Lever Press Onset
% Plot raster
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
[~,Bsort]=sort(Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);

figure('Name',['Lever Press Onset Met vs Fail Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast])
% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = 1;
% n.Color = 'k';
% n.Color(4) = 0.8;

MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = MarkerSize;
plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);
title('Raster of Up-Modulated Unit');

% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;

hold on
count = 1;
for lever_press = Bsort'
     t = plot([Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[count count], '-');
    if Day.Mouse(mouse).Session.LP_Length(lever_press) >= Day.Mouse(mouse).Session.Criteria
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    else
        %t = plot([Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[lever_press lever_press], '-');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',red)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    end
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
ylim([1 length(Day.Mouse(mouse).Session.LP_Length)+1])
yticks([100:100:400])
xticks([-3 -2 -1 0 1 2 3])
%ylabel({'Lever Press', '(Sorted by Duration)'})
ylabel({'Lever Press'})
xlabel('Time from Event (s)')
title({'Lever Press Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [[0.3 0.3 0.3]]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met Offset', 'Fail Offset'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
%axis tight
hold off




%% Lever Press Offset
% Plot raster
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
[~,Bsort]=sort(Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);

figure('Name',['Lever Press Offset Met vs Fail Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast])
MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = MarkerSize;
plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);
title('Raster of Up-Modulated Unit');

% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;

% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = 2;
% n.Color = 'k';
% n.Color(4) = 0.8;

hold on
count = 1;
for lever_press = Bsort'
     t = plot(-[Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[count count], '-');
    if Day.Mouse(mouse).Session.LP_Length(lever_press) >= Day.Mouse(mouse).Session.Criteria
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    else
        %t = plot([Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[lever_press lever_press], '-');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',red)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    end
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
yticks([100:100:400])
xticks([-3 -2 -1 0 1 2 3])
%ylabel({'Lever Press', '(Sorted by Duration)'})
ylabel({'Lever Press'})
xlabel('Time from Event (s)')
title({'Lever Press Offset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Met Onset', 'Fail Onset'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% axis tight
hold off



%% Reinforcement Onset
% Plot raster
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.ReinON.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
Rein_Lengths = Lengths(Lengths > Day.Mouse(mouse).Session.Criteria +.01);
[~,Bsort]=sort(Rein_Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);

figure('Name',['Reinforcement Onset Met vs Fail Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast])

% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;

MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = MarkerSize;

plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);



% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = 2;
% n.Color = 'k';
% n.Color(4) = 0.8;

hold on
count = 1;
for lever_press = Bsort'
    t = plot(-[Rein_Lengths(lever_press)-.1 Rein_Lengths(lever_press)],[count count], '-');
    
    set(t,'LineWidth',6,'LineStyle','-')
    set(t,'Color',blue)
    t.LineWidth = LineWidth_Raster + 2;
    t.Color(4) = 0.95;
    
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
yticks([0:20:70])
xticks([-3 -2 -1 0 1 2 3])
%ylabel({'Lever Press', '(Sorted by Duration)'})
ylabel({'Lever Press'})
xlabel('Time from Event (s)')
%xticks([-2.98 0 2.96]) % last xtick missing?
%xticklabels({'-3', '0', '3'})

title({'Reinforcement Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(1, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [[0.3 0.3 0.3]]);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% legend(h,{['Met Onset']}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
axis tight
hold off










%% Plot Single Session Raster (Quantile)
%% Lever Press Onset
% Plot raster
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
[~,Bsort]=sort(Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);

figure('Name',['Lever Press Onset Quantile Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast]);
n = xline([Day.Mouse(mouse).Session.Criteria]);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;
MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = MarkerSize;
plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);
title('Raster of Up-Modulated Unit');
% ax = axes;
% hold(ax,'on')
% ylim([-3, 3])
%tree.XLim = [-3 3];
% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;
hold on;
count = 1;
for lever_press = Bsort'
     t = plot([Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[count count], '-');
    if any(lever_press == quant_1_idx)
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    elseif any(lever_press == quant_2_idx)
        set(t,'Color',red)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    elseif any(lever_press == quant_3_idx)
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',green)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    elseif any(lever_press == quant_4_idx)
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',purple)
        t.LineWidth = LineWidth_Raster;
        t.Color(4) = 0.95;
    end 
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
yticks([100:100:400])
xticks([-3 -2 -1 0 1 2 3])
ylabel({'Lever Press', '(Sorted by Duration)'})
xlabel('Time from Event (s)')
title({'Lever Press Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'}, 'Location', 'eastoutside');
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
axis tight
hold off



%% Plot Single Unit PETH

%% Stats
y1 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_1_z(1:7001);
y2 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_2_z(1:7001);
y3 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_3_z(1:7001);
y4 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_4_z(1:7001);


%% Plot it
figure('Name',['Lever Press Onset Quantile PETH'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast]);
hold on
set(gca, 'YLim', [0, 15]);
set(gca, 'XLim', [-2000, 3000]);
xticks([-2000 -1000 0 1000 2000 3000])
xticklabels({'-2', '-1', '0', '1', '2', '3'})

% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = LineWidth;
% n.Color = 'k';
% n.Color(4) = 0.8;


s = plot(plot_time, smoothdata(y1,2,'sgolay',smooth_win),'-b');
set(s,'LineWidth',6,'LineStyle','-')
set(s,'Color',blue)
s.LineWidth = LineWidth_Z;

t = plot(plot_time, smoothdata(y2,2,'sgolay',smooth_win),'-r');
set(t,'LineWidth',6,'LineStyle','-')
set(t,'Color',red)
t.LineWidth = LineWidth_Z;

h = plot(plot_time, smoothdata(y3,2,'sgolay',smooth_win),'-r');
set(h,'LineWidth',6,'LineStyle','-')
set(h,'Color',green)
h.LineWidth = LineWidth_Z;


j = plot(plot_time, smoothdata(y4,2,'sgolay',smooth_win),'-r');
set(j,'LineWidth',6,'LineStyle','-')
set(j,'Color',purple)
j.LineWidth = LineWidth_Z;

ylabel('Firing Rate (Z)')
% zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;



xlabel('Time from Event (s)')
title({'Lever Press Onset: Quantile'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')


%% Lever Press Offset (Quantile)
% Plot raster
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
[~,Bsort]=sort(Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);

figure('Name',['Lever Press Offset Quantile Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast size_h_rast])
MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = MarkerSize;
plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);
title('Raster of Up-Modulated Unit');

% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;

% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = 2;
% n.Color = 'k';
% n.Color(4) = 0.8;

hold on
count = 1;
for lever_press = Bsort'
     t = plot(-[Day.Mouse(mouse).Session.LP_Length(lever_press)-.1 Day.Mouse(mouse).Session.LP_Length(lever_press)],[count count], '-');
     if any(lever_press == quant_1_idx)
         set(t,'LineWidth',6,'LineStyle','-')
         set(t,'Color',blue)
         t.LineWidth = LineWidth_Raster;
         t.Color(4) = 0.95;
     elseif any(lever_press == quant_2_idx)
         set(t,'Color',red)
         t.LineWidth = LineWidth_Raster;
         t.Color(4) = 0.95;
     elseif any(lever_press == quant_3_idx)
         set(t,'LineWidth',6,'LineStyle','-')
         set(t,'Color',green)
         t.LineWidth = LineWidth_Raster;
         t.Color(4) = 0.95;
     elseif any(lever_press == quant_4_idx)
         set(t,'LineWidth',6,'LineStyle','-')
         set(t,'Color',purple)
         t.LineWidth = LineWidth_Raster;
         t.Color(4) = 0.95;
     end
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
yticks([100:100:400])
xticks([-3 -2 -1 0 1 2 3])
ylabel({'Lever Press', '(Sorted by Duration)'})
xlabel('Time from Event (s)')
title({'Lever Press Offset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'}, 'Location', 'eastoutside');
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
axis tight
hold off



% %% Reinforcement Onset
% % Plot raster
% Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.ReinON.PETH_data(unit).trial);
% Spike_Times_Cell = cell(length(Spike_Times),1);
% for trial = 1:length(Spike_Times)
%     Spike_Times_Seconds = {Spike_Times{trial} / 1000};
%     Spike_Times_Cell(trial) =  Spike_Times_Seconds;
% end
% Rein_Lengths = Lengths(Lengths > Day.Mouse(mouse).Session.Criteria +.01);
% [~,Bsort]=sort(Rein_Lengths); %Get the order of B
% Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);
% 
% figure('Name',['Lever Press Durations Example'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
% MarkerFormat.Color = [.2 .2 .2];
% plotSpikeRaster(Sorted_Spike_Times_Cell,'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[-3 3]);
% title('Raster of Up-Modulated Unit');
% 
% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;
% 
% % n = xline([Day.Mouse(mouse).Session.Criteria]);
% % n.LineWidth = 2;
% % n.Color = 'k';
% % n.Color(4) = 0.8;
% 
% hold on
% count = 1;
% for lever_press = Bsort'
%     t = plot(-[Rein_Lengths(lever_press)-.1 Rein_Lengths(lever_press)],[count count], '-');
%     
%     set(t,'LineWidth',6,'LineStyle','-')
%     set(t,'Color',blue)
%     t.LineWidth = LineWidth;
%     t.Color(4) = 0.95;
%     
%     count = count+1;
% end
% set ( gca, 'ydir', 'reverse' )
% ylabel({'Lever Press', '(Sorted by Duration)'})
% xlabel('Time from Event (ms)')
% title({'Reinforcement Onset:', 'Criteria Met Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [[0.3 0.3 0.3]]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% legend(h,{'Criteria',[newline 'Lever' newline 'Press' newline 'Onset']}, 'Location','northwest')
% set(h,'LineWidth',LineWidth_Legend);
% axis tight
% hold off

%% Plot Single Unit Z-Scored PETH
% LP Onset

%% LP ON: Single Unit
%% Stats
y1 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_met(start_time_idx:end_time_idx);
y2 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_fail(start_time_idx:end_time_idx);
n1 = size(y1,1);
n2 = size(y2,1);
%% Plot it
figure('Name',['Lever Press Onset Met vs Fail Z-score'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_peth size_h_peth])
hold on
set(gca, 'YLim', [0, 15]);
set(gca, 'XLim', [-2000, 3000]);
xticks([-2000 -1000 0 1000 2000 3000])
xticklabels({'-2', '-1', '0', '1', '2', '3'})
% n = xline(0);
% n.LineWidth = LineWidth;
% n.Color = 'k';
% n.Color(4) = 0.8;
% 
% p = xline(Day.Mouse(mouse).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

s = plot(plot_time, smoothdata(y1,2,'sgolay',smooth_win),'-b');
    set(s,'LineWidth',6,'LineStyle','-')
    set(s,'Color',blue)
    s.LineWidth = LineWidth_Z;

t = plot(plot_time, smoothdata(y2,2,'sgolay',smooth_win),'-r');
    set(t,'LineWidth',6,'LineStyle','-')
    set(t,'Color',red)
    t.LineWidth = LineWidth_Z;

ylabel('Firing Rate')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (s)')
title({'Lever Press Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight

% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off

%% LP OFF: Single Unit
%% Stats
y1 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_met(start_time_idx:end_time_idx);
y2 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_fail(start_time_idx:end_time_idx);
n1 = size(y1,1);
n2 = size(y2,1);
%% Plot it
figure('Name',['Lever Press Offset Met vs Fail Z-score'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_peth size_h_peth])
hold on
set(gca, 'YLim', [0, 15]);
set(gca, 'XLim', [-2000, 3000]);
xticks([-2000 -1000 0 1000 2000 3000])
xticklabels({'-2', '-1', '0', '1', '2', '3'})

% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = LineWidth;
% n.Color = 'k';
% n.Color(4) = 0.8;


s = plot(plot_time, smoothdata(y1,2,'sgolay',smooth_win),'-b');
    set(s,'LineWidth',6,'LineStyle','-')
    set(s,'Color',blue)
    s.LineWidth = LineWidth_Z;

t = plot(plot_time, smoothdata(y2,2,'sgolay',smooth_win),'-r');
    set(t,'LineWidth',6,'LineStyle','-')
    set(t,'Color',red)
    t.LineWidth = LineWidth_Z;

ylabel('Firing Rate')
% zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;



xlabel('Time from Event (s)')
title({'Lever Press Offset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')

%axis tight
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff



%% Reinforcement Onset: Single Unit
%% Stats
y1 = Day.Mouse(mouse).Session.Events.ReinON.PETH_data(unit).PETH_all(start_time_idx:end_time_idx);
n1 = size(y1,1);
%% Plot it
figure('Name',['Reinforcement Onset Met vs Fail Z-score'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_peth size_h_peth])
hold on
set(gca, 'YLim', [0, 15]);
set(gca, 'XLim', [-2000, 3000]);
xticks([-2000 -1000 0 1000 2000 3000])
xticklabels({'-2', '-1', '0', '1', '2', '3'})

% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = LineWidth;
% n.Color = 'k';
% n.Color(4) = 0.8;


s = plot(plot_time, smoothdata(y1,2,'sgolay',smooth_win),'-b');
    set(s,'LineWidth',6,'LineStyle','-')
    set(s,'Color',blue)
    s.LineWidth = LineWidth_Z;


ylabel('Firing Rate')
% zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;


xlabel('Time from Event (s)')
title({'Reinforcement Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight

% h = zeros(1, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% legend(h,{'Met'}, 'Location', 'eastoutside');
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff





%% LP ON: Single Unit Quantile Split
%% Stats
% y1 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_1(start_time_idx:end_time_idx);
% y2 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_2(start_time_idx:end_time_idx);
% y3 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_3(start_time_idx:end_time_idx);
% y4 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_4(start_time_idx:end_time_idx);
y1 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_1_z(1:7001);
y2 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_2_z(1:7001);
y3 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_3_z(1:7001);
y4 = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).PETH_quant_4_z(1:7001);
%% Plot it

Lengths = Day.Mouse(mouse).Session.LP_Length; % seconds
edge_start = [0 0.25 0.50 0.75];
edge_end = [0.25 0.50 0.75 1];
Counts = [];
True_edges = zeros(4,2);
for quart = 1:4
    edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
    if quart == 1
        quart_lenghts = Lengths(Lengths >= edges(1) & Lengths <= edges(2));
    else
        quart_lenghts = Lengths(Lengths > edges(1) & Lengths <= edges(2));
    end
    True_edges(quart,:) = edges;
end
quant_1_idx = find(Lengths >= True_edges(1,1) & Lengths <= True_edges(1,2));
quant_1_duration = Lengths(quant_1_idx);
quant_2_idx = find(Lengths > True_edges(2,1) & Lengths <= True_edges(2,2));
quant_2_duration = Lengths(quant_2_idx);
quant_3_idx = find(Lengths > True_edges(3,1) & Lengths <= True_edges(3,2));
quant_3_duration = Lengths(quant_3_idx);
quant_4_idx = find(Lengths > True_edges(4,1) & Lengths <= True_edges(4,2));
quant_4_duration = Lengths(quant_4_idx);
mean_quant_1_line = mean(quant_1_duration)*1000;
mean_quant_2_line = mean(quant_2_duration)*1000;
mean_quant_3_line = mean(quant_3_duration)*1000;
mean_quant_4_line = mean(quant_4_duration)*1000;

figure('Name',['Lever Press Onset Quantile Z-score'],'NumberTitle','off','rend','painters','pos',[100 100 300 size_h_peth])
hold on
set(gca, 'YLim', [-3, 8]);%[ 0 15]
set(gca, 'XLim', [-2000, 5000]);

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

p = xline(Day.Mouse(mouse).Session.Criteria*1000,'-.');
p.LineWidth = 2;
p.Color = 'k';
p.Color(4) = 0.8;


p = xline(mean_quant_1_line,'-.');
p.LineWidth = 2;
p.Color = other_red;
p.Color(4) = 0.8;

p = xline(mean_quant_2_line,'-.');
p.LineWidth = 2;
p.Color = yellow;
p.Color(4) = 0.8;

p = xline(mean_quant_3_line,'-.');
p.LineWidth = 2;
p.Color = green;
p.Color(4) = 0.8;

p = xline(mean_quant_4_line,'-.');
p.LineWidth = 2;
p.Color = purple;
p.Color(4) = 0.8;




s = plot(plot_time, smoothdata(y1,2,'gaussian',1000),'-b');
    set(s,'LineWidth',6,'LineStyle','-')
    set(s,'Color',other_red)
    s.LineWidth = LineWidth_Z;

t = plot(plot_time, smoothdata(y2,2,'gaussian',1000),'-r');
    set(t,'LineWidth',6,'LineStyle','-')
    set(t,'Color',yellow)
    t.LineWidth = LineWidth_Z;
    
    
 l = plot(plot_time, smoothdata(y3,2,'gaussian',1000),'-g');
    set(l,'LineWidth',6,'LineStyle','-')
    set(l,'Color',green)
    l.LineWidth = LineWidth_Z;

y = plot(plot_time, smoothdata(y4,2,'gaussian',1000),'-m');
    set(y,'LineWidth',6,'LineStyle','-')
    set(y,'Color',purple)
    y.LineWidth = LineWidth_Z;

ylabel('Firing Rate')

% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
xlabel('Time from Event (ms)')
title({'Lever Press Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')

%axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'}, 'Location', 'eastoutside');
% set(h,'LineWidth',LineWidth_Legend);
% title(hleg, 'Quantile')
% legend boxoff
hold off


%% LP OFF: Single Unit  Quantile Split
%% Stats
y1 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_1(start_time_idx:end_time_idx);
y2 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_2(start_time_idx:end_time_idx);
y3 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_3(start_time_idx:end_time_idx);
y4 = Day.Mouse(mouse).Session.Events.LPOFF.PETH_data(unit).PETH_quant_4(start_time_idx:end_time_idx);
%% Plot it
figure('Name',['Lever Press Offset Quantile Z-score'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_peth size_h_peth])

hold on
set(gca, 'YLim', [0, 15]);
set(gca, 'XLim', [-2000, 5000]);

n = xline([Day.Mouse(mouse).Session.Criteria]);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = plot(plot_time, smoothdata(y1,2,'sgolay',smooth_win),'-b');
    set(s,'LineWidth',6,'LineStyle','-')
    set(s,'Color',blue)
    s.LineWidth = LineWidth_Z;

t = plot(plot_time, smoothdata(y2,2,'sgolay',smooth_win),'-r');
    set(t,'LineWidth',6,'LineStyle','-')
    set(t,'Color',red)
    t.LineWidth = LineWidth_Z;
    
    
 l = plot(plot_time, smoothdata(y3,2,'sgolay',smooth_win),'-g');
    set(l,'LineWidth',6,'LineStyle','-')
    set(l,'Color',green)
    l.LineWidth = LineWidth_Z;

y = plot(plot_time, smoothdata(y4,2,'sgolay',smooth_win),'-m');
    set(y,'LineWidth',6,'LineStyle','-')
    set(y,'Color',purple)
    y.LineWidth = LineWidth_Z;

ylabel('Firing Rate')
% zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Offset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'}, 'Location', 'eastoutside');
% title(hleg, 'Quantile')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off


%% Plot the Waveform of the Example Unit

wave = mean(Day.Mouse(mouse).Session.ValidWavesData{unit},2)';
wave_time =16.5:33.3:33.3*length(wave);
pp = interp1(wave_time,wave,'pchip','pp'); % shape-preserving fit
wave_time = 0:1:round(33.3*length(wave))+1; % 1/1000 ms resolution
mean_wave = ppval(pp,wave_time);

minData = min(mean_wave(:));
maxData = max(mean_wave(:));
scaled  = (mean_wave- minData) / (maxData - minData);

figure('Name',['Normalized Unit Waveform'],'NumberTitle','off','rend','painters','pos',[100 100 100 100])
hold on
title({'Mean Waveform'})
plot(wave_time,mean_wave,'DisplayName','Average Waveform','linewidth',4 )
hold off
xlabel('Time (uS)')
ylabel('Spike Amplitude (mV)')
%set(gca,'ytick',[])
set(gca,'FontSize',12)
set(gca, 'FontName', 'Arial')

%% Plot single session time series of events
session_start =  Day.Mouse(mouse).Session.StartStop(1);
session_end = Day.Mouse(mouse).Session.StartStop(2);
lever_press_timestamps = Day.Mouse(mouse).Session.Events.LPON.ts - Day.Mouse(mouse).Session.StartStop(1);
lever_press_off_timestamps = Day.Mouse(mouse).Session.Events.LPOFF.ts - Day.Mouse(mouse).Session.StartStop(1);
reinforcement_on_timestamps = Day.Mouse(mouse).Session.Events.ReinON.ts - Day.Mouse(mouse).Session.StartStop(1);
figure('Name',['Lever Press Durations During Session Example'],'NumberTitle','off','rend','painters','pos',[100 100 400 150])
hold on
s = yline([Day.Mouse(mouse).Session.Criteria]);
s.LineWidth = LineWidth;
s.Color = 'k';
s.Color(4) = 0.8;
for lever_press = 1:length(lever_press_timestamps)
    lever_press_duration = lever_press_off_timestamps(lever_press) - lever_press_timestamps(lever_press);
    if Day.Mouse(mouse).Session.LP_Length(lever_press)*1000 >= (Day.Mouse(mouse).Session.Criteria*1000)
        ha = area([lever_press_timestamps(lever_press) lever_press_off_timestamps(lever_press)], [0 0], 'FaceAlpha', 1, 'EdgeAlpha', 0, 'FaceColor', blue);
        he = area([lever_press_timestamps(lever_press) lever_press_off_timestamps(lever_press)], [lever_press_duration lever_press_duration], 'FaceAlpha', 1, 'EdgeAlpha', 0, 'FaceColor', blue);
    else
        ha = area([lever_press_timestamps(lever_press) lever_press_off_timestamps(lever_press)], [0 0], 'FaceAlpha', 1, 'EdgeAlpha', 0, 'FaceColor', red);
        he = area([lever_press_timestamps(lever_press) lever_press_off_timestamps(lever_press)], [lever_press_duration lever_press_duration], 'FaceAlpha', 1, 'EdgeAlpha', 0, 'FaceColor', red);
    end
    
end
%set ( gca, 'ydir', 'reverse' )
set(gca,'TickDir','out')
%xlim([0 300]) % first 5 minutes
%axis tight
xlabel('Time within Session (s)')
ylabel({'Total Duration (s)'})
title({'Performance'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [0.3 0.3 0.3]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off





%% Plot Met vs Fail Lever Press Length Distribution (from short to long)
figure('Name',['Lever Press Durations Sorted'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
hold on
s = xline([Day.Mouse(mouse).Session.Criteria*1000]);
s.LineWidth = LineWidth;
s.Color = 'k';
s.Color(4) = 0.8;
LPs = sort(Day.Mouse(mouse).Session.LP_Length);
for lever_press = 1:length(Day.Mouse(mouse).Session.LP_Length)
    %sorted_times = sort(Day.Mouse(7).Session.LP_Length, 'descend');

    if LPs(lever_press)*1000 >= (Day.Mouse(mouse).Session.Criteria*1000)
        t = plot([0 LPs(lever_press)*1000],[lever_press lever_press], '-b');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',blue)
        t.LineWidth = LineWidth_Behavior;
    else
        t = plot([0 LPs(lever_press)*1000],[lever_press lever_press], '-r');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',red)
        t.LineWidth = LineWidth_Behavior;
    end
    
end
set ( gca, 'ydir', 'reverse' )
set(gca,'TickDir','out')
yticks([100:100:400])
ylim([1 length(Day.Mouse(mouse).Session.LP_Length)+1])
xlim([0 3000])
xticks([0:1*1000:5*1000])
%axis tight
xlabel('Duration (ms)')
%ylabel({'Lever Press', '(in Order of Occurrence)'})
ylabel({'Lever Press'})
title({'Lever Press Durations','within a Session'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [0.3 0.3 0.3]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off





%% Plot Quantile Lever Press Length Distribution (from short to long)
%LPs = sort(Day.Mouse(mouse).Session.LP_Length);
Lengths = Day.Mouse(mouse).Session.LP_Length; % seconds
edge_start = [0 0.25 0.50 0.75];
edge_end = [0.25 0.50 0.75 1];
Counts = [];
True_edges = zeros(4,2);
for quart = 1:4
    edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
    if quart == 1
        quart_lenghts = Lengths(Lengths >= edges(1) & Lengths <= edges(2));
    else
        quart_lenghts = Lengths(Lengths > edges(1) & Lengths <= edges(2));
    end
    True_edges(quart,:) = edges;
end
quant_1_idx = find(Lengths >= True_edges(1,1) & Lengths <= True_edges(1,2));
quant_1_duration = Lengths(quant_1_idx);
quant_2_idx = find(Lengths > True_edges(2,1) & Lengths <= True_edges(2,2));
quant_2_duration = Lengths(quant_2_idx);
quant_3_idx = find(Lengths > True_edges(3,1) & Lengths <= True_edges(3,2));
quant_3_duration = Lengths(quant_3_idx);
quant_4_idx = find(Lengths > True_edges(4,1) & Lengths <= True_edges(4,2));
quant_4_duration = Lengths(quant_4_idx);



figure('Name',['Lever Press Durations Sorted Quantile'],'NumberTitle','off','rend','painters','pos',[100 100 size_w size_h])
hold on
s = xline([Day.Mouse(mouse).Session.Criteria*1000]);
s.LineWidth = LineWidth;
s.Color = 'k';
s.Color(4) = 0.8;

for lever_press = 1:length(Day.Mouse(mouse).Session.LP_Length)
    %sorted_times = sort(Day.Mouse(7).Session.LP_Length, 'descend');
    
    if any(lever_press == quant_1_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-b');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',other_red)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_2_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-r');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',yellow)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_3_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-g');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',green)
        t.LineWidth = LineWidth_Behavior;
    elseif any(lever_press == quant_4_idx)
        t = plot([0 Lengths(lever_press)*1000],[lever_press lever_press], '-m');
        set(t,'LineWidth',6,'LineStyle','-')
        set(t,'Color',purple)
        t.LineWidth = LineWidth_Behavior;
    end
    
end
set ( gca, 'ydir', 'reverse' )
set(gca,'TickDir','out')
yticks([100:100:400])
ylim([1 length(Day.Mouse(mouse).Session.LP_Length)+1])
xlim([0 3000])
xticks([0:1*1000:5*1000])
%axis tight
xlabel('Duration (ms)')
%ylabel({'Lever Press', '(in Order of Occurrence)'})
ylabel({'Lever Press'})
title({'Lever Press Durations','within a Session'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [0.3 0.3 0.3]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met', 'Fail'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
hold off



















%% Lever Press Onset
% Plot raster example segments
Spike_Times = struct2cell(Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial);
Spike_Times_Cell = cell(length(Spike_Times),1);
for trial = 1:length(Spike_Times)
    Spike_Times_Seconds = {Spike_Times{trial} / 1000};
    to_remove = find(((Spike_Times_Seconds{1} < -3) | (Spike_Times_Seconds{1} > 3)));
    Spike_Times_Seconds{1}(to_remove) = [];
    Spike_Times_Cell(trial) =  Spike_Times_Seconds;
end
[~,Bsort]=sort(Lengths); %Get the order of B
Sorted_Spike_Times_Cell = Spike_Times_Cell(Bsort);
%lever_presses_to_plot = [145 150 170 256 285 350 ];
lever_presses_to_plot = [150:350];
sorted_spikes = Bsort(lever_presses_to_plot);

sorted_timings_segments = [];
for lp = 1:length(sorted_spikes)
    segment_time = (Lengths(sorted_spikes(lp)) ./ 4);
    segment_1 = segment_time; % timestamps of segments
    segment_2 = [segment_1 + segment_time];
    segment_3 = [segment_2 + segment_time];
    segment_4 = [segment_3 + segment_time];
    sorted_timings_segments = [sorted_timings_segments  ; segment_1 segment_2 segment_3 segment_4];
end

figure('Name',['Lever Press Onset Segment Raster'],'NumberTitle','off','rend','painters','pos',[100 100 size_w_rast 400])
% n = xline([Day.Mouse(mouse).Session.Criteria]);
% n.LineWidth = 1;
% n.Color = 'k';
% n.Color(4) = 0.8;

MarkerFormat.Color = [.2 .2 .2];
MarkerFormat.MarkerSize = 10;
plotSpikeRaster(Sorted_Spike_Times_Cell(sorted_spikes),'PlotType','scatter', 'MarkerFormat',MarkerFormat,'XLimForCell',[0 3]);
title('Raster of Up-Modulated Unit');

% s = xline([0]);
% s.LineWidth = LineWidth;
% s.Color = 'k';
% s.Color(4) = 0.8;

hold on
count = 1;
for lever_press = 1:length(sorted_spikes)
    x_values = sorted_timings_segments(lever_press,:);
    t = plot([x_values],[count count count count], '.');
    set(t,'LineWidth',11,'LineStyle','none')
    set(t,'Color',blue)
    t.LineWidth = LineWidth_Raster;
    t.Color(4) = 0.95;
    count = count+1;
end
set ( gca, 'ydir', 'reverse' )
ylim([1 length(sorted_spikes)+1])
xlim([0 2])
yticks([0:50:200])
xticks([-3 -2 -1 0 1 2 3])
%ylabel({'Lever Press', '(Sorted by Duration)'})
ylabel({'Lever Press'})
xlabel('Time from Event (s)')
title({'Lever Press Onset'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', [[0.3 0.3 0.3]]);
% h(2) = plot(NaN,NaN,'-', 'Color', blue);
% h(3) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Criteria','Met Offset', 'Fail Offset'}, 'Location', 'eastoutside')
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
%axis tight
hold off
end

