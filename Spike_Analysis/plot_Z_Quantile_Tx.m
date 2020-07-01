function [] = plot_Z_Quantile_Tx(Air, CIE)
% Z-Score PETH FRs and split between lever press duration quantiles, Air VS CIE
%% Figure properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 8;
LineWidth = 2;
LineWidth_Legend = 3;
size_w = 100;
size_h = 135;
%blue = [0, 0.4470, 0.7410];
%red = [0.8500, 0.3250, 0.0980];
blue = [0.6350, 0.0780, 0.1840]; % red
red = [0.9290, 0.6940, 0.1250]; % yellow
green = [0.4660, 0.6740, 0.1880];
purple = [0.4940, 0.1840, 0.5560];
smooth_win = 400;
smooth_win_interp = 5;
time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
start_time_idx = find(time == -2000);
end_time_idx = find(time == 3000);
pre_event_time_idx = find(time == -1000);
event_time_idx_onset = find(time == 100);
event_time_idx_offset_rein = find(time == -100);
post_event_time_idx = find(time == 1000);
criteria = Air.Mouse(1).Session.Criteria * 1000;
plot_time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(start_time_idx:end_time_idx);
plot_time_onset = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(pre_event_time_idx:event_time_idx_onset);
plot_time_offset_rein = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(event_time_idx_offset_rein:post_event_time_idx);
norm_plot_time = linspace(0,100,length(Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_interp_all));
smooth_type = 'sgolay';
%% Air: LP ON All Units Quantile Time
n1 = size(Air.LPON_PETH_20_Quant_1_All_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_All_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_All_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_All_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPON_PETH_20_Quant_1_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPON_PETH_20_Quant_2_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPON_PETH_20_Quant_3_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPON_PETH_20_Quant_4_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth (:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth (:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth (:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth (:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['Air: Quantile LP Onset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset,  y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset,  y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON All Units Quantile Time
n1 = size(CIE.LPON_PETH_20_Quant_1_All_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_All_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_All_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_All_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPON_PETH_20_Quant_1_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Quant_2_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPON_PETH_20_Quant_3_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPON_PETH_20_Quant_4_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth (:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth (:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth (:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth (:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['CIE: Quantile LP Onset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')



%% Air: LP ON Up Units Quantile Time
n1 = size(Air.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_Up_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_Up_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_Up_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPON_PETH_20_Quant_1_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPON_PETH_20_Quant_2_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPON_PETH_20_Quant_3_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPON_PETH_20_Quant_4_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth(:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth(:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['Air: Quantile LP Onset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON Up Units Quantile Time
n1 = size(CIE.LPON_PETH_20_Quant_1_Up_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_Up_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_Up_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_Up_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPON_PETH_20_Quant_1_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Quant_2_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPON_PETH_20_Quant_3_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPON_PETH_20_Quant_4_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth(:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth(:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['CIE: Quantile LP Onset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')

%% Air: LP ON Down Units Quantile Time
n1 = size(Air.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_Down_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_Down_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_Down_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPON_PETH_20_Quant_1_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPON_PETH_20_Quant_2_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPON_PETH_20_Quant_3_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPON_PETH_20_Quant_4_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth(:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth(:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['Air: Quantile LP Onset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON Down Units Quantile Time
n1 = size(CIE.LPON_PETH_20_Quant_1_Down_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_Down_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_Down_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_Down_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPON_PETH_20_Quant_1_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Quant_2_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPON_PETH_20_Quant_3_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPON_PETH_20_Quant_4_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
y3 = y3_smooth(:,pre_event_time_idx:event_time_idx_onset);
y4 = y4_smooth(:,pre_event_time_idx:event_time_idx_onset);
%% Plot it
figure('Name',['CIE: Quantile LP Onset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_onset, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_onset, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')



%% Air: LP OFF All Units Quantile Time
n1 = size(Air.LPOFF_PETH_20_Quant_1_All_Mod_All_LPs,1);
n2 = size(Air.LPOFF_PETH_20_Quant_2_All_Mod_All_LPs,1);
n3 = size(Air.LPOFF_PETH_20_Quant_3_All_Mod_All_LPs,1);
n4 = size(Air.LPOFF_PETH_20_Quant_4_All_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_1_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_2_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_3_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_4_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['Air: Quantile LP Offset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein,  y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein,  y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP OFF All Units Quantile Time
n1 = size(CIE.LPOFF_PETH_20_Quant_1_All_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Quant_2_All_Mod_All_LPs,1);
n3 = size(CIE.LPOFF_PETH_20_Quant_3_All_Mod_All_LPs,1);
n4 = size(CIE.LPOFF_PETH_20_Quant_4_All_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_1_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_2_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_3_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_4_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['CIE: Quantile LP Offset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')



%% Air: LP OFF Up Units Quantile Time
n1 = size(Air.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1);
n2 = size(Air.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs,1);
n3 = size(Air.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs,1);
n4 = size(Air.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['Air: Quantile LP Offset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
ylim([-0.5 3])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
%% CIE: LP OFF Up Units Quantile Time
n1 = size(CIE.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs,1);
n3 = size(CIE.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs,1);
n4 = size(CIE.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['CIE: Quantile LP Offset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
ylim([-0.5 3])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')

%% Air: LP OFF Down Units Quantile Time
n1 = size(Air.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1);
n2 = size(Air.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs,1);
n3 = size(Air.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs,1);
n4 = size(Air.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(Air.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['Air: Quantile LP Offset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
ylim([-2.5 1])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
%% CIE: LP OFF Down Units Quantile Time
n1 = size(CIE.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs,1);
n3 = size(CIE.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs,1);
n4 = size(CIE.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs,1);
%% Stats
y1_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y3_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y4_smooth = smoothdata(CIE.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y3 = y3_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y4 = y4_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
%% Plot it
figure('Name',['CIE: Quantile LP Offset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

s = shadedErrorBar(plot_time_offset_rein, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset_rein, y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time_offset_rein, y3, {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time_offset_rein, y4, {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
ylim([-2.5 1])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')

%% Air: LP ON All Units Quantile Time Interp
plot_time = norm_plot_time;
n1 = size(Air.LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs,1);
%% Stats
y1 = Air.LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
y2 = Air.LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
y3 = Air.LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
y4 = Air.LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
%% Plot it
figure('Name',['Air: Quantile Interp LP Onset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON All Units Quantile Time Interp
n1 = size(CIE.LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs,1);
%% Stats
y1 = CIE.LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
y2 = CIE.LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
y3 = CIE.LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
y4 = CIE.LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
%% Plot it
figure('Name',['CIE: Quantile Interp LP Onset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')



%% Air: LP ON Up Units Quantile Time Interp
n1 = size(Air.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs,1);
%% Stats
y1 = Air.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
y2 = Air.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
y3 = Air.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
y4 = Air.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
%% Plot it
figure('Name',['Air: Quantile Interp LP Onset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;
ylim([-0.5 3.5])
yticks([0 1 2 3])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON Up Units Quantile Time Interp
n1 = size(CIE.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs,1);
%% Stats
y1 = CIE.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
y2 = CIE.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
y3 = CIE.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
y4 = CIE.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
%% Plot it
figure('Name',['CIE: Quantile Interp LP Onset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;
ylim([-0.5 3.5])
yticks([0 1 2 3])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')

%% Air: LP ON Down Units Quantile Time Interp
n1 = size(Air.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1);
n2 = size(Air.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs,1);
n3 = size(Air.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs,1);
n4 = size(Air.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs,1);
%% Stats
y1 = Air.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
y2 = Air.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
y3 = Air.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
y4 = Air.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
%% Plot it
figure('Name',['Air: Quantile Interp LP Onset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;
ylim([-4 -1.25])
yticks([-4 -3 -2])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
%set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')
%% CIE: LP ON Down Units Quantile Time Interp
n1 = size(CIE.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs,1);
n3 = size(CIE.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs,1);
n4 = size(CIE.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs,1);
%% Stats
y1 = CIE.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
y2 = CIE.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
y3 = CIE.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
y4 = CIE.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
%% Plot it
figure('Name',['CIE: Quantile Interp LP Onset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on
s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
set(l.edge,'LineWidth',6,'LineStyle','none')
set(l.mainLine,'Color',green)
l.mainLine.LineWidth = LineWidth;
l.patch.FaceColor = green;

y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win_interp), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
set(y.edge,'LineWidth',6,'LineStyle','none')
set(y.mainLine,'Color',purple)
y.mainLine.LineWidth = LineWidth;
y.patch.FaceColor = purple;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
%ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
lim = caxis;
ylim([-4 -1.25])
yticks([-4 -3 -2])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
h(3) = plot(NaN,NaN,'-', 'Color', green);
h(4) = plot(NaN,NaN,'-', 'Color', purple);
hleg = legend(h,{'1', '2', '3', '4'});
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
title(hleg, 'Quantile')



% %% Air: LP OFF All Units Quantile Time
% n1 = size(Air.LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs,1);
% n2 = size(Air.LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs,1);
% n3 = size(Air.LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs,1);
% n4 = size(Air.LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs,1);
% %% Stats
% y1 = Air.LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
% y2 = Air.LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
% y3 = Air.LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
% y4 = Air.LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
% %% Plot it
% figure('Name',['Air: Quantile Interp LP Offset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
% %% CIE: LP ON All Units Quantile Time
% n1 = size(CIE.LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs,1);
% n2 = size(CIE.LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs,1);
% n3 = size(CIE.LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs,1);
% n4 = size(CIE.LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs,1);
% %% Stats
% y1 = CIE.LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
% y2 = CIE.LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
% y3 = CIE.LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
% y4 = CIE.LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
% %% Plot it
% figure('Name',['CIE: Quantile Interp LP Offset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
% 
% 
% 
% %% Air: LP ON Up Units Quantile Time
% n1 = size(Air.LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1);
% n2 = size(Air.LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs,1);
% n3 = size(Air.LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs,1);
% n4 = size(Air.LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs,1);
% %% Stats
% y1 = Air.LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
% y2 = Air.LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
% y3 = Air.LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
% y4 = Air.LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
% %% Plot it
% figure('Name',['Air: Quantile Interp LP Offset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
% %% CIE: LP OFF Up Units Quantile Time
% n1 = size(CIE.LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs,1);
% n2 = size(CIE.LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs,1);
% n3 = size(CIE.LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs,1);
% n4 = size(CIE.LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs,1);
% %% Stats
% y1 = CIE.LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
% y2 = CIE.LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
% y3 = CIE.LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
% y4 = CIE.LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
% %% Plot it
% figure('Name',['CIE: Quantile Interp LP Offset: Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
% 
% %% Air: LP ON Down Units Quantile Time
% n1 = size(Air.LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1);
% n2 = size(Air.LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs,1);
% n3 = size(Air.LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs,1);
% n4 = size(Air.LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs,1);
% %% Stats
% y1 = Air.LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
% y2 = Air.LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
% y3 = Air.LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
% y4 = Air.LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
% %% Plot it
% figure('Name',['Air: Quantile Interp LP Offset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
% %% CIE: LP ON Down Units Quantile Time
% n1 = size(CIE.LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs,1);
% n2 = size(CIE.LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs,1);
% n3 = size(CIE.LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs,1);
% n4 = size(CIE.LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs,1);
% %% Stats
% y1 = CIE.LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
% y2 = CIE.LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
% y3 = CIE.LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
% y4 = CIE.LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
% %% Plot it
% figure('Name',['CIE: Quantile Interp LP Offset: Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
% hold on
% s = shadedErrorBar(plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
% set(s.edge,'LineWidth',6,'LineStyle','none')
% set(s.mainLine,'Color',blue)
% s.mainLine.LineWidth = LineWidth;
% s.patch.FaceColor = blue;
% 
% t = shadedErrorBar(plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
% set(t.edge,'LineWidth',6,'LineStyle','none')
% set(t.mainLine,'Color',red)
% t.mainLine.LineWidth = LineWidth;
% t.patch.FaceColor = red;
% 
% l = shadedErrorBar(plot_time,  smoothdata(y3,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n3)}, 'lineprops', '-g', 'transparent',1);
% set(l.edge,'LineWidth',6,'LineStyle','none')
% set(l.mainLine,'Color',green)
% l.mainLine.LineWidth = LineWidth;
% l.patch.FaceColor = green;
% 
% y = shadedErrorBar(plot_time,  smoothdata(y4,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n4)}, 'lineprops', '-m', 'transparent',1);
% set(y.edge,'LineWidth',6,'LineStyle','none')
% set(y.mainLine,'Color',purple)
% y.mainLine.LineWidth = LineWidth;
% y.patch.FaceColor = purple;
% 
% ylabel('Firing Rate (Z)', 'FontWeight','bold')
% zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% 
% xlabel('Time from Event (ms)')
% title({'Lever Press Offset:', 'All Lever Presses'})
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(4, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% h(3) = plot(NaN,NaN,'-', 'Color', green);
% h(4) = plot(NaN,NaN,'-', 'Color', purple);
% hleg = legend(h,{'1', '2', '3', '4'});
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
% title(hleg, 'Quantile')
end

