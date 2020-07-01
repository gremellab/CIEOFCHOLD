function [] = plot_Z_PETH_Tx(Air, CIE)
% Z-Score PETH FRs and split between success and failures, Air VS CIE
% Plots successful vs failed lever presses
%% Figure properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 8;
LineWidth = 2;
LineWidth_Legend = 3;
size_w = 100;
size_h = 135;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
smooth_win = 400;
time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
start_time_idx = find(time == -2000);
end_time_idx = find(time == 3000);
pre_event_time_idx = find(time == -1000);
event_time_idx_onset = find(time == 100);
event_time_idx_offset_rein = find(time == -100);
post_event_time_idx = find(time == 1000);
criteria = Air.Mouse(1).Session.Criteria * 1000;
plot_time_onset = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(pre_event_time_idx:event_time_idx_onset);
plot_time_offset_rein = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(event_time_idx_offset_rein:post_event_time_idx);
norm_plot_time = linspace(0,100,length(Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_interp_all));
smooth_type = 'sgolay';

%% LP ON: All Units
n1 = size(Air.LPON_PETH_20_All_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_All_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_All_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_All_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers


[p,h,stats] = ranksum(mean_y1,mean_y2);
%% Plot it
figure('Name',['LP Onset: All Modulated: All Lever Presses'],'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;
% 
% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_onset(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF: All Units
n1 = size(Air.LPOFF_PETH_20_All_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_All_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_All_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_All_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: All Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])

xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% Rein ON: All Units
n1 = size(Air.Rein_ON_PETH_20_All_Mod_All_LPs,1);
n2 = size(CIE.Rein_ON_PETH_20_All_Mod_All_LPs,1);
%% Stats
y1_stats = Air.Rein_ON_PETH_20_All_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.Rein_ON_PETH_20_All_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.Rein_ON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.Rein_ON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Rein Onset: All Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])

xlabel('Time from Event (ms)')
title({'Reinforcement Onset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP ON: All Units Met
n1 = size(Air.LPON_PETH_20_All_Mod_Met_LPs,1);
n2 = size(CIE.LPON_PETH_20_All_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_All_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_All_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_All_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_All_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Onset: All Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_onset(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])

xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF: All Units Met
n1 = size(Air.LPOFF_PETH_20_All_Mod_Met_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_All_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_All_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_All_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_All_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_All_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: All Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])

xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff




%% LP ON:Up-modulated Units
n1 = size(Air.LPON_PETH_20_Up_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Up_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Up_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Up_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Onset: Up Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;


s = shadedErrorBar(plot_time_onset, smoothdata(y1,2,smooth_type,smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_onset,  smoothdata(y2,2,smooth_type,smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([0 2.5])
yticks([0 1 2])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP ON:Down-modulated Units
n1 = size(Air.LPON_PETH_20_Down_Mod_All_LPs,1);
n2 = size(CIE.LPON_PETH_20_Down_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Down_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Down_Mod_All_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Onset: Down Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])


hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')

%zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time_onset(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-3 0])
yticks([-3 -2 -1 0])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF:Up-modulated Units
n1 = size(Air.LPOFF_PETH_20_Up_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Up_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Up_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Up_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: Up Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([0 2.5])
yticks([0 1 2])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF:Down-modulated Units
n1 = size(Air.LPOFF_PETH_20_Down_Mod_All_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Down_Mod_All_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Down_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Down_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: Down Modulated: All Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([-3 0])
yticks([-3 -2 -1 0])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'All Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% Rein On:Up-modulated Units
n1 = size(Air.Rein_ON_PETH_20_Up_Mod_All_LPs,1);
n2 = size(CIE.Rein_ON_PETH_20_Up_Mod_All_LPs,1);
%% Stats
y1_stats = Air.Rein_ON_PETH_20_Up_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.Rein_ON_PETH_20_Up_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.Rein_ON_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.Rein_ON_PETH_20_Up_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Rein Onset: Up Modulated: Reinforced Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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


ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([0 8.5])
yticks([0 4 8])

xlabel('Time from Event (ms)')
title({'Reinforcement Onset:', 'Successful Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
%% Rein On:Down-modulated Units
n1 = size(Air.Rein_ON_PETH_20_Down_Mod_All_LPs,1);
n2 = size(CIE.Rein_ON_PETH_20_Down_Mod_All_LPs,1);
%% Stats
y1_stats = Air.Rein_ON_PETH_20_Down_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.Rein_ON_PETH_20_Down_Mod_All_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.Rein_ON_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.Rein_ON_PETH_20_Down_Mod_All_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Rein Onset: Down Modulated: Reinforced Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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


ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([-3 2])
yticks([-2 0 2])
xlabel('Time from Event (ms)')
title({'Reinforcement Onset:', 'Successful Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff
%% Met LPs only
%% LP ON:Up-modulated Units
n1 = size(Air.LPON_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(CIE.LPON_PETH_20_Up_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Up_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Up_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Onset: Up Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_onset(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([0 2.5])
yticks([0 1 2])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP ON:Down-modulated Units
n1 = size(Air.LPON_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(CIE.LPON_PETH_20_Down_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Down_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Down_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Onset: Down Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_onset(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([-3 0])
yticks([-3 -2 -1 0])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF:Up-modulated Units
n1 = size(Air.LPOFF_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Up_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Up_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Up_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: Up Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([0 4])
yticks([0 2 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% LP OFF:Down-modulated Units
n1 = size(Air.LPOFF_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Down_Mod_Met_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Down_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Down_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);
pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1_stats(:,k),y2_stats(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1_stats,2)) * (.05 / size(y2_stats,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['LP Offset: Down Modulated: Met Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
plot(plot_time_offset_rein(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,0,0])
ylim([-2 4.5])
yticks([-2 0 2 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff





















%% Air Met vs Fail: LP ON: Up Units
n1 = size(Air.LPON_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(Air.LPON_PETH_20_Up_Mod_Fail_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Up_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = Air.LPON_PETH_20_Up_Mod_Fail_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPON_PETH_20_Up_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);

pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Air: LP Onset: Up Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([0 4])
yticks([0 1 2 3 4])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% Air Met vs Fail: LP OFF: Up Units
n1 = size(Air.LPOFF_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(Air.LPOFF_PETH_20_Up_Mod_Fail_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Up_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = Air.LPOFF_PETH_20_Up_Mod_Fail_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPOFF_PETH_20_Up_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);


pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Air: LP Offset: Up Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([0 4])
yticks([0 1 2 3 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff







%% CIE Met vs Fail: LP ON: Up Units
n1 = size(CIE.LPON_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(CIE.LPON_PETH_20_Up_Mod_Fail_LPs,1);
%% Stats
y1_stats = CIE.LPON_PETH_20_Up_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Up_Mod_Fail_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(CIE.LPON_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Up_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);

pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['CIE: LP Onset: Up Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([0 4])
yticks([0 1 2 3 4])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% CIE Met vs Fail: LP OFF: Up Units
n1 = size(CIE.LPOFF_PETH_20_Up_Mod_Met_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Up_Mod_Fail_LPs,1);
%% Stats
y1_stats = CIE.LPOFF_PETH_20_Up_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Up_Mod_Fail_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(CIE.LPOFF_PETH_20_Up_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Up_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);


pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['CIE: LP Offset: Up Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([0 4])
yticks([0 1 2 3 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff








































%% Air Met vs Fail: LP ON: Down Units
n1 = size(Air.LPON_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(Air.LPON_PETH_20_Down_Mod_Fail_LPs,1);
%% Stats
y1_stats = Air.LPON_PETH_20_Down_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = Air.LPON_PETH_20_Down_Mod_Fail_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(Air.LPON_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPON_PETH_20_Down_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);

pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Air: LP Onset: Down Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-3 0])
yticks([-3 -2 -1 0])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% Air Met vs Fail: LP OFF: Up Units
n1 = size(Air.LPOFF_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(Air.LPOFF_PETH_20_Down_Mod_Fail_LPs,1);
%% Stats
y1_stats = Air.LPOFF_PETH_20_Down_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = Air.LPOFF_PETH_20_Down_Mod_Fail_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(Air.LPOFF_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(Air.LPOFF_PETH_20_Down_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);


pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['Air: LP Offset: Down Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-2.5 5])
yticks([-2 0 2 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff







%% CIE Met vs Fail: LP ON: Down Units
n1 = size(CIE.LPON_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(CIE.LPON_PETH_20_Down_Mod_Fail_LPs,1);
%% Stats
y1_stats = CIE.LPON_PETH_20_Down_Mod_Met_LPs(:,pre_event_time_idx:event_time_idx_onset);
y2_stats = CIE.LPON_PETH_20_Down_Mod_Fail_LPs(:,pre_event_time_idx:event_time_idx_onset);
y1_smooth = smoothdata(CIE.LPON_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPON_PETH_20_Down_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,pre_event_time_idx:event_time_idx_onset);
y2 = y2_smooth(:,pre_event_time_idx:event_time_idx_onset);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);

pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['CIE: LP Onset: Down Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;

% p = xline(Air.Mouse(1).Session.Criteria*1000,'-.');
% p.LineWidth = 2;
% p.Color = 'k';
% p.Color(4) = 0.8;

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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-3 0])
yticks([-3 -2 -1 0])
xlabel('Time from Event (ms)')
title({'Lever Press Onset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff

%% CIE Met vs Fail: LP OFF: Down Units
n1 = size(CIE.LPOFF_PETH_20_Down_Mod_Met_LPs,1);
n2 = size(CIE.LPOFF_PETH_20_Down_Mod_Fail_LPs,1);
%% Stats
y1_stats = CIE.LPOFF_PETH_20_Down_Mod_Met_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y2_stats = CIE.LPOFF_PETH_20_Down_Mod_Fail_LPs(:,event_time_idx_offset_rein:post_event_time_idx);
y1_smooth = smoothdata(CIE.LPOFF_PETH_20_Down_Mod_Met_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y2_smooth = smoothdata(CIE.LPOFF_PETH_20_Down_Mod_Fail_LPs(:,start_time_idx:end_time_idx),2,smooth_type,smooth_win);
y1 = y1_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
y2 = y2_smooth(:,event_time_idx_offset_rein:post_event_time_idx);
mean_y1 = mean(y1_stats);
mean_y2 = mean(y2_stats);


pvals = [];
for k =1:size(y1,2)
    [p,h,stats] = ranksum(y1(:,k),y2(:,k));
    pvals = [pvals; p];
end
%uncorrected = ones(1,size(y1,2)) * .05;
corrected = (ones(1,size(y1,2)) * (.05 / size(y1,2)))';
sig_times_idx = find(pvals<=corrected);
%sig_times_idx = find(pvals<=.05);
% p=find(diff(sig_times_idx)==1)
% q=[p;p+1];
% sig_times_idx(q)  % this gives all the pairs of consecutive numbers
%% Plot it
figure('Name',['CIE: LP Offset: Down Modulated: Met vs Fail Lever Presses'],'NumberTitle','off','rend','painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria/20], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria/20], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% lim = caxis;
% Stat line
% plot(plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-2.5 5])
yticks([-2 0 2 4])
xlabel('Time from Event (ms)')
title({'Lever Press Offset:', 'Criteria Met vs Fail Lever Presses'})
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff


end

