function [Day] = combineSessions(Session_Directory)
%Combine Session Recording File data into a data structure grouped by
%treatment group

%% Temporary Matrices
% LP ON 20 ms Bins
LPON_PETH_20_All_Mod_All_LPs = [];
LPON_PETH_20_All_Mod_Met_LPs = [];
LPON_PETH_20_All_Mod_Fail_LPs = [];
LPON_PETH_20_Up_Mod_All_LPs = [];
LPON_PETH_20_Up_Mod_Met_LPs = [];
LPON_PETH_20_Up_Mod_Fail_LPs = [];
LPON_PETH_20_Down_Mod_All_LPs = [];
LPON_PETH_20_Down_Mod_Met_LPs = [];
LPON_PETH_20_Down_Mod_Fail_LPs = [];
% LP OFF 20 ms Bins
LPOFF_PETH_20_All_Mod_All_LPs = [];
LPOFF_PETH_20_All_Mod_Met_LPs = [];
LPOFF_PETH_20_All_Mod_Fail_LPs = [];
LPOFF_PETH_20_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Up_Mod_Met_LPs = [];
LPOFF_PETH_20_Up_Mod_Fail_LPs = [];
LPOFF_PETH_20_Down_Mod_All_LPs = [];
LPOFF_PETH_20_Down_Mod_Met_LPs = [];
LPOFF_PETH_20_Down_Mod_Fail_LPs = [];
% Rein ON 20 ms Bins
Rein_ON_PETH_20_All_Mod_All_LPs = [];
Rein_ON_PETH_20_Up_Mod_All_LPs = [];
Rein_ON_PETH_20_Down_Mod_All_LPs = [];
% LP ON 20 ms Bins Quantiles
LPON_PETH_20_Quant_1_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_1_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_1_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_2_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_2_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_2_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_3_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_3_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_3_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_4_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_4_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_4_Down_Mod_All_LPs = [];
% LP ON 20 ms Bins Quantiles
LPOFF_PETH_20_Quant_1_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_2_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_3_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_4_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs = [];

% LP ON interpolated duration histogram
PETH_Interp_All_Mod_All_LPs = [];
PETH_Interp_All_Mod_Met_LPs = [];
PETH_Interp_All_Mod_Fail_LPs = [];
PETH_Interp_Up_Mod_All_LPs = [];
PETH_Interp_Up_Mod_Met_LPs = [];
PETH_Interp_Up_Mod_Fail_LPs = [];
PETH_Interp_Down_Mod_All_LPs = [];
PETH_Interp_Down_Mod_Met_LPs = [];
PETH_Interp_Down_Mod_Fail_LPs = [];

% LP ON 20 ms Bins Quantiles
LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = [];

LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs = [];
LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = [];
LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = [];
% LP ON 20 ms Bins Quantiles
LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = [];

LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = [];
LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = [];
%% Load each individual Session file
cd(Session_Directory)
listing = dir(Session_Directory);
SessionFiles = listing(3:end);
SessionFiles = {SessionFiles.name};
for mouse = 1:size(SessionFiles ,2) % For each mouse (i.e. Session file
    Day.Mouse(mouse) = load(SessionFiles{mouse}); % Load file into treatment-grouped structure
    SessionFiles{mouse}
    %% Time 
    %Time = Day.Mouse(mouse).Session.Events.LPON.PETH_data(1).PETH_Z_Scored_FR_time;
    %% Find Indices of Significantly Modulated Units by Type and event (e.g. Up or Down)
    LP_ON_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}))]);
    LP_ON_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}))]);
    LP_OFF_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Up_Mod_Window}))]);
    LP_OFF_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Down_Mod_Window}))]);
    Rein_ON_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Up_Mod_Window}))]);
    Rein_ON_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Down_Mod_Window}))]); 
    %% 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_all_z}');
    Met_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_met_z}');
    Fail_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_fail_z}');
    % All Significant Modulated Units
    LPON_PETH_20_All_Mod_All_LPs = [LPON_PETH_20_All_Mod_All_LPs; All_LPs];
    LPON_PETH_20_All_Mod_Met_LPs = [LPON_PETH_20_All_Mod_Met_LPs; Met_LPs];
    LPON_PETH_20_All_Mod_Fail_LPs = [LPON_PETH_20_All_Mod_Fail_LPs; Fail_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Up_Mod_All_LPs = [LPON_PETH_20_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    LPON_PETH_20_Up_Mod_Met_LPs = [LPON_PETH_20_Up_Mod_Met_LPs; Met_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    LPON_PETH_20_Up_Mod_Fail_LPs = [LPON_PETH_20_Up_Mod_Fail_LPs; Fail_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Down_Mod_All_LPs = [LPON_PETH_20_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    LPON_PETH_20_Down_Mod_Met_LPs = [LPON_PETH_20_Down_Mod_Met_LPs; Met_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    LPON_PETH_20_Down_Mod_Fail_LPs = [LPON_PETH_20_Down_Mod_Fail_LPs; Fail_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% 20 ms Binned Z-scored PETHs (Lever Press Offset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_all_z}');
    Met_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_met_z}');
    Fail_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_fail_z}');
    % All Significant Modulated Units
    LPOFF_PETH_20_All_Mod_All_LPs = [LPOFF_PETH_20_All_Mod_All_LPs; All_LPs];
    LPOFF_PETH_20_All_Mod_Met_LPs = [LPOFF_PETH_20_All_Mod_Met_LPs; Met_LPs];
    LPOFF_PETH_20_All_Mod_Fail_LPs = [LPOFF_PETH_20_All_Mod_Fail_LPs; Fail_LPs];
    % Significantly Up-Modulated Units
    LPOFF_PETH_20_Up_Mod_All_LPs = [LPOFF_PETH_20_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    LPOFF_PETH_20_Up_Mod_Met_LPs = [LPOFF_PETH_20_Up_Mod_Met_LPs; Met_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    LPOFF_PETH_20_Up_Mod_Fail_LPs = [LPOFF_PETH_20_Up_Mod_Fail_LPs; Fail_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPOFF_PETH_20_Down_Mod_All_LPs = [LPOFF_PETH_20_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    LPOFF_PETH_20_Down_Mod_Met_LPs = [LPOFF_PETH_20_Down_Mod_Met_LPs; Met_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    LPOFF_PETH_20_Down_Mod_Fail_LPs = [LPOFF_PETH_20_Down_Mod_Fail_LPs; Fail_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    %% 20 ms Binned Z-scored PETHs (Reinforcement Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.ReinON.PETH_data.PETH_all_z}');
    % All Significant Modulated Units
    Rein_ON_PETH_20_All_Mod_All_LPs = [Rein_ON_PETH_20_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    Rein_ON_PETH_20_Up_Mod_All_LPs = [Rein_ON_PETH_20_Up_Mod_All_LPs; All_LPs(Rein_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    Rein_ON_PETH_20_Down_Mod_All_LPs = [Rein_ON_PETH_20_Down_Mod_All_LPs; All_LPs(Rein_ON_Down_Sig_Units_Idx,:)];
    %% Interpolated Duration Histograms
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_interp_all_z}');
    Met_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_interp_met_z}');
    Fail_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_interp_fail_z}');
    % All Significant Modulated Units
    PETH_Interp_All_Mod_All_LPs = [PETH_Interp_All_Mod_All_LPs; All_LPs];
    PETH_Interp_All_Mod_Met_LPs = [PETH_Interp_All_Mod_Met_LPs; Met_LPs];
    PETH_Interp_All_Mod_Fail_LPs = [PETH_Interp_All_Mod_Fail_LPs; Fail_LPs];
    % Significantly Up-Modulated Units
    PETH_Interp_Up_Mod_All_LPs = [PETH_Interp_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    PETH_Interp_Up_Mod_Met_LPs = [PETH_Interp_Up_Mod_Met_LPs; Met_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    PETH_Interp_Up_Mod_Fail_LPs = [PETH_Interp_Up_Mod_Fail_LPs; Fail_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    PETH_Interp_Down_Mod_All_LPs = [PETH_Interp_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    PETH_Interp_Down_Mod_Met_LPs = [PETH_Interp_Down_Mod_Met_LPs; Met_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    PETH_Interp_Down_Mod_Fail_LPs = [PETH_Interp_Down_Mod_Fail_LPs; Fail_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 1: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_1_z}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_1_All_Mod_All_LPs = [LPON_PETH_20_Quant_1_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_1_Up_Mod_All_LPs = [LPON_PETH_20_Quant_1_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_1_Down_Mod_All_LPs = [LPON_PETH_20_Quant_1_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 2: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_2_z}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_2_All_Mod_All_LPs = [LPON_PETH_20_Quant_2_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_2_Up_Mod_All_LPs = [LPON_PETH_20_Quant_2_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_2_Down_Mod_All_LPs = [LPON_PETH_20_Quant_2_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 3: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_3_z}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_3_All_Mod_All_LPs = [LPON_PETH_20_Quant_3_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_3_Up_Mod_All_LPs = [LPON_PETH_20_Quant_3_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_3_Down_Mod_All_LPs = [LPON_PETH_20_Quant_3_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 4: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_4_z}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_4_All_Mod_All_LPs = [LPON_PETH_20_Quant_4_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_4_Up_Mod_All_LPs = [LPON_PETH_20_Quant_4_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_4_Down_Mod_All_LPs = [LPON_PETH_20_Quant_4_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 1: 20 ms Binned Z-scored PETHs (Lever Press Offset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_1_z}');
    % All Significant Modulated Units
    LPOFF_PETH_20_Quant_1_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    %% Quantile 2: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_2_z}');
    % All Significant Modulated Units
    LPOFF_PETH_20_Quant_2_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    %% Quantile 3: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_3_z}');
    % All Significant Modulated Units
    LPOFF_PETH_20_Quant_3_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    %% Quantile 4: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_4_z}');
    % All Significant Modulated Units
    LPOFF_PETH_20_Quant_4_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
    %% Interpolated
    %% Quantile 1: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_1_z_interp}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs = [LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = [LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = [LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 2: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_2_z_interp}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs = [LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = [LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = [LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 3: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_3_z_interp}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs = [LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = [LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = [LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
    %% Quantile 4: 20 ms Binned Z-scored PETHs (Lever Press Onset)
    All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPON.PETH_data.PETH_quant_4_z_interp}');
    % All Significant Modulated Units
    LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs = [LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs; All_LPs];
    % Significantly Up-Modulated Units
    LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = [LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs; All_LPs(LP_ON_Up_Sig_Units_Idx,:)];
    % Significantly Down-Modulated Units
    LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = [LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs; All_LPs(LP_ON_Down_Sig_Units_Idx,:)];
%     %% Quantile 1: 20 ms Binned Z-scored PETHs (Lever Press Offset)
%     All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_1_z_interp}');
%     % All Significant Modulated Units
%     LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs; All_LPs];
%     % Significantly Up-Modulated Units
%     LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
%     % Significantly Down-Modulated Units
%     LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
%     %% Quantile 2: 20 ms Binned Z-scored PETHs (Lever Press Onset)
%     All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_2_z_interp}');
%     % All Significant Modulated Units
%     LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs; All_LPs];
%     % Significantly Up-Modulated Units
%     LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
%     % Significantly Down-Modulated Units
%     LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
%     %% Quantile 3: 20 ms Binned Z-scored PETHs (Lever Press Onset)
%     All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_3_z_interp}');
%     % All Significant Modulated Units
%     LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs; All_LPs];
%     % Significantly Up-Modulated Units
%     LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
%     % Significantly Down-Modulated Units
%     LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
%     %% Quantile 4: 20 ms Binned Z-scored PETHs (Lever Press Onset)
%     All_LPs = cell2mat({Day.Mouse(mouse).Session.Events.LPOFF.PETH_data.PETH_quant_4_z_interp}');
%     % All Significant Modulated Units
%     LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs; All_LPs];
%     % Significantly Up-Modulated Units
%     LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs; All_LPs(LP_OFF_Up_Sig_Units_Idx,:)];
%     % Significantly Down-Modulated Units
%     LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = [LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs; All_LPs(LP_OFF_Down_Sig_Units_Idx,:)];
end
%% Add population data to treatment-grouped structure
% LP ON 20 ms Bins
Day.LPON_PETH_20_All_Mod_All_LPs = LPON_PETH_20_All_Mod_All_LPs;
Day.LPON_PETH_20_All_Mod_Met_LPs = LPON_PETH_20_All_Mod_Met_LPs;
Day.LPON_PETH_20_All_Mod_Fail_LPs = LPON_PETH_20_All_Mod_Fail_LPs;
Day.LPON_PETH_20_Up_Mod_All_LPs = LPON_PETH_20_Up_Mod_All_LPs;
Day.LPON_PETH_20_Up_Mod_Met_LPs = LPON_PETH_20_Up_Mod_Met_LPs;
Day.LPON_PETH_20_Up_Mod_Fail_LPs = LPON_PETH_20_Up_Mod_Fail_LPs;
Day.LPON_PETH_20_Down_Mod_All_LPs = LPON_PETH_20_Down_Mod_All_LPs;
Day.LPON_PETH_20_Down_Mod_Met_LPs = LPON_PETH_20_Down_Mod_Met_LPs;
Day.LPON_PETH_20_Down_Mod_Fail_LPs = LPON_PETH_20_Down_Mod_Fail_LPs;
% LP OFF 20 ms Bins
Day.LPOFF_PETH_20_All_Mod_All_LPs = LPOFF_PETH_20_All_Mod_All_LPs;
Day.LPOFF_PETH_20_All_Mod_Met_LPs = LPOFF_PETH_20_All_Mod_Met_LPs;
Day.LPOFF_PETH_20_All_Mod_Fail_LPs = LPOFF_PETH_20_All_Mod_Fail_LPs;
Day.LPOFF_PETH_20_Up_Mod_All_LPs = LPOFF_PETH_20_Up_Mod_All_LPs;
Day.LPOFF_PETH_20_Up_Mod_Met_LPs = LPOFF_PETH_20_Up_Mod_Met_LPs;
Day.LPOFF_PETH_20_Up_Mod_Fail_LPs = LPOFF_PETH_20_Up_Mod_Fail_LPs;
Day.LPOFF_PETH_20_Down_Mod_All_LPs = LPOFF_PETH_20_Down_Mod_All_LPs;
Day.LPOFF_PETH_20_Down_Mod_Met_LPs = LPOFF_PETH_20_Down_Mod_Met_LPs;
Day.LPOFF_PETH_20_Down_Mod_Fail_LPs = LPOFF_PETH_20_Down_Mod_Fail_LPs;
% Rein ON 20 ms Bins
Day.Rein_ON_PETH_20_All_Mod_All_LPs = Rein_ON_PETH_20_All_Mod_All_LPs;
Day.Rein_ON_PETH_20_Up_Mod_All_LPs = Rein_ON_PETH_20_Up_Mod_All_LPs;
Day.Rein_ON_PETH_20_Down_Mod_All_LPs = Rein_ON_PETH_20_Down_Mod_All_LPs;
% LP ON 20 ms Bins Quantiles
Day.LPON_PETH_20_Quant_1_All_Mod_All_LPs = LPON_PETH_20_Quant_1_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_1_Up_Mod_All_LPs = LPON_PETH_20_Quant_1_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_1_Down_Mod_All_LPs = LPON_PETH_20_Quant_1_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_All_Mod_All_LPs = LPON_PETH_20_Quant_2_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_Up_Mod_All_LPs = LPON_PETH_20_Quant_2_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_Down_Mod_All_LPs = LPON_PETH_20_Quant_2_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_All_Mod_All_LPs = LPON_PETH_20_Quant_3_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_Up_Mod_All_LPs = LPON_PETH_20_Quant_3_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_Down_Mod_All_LPs = LPON_PETH_20_Quant_3_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_All_Mod_All_LPs = LPON_PETH_20_Quant_4_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_Up_Mod_All_LPs = LPON_PETH_20_Quant_4_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_Down_Mod_All_LPs = LPON_PETH_20_Quant_4_Down_Mod_All_LPs;
% LP OFF 20 ms Bins Quantiles
Day.LPOFF_PETH_20_Quant_1_All_Mod_All_LPs = LPOFF_PETH_20_Quant_1_All_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_1_Up_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_1_Down_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_2_All_Mod_All_LPs = LPOFF_PETH_20_Quant_2_All_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_2_Up_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_2_Down_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_3_All_Mod_All_LPs = LPOFF_PETH_20_Quant_3_All_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_3_Up_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_3_Down_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_4_All_Mod_All_LPs = LPOFF_PETH_20_Quant_4_All_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_4_Up_Mod_All_LPs;
Day.LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_4_Down_Mod_All_LPs;
% LP ON interpolated duration histogram
Day.PETH_Interp_All_Mod_All_LPs = PETH_Interp_All_Mod_All_LPs;
Day.PETH_Interp_All_Mod_Met_LPs = PETH_Interp_All_Mod_Met_LPs;
Day.PETH_Interp_All_Mod_Fail_LPs = PETH_Interp_All_Mod_Fail_LPs;
Day.PETH_Interp_Up_Mod_All_LPs = PETH_Interp_Up_Mod_All_LPs;
Day.PETH_Interp_Up_Mod_Met_LPs = PETH_Interp_Up_Mod_Met_LPs;
Day.PETH_Interp_Up_Mod_Fail_LPs = PETH_Interp_Up_Mod_Fail_LPs;
Day.PETH_Interp_Down_Mod_All_LPs = PETH_Interp_Down_Mod_All_LPs;
Day.PETH_Interp_Down_Mod_Met_LPs = PETH_Interp_Down_Mod_Met_LPs;
Day.PETH_Interp_Down_Mod_Fail_LPs = PETH_Interp_Down_Mod_Fail_LPs;
% LP ON 20 ms Bins Quantiles Interpolated Durations
Day.LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs = LPON_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = LPON_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = LPON_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs = LPON_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = LPON_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = LPON_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs = LPON_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = LPON_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = LPON_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs = LPON_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = LPON_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
Day.LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = LPON_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
% LP OFF 20 ms Bins Quantiles Interpolated Durations
% Day.LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs = LPOFF_PETH_20_Quant_1_Interp_All_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_1_Interp_Up_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_1_Interp_Down_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs = LPOFF_PETH_20_Quant_2_Interp_All_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_2_Interp_Up_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_2_Interp_Down_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs = LPOFF_PETH_20_Quant_3_Interp_All_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_3_Interp_Up_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_3_Interp_Down_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs = LPOFF_PETH_20_Quant_4_Interp_All_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs = LPOFF_PETH_20_Quant_4_Interp_Up_Mod_All_LPs;
% Day.LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs = LPOFF_PETH_20_Quant_4_Interp_Down_Mod_All_LPs;
end

