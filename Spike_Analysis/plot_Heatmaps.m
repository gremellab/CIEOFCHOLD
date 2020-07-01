function [] = plot_Heatmaps(Air,CIE)
%% Heatmaps
%% Figure Properties
set(0,'defaultfigurecolor',[1 1 1])
Labels = {CIE.Mouse(1).Session.Events.LPON.Event_Label, CIE.Mouse(1).Session.Events.LPOFF.Event_Label, CIE.Mouse(1).Session.Events.ReinON.Event_Label};
time = CIE.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
start_time_idx = find(time == -2000);
end_time_idx = find(time == 3000);
zero_time_idx = find(time == 0);
mid_time_idx = find(time == 3000);
xtick_idx = [find(time == -2000) find(time == -1000) find(time == 0) find(time == 1000) find(time == 2000) find(time == 3000)];

heat_size_w = 160;
heat_size_h = 280;
FontSize = 10;

% xticks_values = [start_time_idx zero_time_idx mid_time_idx end_time_idx];
% xtick_labels = {'-2000', '0', '2000', '5000'};
xticks_values = xtick_idx;
xtick_labels = {'-2', '-1', '0', '1', '2', '3'};
sort_start = find(time == -1000); % sorted by -2000 to 4000 ms PETH activity
sort_end =  find(time == 1000); % sorted by -2000 to 4000 ms PETH activity
sort_end_rein =  find(time == 3000);
heat_sort_start = 5;
heat_sort_end = 1;
%% LP Onset Non-sig All Units
y1 = Air.LPON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);
y2 = CIE.LPON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);

combined = [y1];
combined_perievent = [y1(:,sort_start:sort_end)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(heat_sort_start:end-heat_sort_end), :);  % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_air = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_air = flipud(data_air);

combined = [y2];
combined_perievent = [y2(:,sort_start:sort_end)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(heat_sort_start:end-heat_sort_end), :); % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_cie = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_cie = flipud(data_cie);

figure('Name',['Heatmap Air vs CIE All Units: ' Labels{1}],'NumberTitle','off','rend','painters','pos',[100 100 heat_size_w heat_size_h])
ax1 = subplot(211);
hold on
imagesc(data_air)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
% colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
title(Labels{1})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlabel(['Time from Event Onset (ms)'])
set(gca,'TickDir','out')
hold off

ax2 = subplot(212);
hold on
imagesc(data_cie)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%title(Labels{1})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlim([-2000 3000])
axis tight
xlabel(['Time from Event Onset (s)'])
set(gca,'TickDir','out')
hold off
linkaxes([ax1,ax2],'xy')
%% LP Offset Non-sig All Units
y1 = Air.LPOFF_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);
y2 = CIE.LPOFF_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);

combined = [y1];
combined_perievent = [y1(:,sort_start:sort_end)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(heat_sort_start:end-heat_sort_end), :);  % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_air = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_air = flipud(data_air);

combined = [y2];
combined_perievent = [y2(:,sort_start:sort_end)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(heat_sort_start:end-heat_sort_end), :); % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_cie = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_cie = flipud(data_cie);

figure('Name',['Heatmap Air vs CIE All Units: ' Labels{2}],'NumberTitle','off','rend','painters','pos',[100 100 heat_size_w heat_size_h])
ax1 = subplot(211);
hold on
imagesc(data_air)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
title(Labels{2})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlabel(['Time from Event Onset (ms)'])
set(gca,'TickDir','out')
hold off

ax2 = subplot(212);
hold on
imagesc(data_cie)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
% colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%title(Labels{2})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlim([-2000 3000])
%axis tight
xlabel(['Time from Event Onset (s)'])
set(gca,'TickDir','out')
hold off
linkaxes([ax1,ax2],'xy')


%% Reinforcement Onset set Non-sig All Units
y1 = Air.Rein_ON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);
y2 = CIE.Rein_ON_PETH_20_All_Mod_All_LPs(:,start_time_idx:end_time_idx);

combined = [y1];
combined_perievent = [y1(:,sort_start:sort_end_rein)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(10:end-heat_sort_end), :);  % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_air = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_air = flipud(data_air);

combined = [y2];
combined_perievent = [y2(:,sort_start:sort_end_rein)]; % sorted by -200 to 200 PETH activity
combined_max = max(combined_perievent, [], 2);
[~, combined_idx] = sort(combined_max, 'descend');
sorted   = combined(combined_idx(10:end-heat_sort_end), :); % remove greatest and lowest values to avoid heatmap washout
% Scale the data to between -1 and +1.
minValue = min(min(sorted(:,sort_start:sort_end)));
maxValue = max(max(sorted(:,sort_start:sort_end)));
data_cie = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
data_cie = flipud(data_cie);

figure('Name',['Heatmap Air vs CIE All Units: ' Labels{3}],'NumberTitle','off','rend','painters','pos',[100 100 heat_size_w heat_size_h])
ax1 = subplot(211);
hold on
imagesc(data_air)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
title(Labels{3})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlabel(['Time from Event Onset (ms)'])
set(gca,'TickDir','out')
hold off

ax2 = subplot(212);
hold on
imagesc(data_cie)
axis tight
% ax = gca;
% ax.CLim = [-.5 .5];
% c = colorbar;
% c.Label.String = 'Normalized FR';
% %c.Label.VerticalAlignment = 'bottom';
% set(c,'YTick',[-.5 .5])
% set(c,'TickLabels',{'< -.5', '> .5'})
colormap('viridis')
set(gca,'FontSize',FontSize)
set(gca, 'FontName', 'Arial')
%title(Labels{3})
ylabel('Unit')
xticks(xticks_values)
xticklabels(xtick_labels)
%xlim([-2000 3000])
axis tight
xlabel(['Time from Event Onset (s)'])
set(gca,'TickDir','out')
hold off
linkaxes([ax1,ax2],'xy')
%%
% %% LP Onset All
% y1 = Air.LPON.PETH_Matrix_All_Up(:,201:351);
% y2 = CIE.LPON.PETH_Matrix_All_Up(:,201:351);
% y3 = Air.LPON.PETH_Matrix_All_Down(:,201:351);
% y4 = CIE.LPON.PETH_Matrix_All_Down(:,201:351);
% Labels = {Air.Mouse(1).Session.Events.LPON.Event_Label, Air.Mouse(1).Session.Events.LPOFF.Event_Label, Air.Mouse(1).Session.Events.ReinON.Event_Label};
% 
% figure('Name',['Heatmap Air: ' Labels{1}],'NumberTitle','off','rend','painters','pos',[10 10 heat_size_w heat_size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y1 ; y3];
% combined_perievent = [y1(:,41:71) ; y3(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :);  % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{1})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{1} ' (ms)'])
% 
% figure('Name',['Heatmap CIE: ' Labels{1}],'NumberTitle','off','rend','painters','pos',[10 10 size_w size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y2 ; y4];
% combined_perievent = [y2(:,41:71) ; y4(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :); % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{1})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{1} ' (ms)'])
% %% LP Offset All
% y1 = Air.LPOFF.PETH_Matrix_All_Up(:,201:351);
% y2 = CIE.LPOFF.PETH_Matrix_All_Up(:,201:351);
% y3 = Air.LPOFF.PETH_Matrix_All_Down(:,201:351);
% y4 = CIE.LPOFF.PETH_Matrix_All_Down(:,201:351);
% 
% figure('Name',['Heatmap Air: ' Labels{2}],'NumberTitle','off','rend','painters','pos',[10 10 heat_size_w heat_size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y1 ; y3];
% combined_perievent = [y1(:,41:71) ; y3(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :); % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{2})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{2} ' (ms)'])
% 
% figure('Name',['Heatmap CIE: ' Labels{2}],'NumberTitle','off','rend','painters','pos',[10 10 heat_size_w heat_size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y2 ; y4];
% combined_perievent = [y2(:,41:71) ; y4(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :);  % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{2})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{2} ' (ms)'])
% 
% %% Reinforcement Onset All
% y1 = Air.ReinON.PETH_Matrix_All_Up(:,201:351);
% y2 = CIE.ReinON.PETH_Matrix_All_Up(:,201:351);
% y3 = Air.ReinON.PETH_Matrix_All_Down(:,201:351);
% y4 = CIE.ReinON.PETH_Matrix_All_Down(:,201:351);
% 
% figure('Name',['Heatmap Air: ' Labels{3}],'NumberTitle','off','rend','painters','pos',[10 10 heat_size_w heat_size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y1 ; y3];
% combined_perievent = [y1(:,41:71) ; y3(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :); % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{3})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{3} ' (ms)'])
% 
% figure('Name',['Heatmap CIE: ' Labels{3}],'NumberTitle','off','rend','painters','pos',[10 10 heat_size_w heat_size_h])
% %[~, idx] = sort(y1,'descend');
% %imagesc(y1(:, idx))
% % max_up = max(y1, [], 2);
% % max_down = max(y3, [], 2);
% % [~, sort_up] = sort(max_up, 'descend');
% % [~, sort_down] = sort(max_down, 'descend');
% combined = [y2 ; y4];
% combined_perievent = [y2(:,41:71) ; y4(:,41:71)]; % sorted by -200 to 200 PETH activity
% combined_max = max(combined_perievent, [], 2);
% [~, combined_idx] = sort(combined_max, 'descend');
% sorted   = combined(combined_idx(5:end-5), :);  % remove greatest and lowest values to avoid heatmap washout
% % Scale the data to between -1 and +1.
% minValue = min(sorted(:));
% maxValue = max(sorted(:));
% data = (sorted-minValue) * 2 / (maxValue - minValue) - 1;
% imagesc(data)
% ylabel('Unit')
% c = colorbar;
% c.Label.String = 'Normalized FR';
% set(c,'YTick',[-1 1])
% colormap('viridis')
% set(gca,'FontSize',FontSize)
% set(gca, 'FontName', 'Arial')
% title(Labels{3})
% xticks([1 51 101 151])
% xticklabels({'-1000','0', '1000', '2000'})
% axis tight
% xlabel(['Time from ' Labels{3} ' (ms)'])
% 
% 
% %% LP ON:All Units Normalized Time

end

