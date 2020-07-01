function [] = primePlot(Air,CIE)
%% Figure Properties
set(0,'defaultfigurecolor',[1 1 1])
FontSize = 10;
LineWidth = 2;
LineWidth_Legend = 3;
size_w = 350;
size_h = 350;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
purple = [0.4940, 0.1840, 0.5560];
smooth_win = 20;
time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
time_LPON_1 = find(time == -1000);
time_LPON_2 = find(time == 100);
time_LPOFF_1 = find(time == -100);
time_LPOFF_2 = find(time == 1000);
bin_w = 10;
smooth_type = 'sgolay';
plot_time_offset = time(time_LPOFF_1:time_LPOFF_2);
plot_time_onset = time(time_LPON_1:time_LPON_2);
%% Pre LP Onset After Success Success vs After Success Failure
titles = {'Lever Press Onset:', 'After Success'};
figNames = 'All Units: All Units: After Success Success vs After Success Failure';
y1 = Air.D.PreLP_After_Success_Success_vs_After_Success_Failure;
y2 = CIE.D.PreLP_After_Success_Success_vs_After_Success_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff



%% Post LP Offset After Success Success vs After Success Failure
titles = {'Lever Press Offset:', 'After Success'};
figNames = 'All Units: All Units: After Success Success vs After Success Failure';
y1 = Air.D.PostLP_After_Success_Success_vs_After_Success_Failure;
y2 = CIE.D.PostLP_After_Success_Success_vs_After_Success_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff




%% Pre LP Onset After Failure Success vs After Failure Failure
titles = {'Lever Press Onset:', 'After Failure'};
figNames = 'All Units: All Units: After Failure Success vs After Failure Failure';
y1 = Air.D.PreLP_After_Failure_Success_vs_After_Failure_Failure;
y2 = CIE.D.PreLP_After_Failure_Success_vs_After_Failure_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff


%% Post LP Offset After Failure Success vs After Failure Failure
titles = {'Lever Press Offset:', 'After Failure'};
figNames = 'All Units: All Units: After Failure Success vs After Failure Failure';
y1 = Air.D.PostLP_After_Failure_Success_vs_After_Failure_Failure;
y2 = CIE.D.PostLP_After_Failure_Success_vs_After_Failure_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]); 
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff






























%% Pre LP Onset Before Success Success vs After Success Failure
titles = {'Lever Press Onset:', 'Before Success'};
figNames = 'All Units: All Units: Before Success Success vs Before Success Failure';
y1 = Air.D.PreLP_Before_Success_Success_vs_Before_Success_Failure;
y2 = CIE.D.PreLP_Before_Success_Success_vs_Before_Success_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff



%% Post LP Offset Before Success Success vs Before Success Failure
titles = {'Lever Press Offset:', 'Before Success'};
figNames = 'All Units: All Units: Before Success Success vs Before Success Failure';
y1 = Air.D.PostLP_Before_Success_Success_vs_Before_Success_Failure;
y2 = CIE.D.PostLP_Before_Success_Success_vs_Before_Success_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff




%% Pre LP Onset Before Failure Success vs Before Failure Failure
titles = {'Lever Press Onset:', 'Before Failure'};
figNames = 'All Units: All Units: Before Failure Success vs Before Failure Failure';
y1 = Air.D.PreLP_Before_Failure_Success_vs_Before_Failure_Failure;
y2 = CIE.D.PreLP_Before_Failure_Success_vs_Before_Failure_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
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

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff


%% Post LP Offset Before Failure Success vs Before Failure Failure
titles = {'Lever Press Offset:', 'Before Failure'};
figNames = 'All Units: All Units: Before Failure Success vs Before Failure Failure';
y1 = Air.D.PostLP_Before_Failure_Success_vs_Before_Failure_Failure;
y2 = CIE.D.PostLP_Before_Failure_Success_vs_Before_Failure_Failure;
n1 = size(y1,1);
n2 = size(y2,1);

figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(plot_time_offset,  y2, {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]); 
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Air', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff































%% Pre LP Onset Before Success Success vs After Success Failure
titles = {'Lever Press Onset:', 'Before Success'};
figNames = 'All Units: All Units: Before Success Success vs Before Success Failure';
y1 = [Air.D.PreLP_Before_Success_Success_vs_Before_Success_Failure; CIE.D.PreLP_Before_Success_Success_vs_Before_Success_Failure];
n1 = size(y1,1);


figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',purple)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = purple;


ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Air', 'CIE'})
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff



%% Post LP Offset Before Success Success vs Before Success Failure
titles = {'Lever Press Offset:', 'Before Success'};
figNames = 'All Units: All Units: Before Success Success vs Before Success Failure';
y1 = [Air.D.PostLP_Before_Success_Success_vs_Before_Success_Failure; CIE.D.PostLP_Before_Success_Success_vs_Before_Success_Failure];

n1 = size(y1,1);


figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',purple)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = purple;


ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Air', 'CIE'})
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff




%% Pre LP Onset Before Failure Success vs Before Failure Failure
titles = {'Lever Press Onset:', 'Before Failure'};
figNames = 'All Units: All Units: Before Failure Success vs Before Failure Failure';
y1 = [Air.D.PreLP_Before_Failure_Success_vs_Before_Failure_Failure; CIE.D.PreLP_Before_Failure_Success_vs_Before_Failure_Failure];

n1 = size(y1,1);


figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_onset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',purple)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = purple;


ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]);
xlim([-1000 100]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Air', 'CIE'})
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff


%% Post LP Offset Before Failure Success vs Before Failure Failure
titles = {'Lever Press Offset:', 'Before Failure'};
figNames = 'All Units: All Units: Before Failure Success vs Before Failure Failure';
y1 = [Air.D.PostLP_Before_Failure_Success_vs_Before_Failure_Failure; CIE.D.PostLP_Before_Failure_Success_vs_Before_Failure_Failure];
n1 = size(y1,1);


figure('Name', figNames ,'NumberTitle','off','rend', 'painters','Visible','on','pos',[100 100 size_w size_h])
hold on

n = xline(0);
n.LineWidth = LineWidth;
n.Color = 'k';
n.Color(4) = 0.8;


s = shadedErrorBar(plot_time_offset, y1, {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color', purple)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = purple;


ylabel('dPrime', 'FontWeight','bold')
ylim([0 3]); 
xlim([-100 1000]);

xlabel('Time from Event (ms)')
title(titles)
set(gca,'FontSize', FontSize)
set(gca, 'FontName', 'Arial')
% axis tight
% h = zeros(2, 1);
% h(1) = plot(NaN,NaN,'-', 'Color', blue);
% h(2) = plot(NaN,NaN,'-', 'Color', red);
% legend(h,{'Air', 'CIE'})
% set(h,'LineWidth',LineWidth_Legend);
% legend boxoff
end

