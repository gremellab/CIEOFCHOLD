%% Process data per recording session by treatment group
%% 0800 Late
Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\0800-Late\0800-Late-Air\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Air\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Air\';
Criteria = .8; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)

Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\0800-Late\0800-Late-Eth\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Eth\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Eth\';
Criteria = .8; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)

%% 1600 Early
Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\1600-Early\1600-Early-Air\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Air\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Air\';
Criteria = 1.6; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)

Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\1600-Early\1600-Early-Eth\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Eth\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Eth\';
Criteria = 1.6; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)

%% Merge processed recording session data by treatment group
%% 0800 Early
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Air\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late';
Day_File_Name = 'Exp35-0800-Late-Air';
Treatment_Group = 'Air';
[Air] = combineSessions(Session_Directory);
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');

Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late\New_0800_Late_Eth\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\0800-Late';
Day_File_Name = 'Exp35-0800-Late-Eth';
Treatment_Group = 'CIE';
[CIE] = combineSessions(Session_Directory);
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');
%% 1600 Early
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Air\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early';
Day_File_Name = 'Exp35-1600-Early-Air';
Treatment_Group = 'Air';
[Air] = combineSessions(Session_Directory);
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');

Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\New_1600_Early_Eth\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early';
Day_File_Name = 'Exp35-1600-Early-Eth';
Treatment_Group = 'CIE';
[CIE] = combineSessions(Session_Directory);
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');







%% 1600 Late
Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\1600-Late\1600-Late-Air\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Air\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Air\';
Criteria = 1.6; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)
clear all

Nex_Directory = 'I:\Christian\Auto_Sorted_Units_Exp35_CIE_Hold\T-Dist E-M Manual\1600-Late\1600-Late-Eth\';
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Eth\';
Processed_Session_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Eth\';
Criteria = 1.6; %in seconds
Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory);
Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)
clear all

%% 1600 Late
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Air\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late';
Day_File_Name = 'Exp35-1600-Late-Air';
Treatment_Group = 'Air';
[Air] = combineSessions(Session_Directory);
[Air.Ratios] = Cazares_Unit_Ratios_Pie(Air);
[Air.Mod_Values] = modulation_values(Air);
[Air.Regression] = makeTable(Air); %%%%
[Air.Prime] = findSigChangePerformance_dPrime(Air.Regression.Perform_LPs);
[Air.D] = plotPerformanceUnits(Air); %includes prime calculation, where you smooth D prime
[Air.OutcomeHistory] = outcomeHistory(Air);
[Air.Durations] = makeTableDuration(Air);

save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');

Air.Mouse(2:end) = [];
Day_File_Name = 'Exp35-1600-Late-Air-Population';
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');

clear all
Session_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late\1600-Late-Eth\';
Merged_Day_Destination_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Late';
Day_File_Name = 'Exp35-1600-Late-Eth';
Treatment_Group = 'CIE';
[CIE] = combineSessions(Session_Directory);
[CIE.Ratios] = Cazares_Unit_Ratios_Pie(CIE);
[CIE.Mod_Values] = modulation_values(CIE);
[CIE.Regression] = makeTable(CIE);
[CIE.Prime] = findSigChangePerformance_dPrime(CIE.Regression.Perform_LPs); %%
[CIE.D] = plotPerformanceUnits(CIE); %includes prime calculation, where you smooth D prime
[CIE.OutcomeHistory] = outcomeHistory(CIE);
[CIE.Durations] = makeTableDuration(CIE);

save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');

CIE.Mouse(2:end) = [];
Day_File_Name = 'Exp35-1600-Late-Eth-Population';
save([Merged_Day_Destination_Directory '\' Day_File_Name], Treatment_Group, '-v7.3');
%% Plots
% Plot Treatment Comparisons: 20 ms PETH
Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Paper Code\Plots\1600_Late_1ms';
EPS_Directory = 'C:\Users\cacazare\Dropbox\Plots\Paper';
plot_Z_PETH_Tx(Air, CIE)
SaveAllFigures(Directory, EPS_Directory)
close all
% Plot Treatment Comparisons: Interpolated Duration Histograms
plot_Z_Interp_Tx(Air, CIE)
SaveAllFigures(Directory, EPS_Directory)
close all
% Plot Treatment Comparisons: Quantile Duration Split 20 ms PETH
plot_Z_Quantile_Tx(Air, CIE)
SaveAllFigures(Directory, EPS_Directory)
close all
% Plot Heatmap of all Units: 20 ms PETH
plot_Heatmaps(Air,CIE)
SaveAllFigures(Directory, EPS_Directory)
close all
% Plot Single Session
% Example Neuron From CIE Late, Animal 2, Unit 2 FOR PAPER, CIE, mouse =
% 15, Unit = 19; For Air, mouse 12, unit 19
mouse = 15;
unit = 19; % 1 good onset, 18 good offset and reward % 5 may be good for all

% mouse = 12;
% unit = 20; % This Mouse only UP before Onset, no REIN or OFF

Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\';
EPS_Directory = 'C:\Users\cacazare\Dropbox\Plots\Paper';
plot_SingleSession(mouse, unit, CIE)
plot_SingleSession(mouse, unit, Air)
SaveAllFigures(Directory, EPS_Directory)
close all



% %% Peak and Bars
% [Air.Mod_Values] = modulation_values(Air);
% [CIE.Mod_Values] = modulation_values(CIE);

%% History

[Air.Regression] = makeTable(Air);
[Air.Prime] = findSigChangePerformance_dPrime(Air.Regression.Perform_LPs);
[Air.D] = plotPerformanceUnits(Air);
primePlot(Air,CIE);


%% Decoder
Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\';
EPS_Directory = 'C:\Users\cacazare\Dropbox\Plots\Paper';

% Early 1600 LP ON All Units
Decoder_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Decoder_Results\LP_ON_1600_Late';
Shuffled_Decoder_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Decoder_Results\LP_ON_1600_Late_Shuff';
Plot_Decoder_Results()
Plot_Decoder_Results_Shuff(Decoder_Directory, Shuffled_Decoder_Directory)

% Late 1600 LP OFF All Units
Decoder_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Decoder_Results\LP_OFF_1600_Late';
Shuffled_Decoder_Directory = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Decoder_Results\LP_OFF_1600_Late_Shuff';
Plot_Decoder_Results()
Plot_Decoder_Results_Shuff(Decoder_Directory, Shuffled_Decoder_Directory)

SaveAllFigures(Directory, EPS_Directory)
close all

% binned decoder results
% -1 to 0 
% index: 11:20

% 0 to 1
% index: 21:31
