function [] = plot_Z_Interp_Tx(Air, CIE)
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
smooth_win = 5;
time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
start_time_idx = find(time == -2000);
end_time_idx = find(time == 3000);
criteria = Air.Mouse(1).Session.Criteria * 1000;
plot_time = Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time(start_time_idx:end_time_idx);
norm_plot_time = linspace(0,100,length(Air.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_interp_all));
ylimstart = -3;
ylimend = 2;
%% LP ON All Units Interpolated Time
n1 = size(Air.PETH_Interp_All_Mod_All_LPs,1);
n2 = size(CIE.PETH_Interp_All_Mod_All_LPs,1);
%% Stats
y1 = Air.PETH_Interp_All_Mod_All_LPs;
y2 = CIE.PETH_Interp_All_Mod_All_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: All'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

%% LP ON: Up Units Normalized Time
n1 = size(Air.PETH_Interp_Up_Mod_All_LPs,1);
n2 = size(CIE.PETH_Interp_Up_Mod_All_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Up_Mod_All_LPs;
y2 = CIE.PETH_Interp_Up_Mod_All_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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

figure('Name',['Normalized LP Onset: All Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-0.5 3.5])
yticks([0 1 2 3])
xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

%% LP ON: Down Units Normalized Time
n1 = size(Air.PETH_Interp_Down_Mod_All_LPs,1);
n2 = size(CIE.PETH_Interp_Down_Mod_All_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Down_Mod_All_LPs;
y2 = CIE.PETH_Interp_Down_Mod_All_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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

figure('Name',['Normalized LP Onset: All Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-4 -1.25])
yticks([-4 -3 -2])
xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'All Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);


%% LP ON: All Units Normalized Time MET
n1 = size(Air.PETH_Interp_All_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_All_Mod_Met_LPs,1);
%% Stats
y1 = Air.PETH_Interp_All_Mod_Met_LPs;
y2 = CIE.PETH_Interp_All_Mod_Met_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Met All'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

%% LP ON: Up Units Normalized Time MET
n1 = size(Air.PETH_Interp_Up_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_Up_Mod_Met_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Up_Mod_Met_LPs;
y2 = CIE.PETH_Interp_Up_Mod_Met_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Met Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-0.5 3.5])
yticks([0 1 2 3])
xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);


%% LP ON: Down Units Normalized Time MET
n1 = size(Air.PETH_Interp_Down_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_Down_Mod_Met_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Down_Mod_Met_LPs;
y2 = CIE.PETH_Interp_Down_Mod_Met_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Met Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% % Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])
ylim([-4 -1.25])
yticks([-4 -3 -2])
xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met Lever Presses'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Control', 'CIE'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);


%% LP ON: Air Units Normalized Time MET vs FAIL ALL UNITS
n1 = size(Air.PETH_Interp_All_Mod_Met_LPs,1);
n2 = size(Air.PETH_Interp_All_Mod_Fail_LPs,1);
%% Stats
y1 = Air.PETH_Interp_All_Mod_Met_LPs;
y2 = Air.PETH_Interp_All_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Air Met vs Fail All'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);




%% LP ON: Air Units Normalized Time MET vs FAIL UP UNITS
n1 = size(Air.PETH_Interp_Up_Mod_Met_LPs,1);
n2 = size(Air.PETH_Interp_Up_Mod_Fail_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Up_Mod_Met_LPs;
y2 = Air.PETH_Interp_Up_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Air Met vs Fail Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

%% LP ON: Air Units Normalized Time MET vs FAIL Down UNITS
n1 = size(Air.PETH_Interp_Down_Mod_Met_LPs,1);
n2 = size(Air.PETH_Interp_Down_Mod_Fail_LPs,1);
%% Stats
y1 = Air.PETH_Interp_Down_Mod_Met_LPs;
y2 = Air.PETH_Interp_Down_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: Air Met vs Fail Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);



%% LP ON: CIE Units Normalized Time MET vs FAIL ALL UNITS
n1 = size(CIE.PETH_Interp_All_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_All_Mod_Fail_LPs,1);
%% Stats
y1 = CIE.PETH_Interp_All_Mod_Met_LPs;
y2 = CIE.PETH_Interp_All_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: CIE Met vs Fail All'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);




%% LP ON: CIE Units Normalized Time MET vs FAIL UP UNITS
n1 = size(CIE.PETH_Interp_Up_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_Up_Mod_Fail_LPs,1);
%% Stats
y1 = CIE.PETH_Interp_Up_Mod_Met_LPs;
y2 = CIE.PETH_Interp_Up_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: CIE Met vs Fail Up'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on
s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

%% LP ON: CIE Units Normalized Time MET vs FAIL Down UNITS
n1 = size(CIE.PETH_Interp_Down_Mod_Met_LPs,1);
n2 = size(CIE.PETH_Interp_Down_Mod_Fail_LPs,1);
%% Stats
y1 = CIE.PETH_Interp_Down_Mod_Met_LPs;
y2 = CIE.PETH_Interp_Down_Mod_Fail_LPs;
mean_y1 = mean(y1);
mean_y2 = mean(y2);
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
figure('Name',['Normalized LP Onset: CIE Met vs Fail Down'],'NumberTitle','off','rend','painters','Visible','on','pos',[10 10 size_w size_h])
hold on



s = shadedErrorBar(norm_plot_time, smoothdata(y1,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n1)}, 'lineprops', '-b', 'transparent',1);
set(s.edge,'LineWidth',6,'LineStyle','none')
set(s.mainLine,'Color',blue)
s.mainLine.LineWidth = LineWidth;
s.patch.FaceColor = blue;

t = shadedErrorBar(norm_plot_time,  smoothdata(y2,2,'sgolay',smooth_win), {@mean, @(x) std(x) / sqrt(n2)}, 'lineprops', '-r', 'transparent',1);
set(t.edge,'LineWidth',6,'LineStyle','none')
set(t.mainLine,'Color',red)
t.mainLine.LineWidth = LineWidth;
t.patch.FaceColor = red;

ylabel('Firing Rate (Z)', 'FontWeight','bold')
zl = ylim;
% ha = area([0 criteria], [zl(1) zl(1)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
% he = area([0 criteria], [zl(2) zl(2)], 'FaceAlpha', 0.20, 'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
%lim = caxis;
% Stat line
% plot(norm_plot_time(sig_times_idx),ones(length(sig_times_idx))*zl(1),'ks','MarkerSize',12,'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0,0,0])

xlabel('Lever Press Duration (%)')
title({'Lever Press Onset:', 'Criteria Met vs Fail'})
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
axis tight
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-', 'Color', blue);
h(2) = plot(NaN,NaN,'-', 'Color', red);
legend(h,{'Met', 'Fail'})
set(h,'LineWidth',LineWidth_Legend);
legend boxoff; %ylim([ylimstart ylimend]);

end

