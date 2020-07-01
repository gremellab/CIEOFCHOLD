
%% Up Units Min 1 Spike
Duration = [Air.Durations.Duration_Up_Units_Spike_LPs.Duration; CIE.Durations.Duration_Up_Units_Spike_LPs.Duration];
Proportion_1 = [Air.Durations.Duration_Up_Units_Spike_LPs.segment_1_Proportion; CIE.Durations.Duration_Up_Units_Spike_LPs.segment_1_Proportion];
Proportion_2 = [Air.Durations.Duration_Up_Units_Spike_LPs.segment_2_Proportion; CIE.Durations.Duration_Up_Units_Spike_LPs.segment_2_Proportion];
Proportion_3 = [Air.Durations.Duration_Up_Units_Spike_LPs.segment_3_Proportion; CIE.Durations.Duration_Up_Units_Spike_LPs.segment_3_Proportion];
Proportion_4 = [Air.Durations.Duration_Up_Units_Spike_LPs.segment_4_Proportion; CIE.Durations.Duration_Up_Units_Spike_LPs.segment_4_Proportion];
Label = [ones(size(Air.Durations.Duration_Up_Units_Spike_LPs.Duration)); ones(size(CIE.Durations.Duration_Up_Units_Spike_LPs.Duration))*2];  

tables = table(Duration, Proportion_1, Label);

figure;
scatterhist(tables.Duration, tables.Proportion_1,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_2,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_3,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_4,'Group', tables.Label,'Kernel','on')

%% Down Units Min 1 Spike
Duration = [Air.Durations.Duration_Down_Units_Spike_LPs.Duration; CIE.Durations.Duration_Down_Units_Spike_LPs.Duration];
Proportion_1 = [Air.Durations.Duration_Down_Units_Spike_LPs.segment_1_Proportion; CIE.Durations.Duration_Down_Units_Spike_LPs.segment_1_Proportion];
Proportion_2 = [Air.Durations.Duration_Down_Units_Spike_LPs.segment_2_Proportion; CIE.Durations.Duration_Down_Units_Spike_LPs.segment_2_Proportion];
Proportion_3 = [Air.Durations.Duration_Down_Units_Spike_LPs.segment_3_Proportion; CIE.Durations.Duration_Down_Units_Spike_LPs.segment_3_Proportion];
Proportion_4 = [Air.Durations.Duration_Down_Units_Spike_LPs.segment_4_Proportion; CIE.Durations.Duration_Down_Units_Spike_LPs.segment_4_Proportion];
Label = [ones(size(Air.Durations.Duration_Down_Units_Spike_LPs.Duration)); ones(size(CIE.Durations.Duration_Down_Units_Spike_LPs.Duration))*2];  

tables = table(Duration, Proportion_1, Proportion_2, Proportion_3, Proportion_4, Label);

figure;
scatterhist(tables.Duration, tables.Proportion_1,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_2,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_3,'Group', tables.Label,'Kernel','on')
figure;
scatterhist(tables.Duration, tables.Proportion_4,'Group', tables.Label,'Kernel','on')


figure;
s = scatterhistogram(tables,'Duration','Proportion_3','GroupVariable','Label', ...
    'NumBins',10,'LineWidth',1.5,'ScatterPlotLocation','NorthEast','LegendVisible','on','HistogramDisplayStyle','smooth', ...
    'LineStyle','-');


%% Hold Z (min 1 spike)
labels = {'Air', 'CIE'};
A(1) = {Air.Durations.Duration_All_Units_Spike_LPs.HoldRate_Z};
A(2) = {CIE.Durations.Duration_All_Units_Spike_LPs.HoldRate_Z};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',50, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})


A(1) = {Air.Durations.Duration_Up_Units_Spike_LPs.HoldRate_Z};
A(2) = {CIE.Durations.Duration_Up_Units_Spike_LPs.HoldRate_Z};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',50, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})


A(1) = {Air.Durations.Duration_Down_Units_Spike_LPs.HoldRate_Z};
A(2) = {CIE.Durations.Duration_Down_Units_Spike_LPs.HoldRate_Z};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',50, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})

%% Proportion (min 1 spike)
A(1) = {Air.Durations.Duration_All_Units_Spike_LPs.segment_1_Proportion};
A(2) = {CIE.Durations.Duration_All_Units_Spike_LPs.segment_1_Proportion};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',10, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})


A(1) = {Air.Durations.Duration_Up_Units_Spike_LPs.segment_1_Proportion};
A(2) = {CIE.Durations.Duration_Up_Units_Spike_LPs.segment_1_Proportion};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',10, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})

A(1) = {Air.Durations.Duration_Down_Units_Spike_LPs.segment_1_Proportion};
A(2) = {CIE.Durations.Duration_Down_Units_Spike_LPs.segment_1_Proportion};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',10, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})


A(1) = {Air.Durations.Duration_All_Units_Spike_LPs.segment_2_Proportion};
A(2) = {CIE.Durations.Duration_All_Units_Spike_LPs.segment_2_Proportion};
figure;
nhist(A,'color',[.3 .8 .3],'samebins','maxbins',10, 'pdf', 'mean', 'legend', labels)
[h, p] = kstest2(A{1},A{2})

%% Air: Z vs Quantile: All Units
set(0,'defaultfigurecolor',[1 1 1])
Duration = Air.Durations.Duration_All_Units_All_LPs.Duration;
Hold_Z = Air.Durations.Duration_All_Units_All_LPs.HoldRate_Z;
Label = Air.Durations.Duration_All_Units_All_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: All Units: All LPs')

Duration = Air.Durations.Duration_All_Units_Spike_LPs.Duration;
Hold_Z = Air.Durations.Duration_All_Units_Spike_LPs.HoldRate_Z;
Label = Air.Durations.Duration_All_Units_Spike_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: All Units: Min 1 Spike')



%% Air: Z vs Quantile: Up Units
set(0,'defaultfigurecolor',[1 1 1])
Duration = Air.Durations.Duration_Up_Units_All_LPs.Duration;
Hold_Z = Air.Durations.Duration_Up_Units_All_LPs.HoldRate_Z;
Label = Air.Durations.Duration_Up_Units_All_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: Up Units: All LPs')

Duration = Air.Durations.Duration_Up_Units_Spike_LPs.Duration;
Hold_Z = Air.Durations.Duration_Up_Units_Spike_LPs.HoldRate_Z;
Label = Air.Durations.Duration_Up_Units_Spike_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: Up Units: Min 1 Spike')

%% Air: Z vs Quantile: Down Units
set(0,'defaultfigurecolor',[1 1 1])
Duration = Air.Durations.Duration_Down_Units_All_LPs.Duration;
Hold_Z = Air.Durations.Duration_Down_Units_All_LPs.HoldRate_Z;
Label = Air.Durations.Duration_Down_Units_All_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: Down Units: All LPs')

Duration = Air.Durations.Duration_Down_Units_Spike_LPs.Duration;
Hold_Z = Air.Durations.Duration_Down_Units_Spike_LPs.HoldRate_Z;
Label = Air.Durations.Duration_Down_Units_Spike_LPs.QuantID;  
tables = table(Duration, Hold_Z, Label);
figure;
scatterhist(tables.Duration, tables.Hold_Z,'Group', tables.Label,'Kernel','on')
ylabel('Z-Score FR')
xlabel('Duration (s)')
title('Air: Down Units: Min 1 Spike')