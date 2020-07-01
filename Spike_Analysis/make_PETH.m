function [PETH_data] = make_PETH(unit, unit_idx, Session, Event, Event_Label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create PETH
%  After importing variable from NEX (at least LeverPresses and unit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input VARIABLES  %%
%%%%%%%%%%%%%%%%%%%%%
% unit: collumn vector with timestamps (in seconds) for a neuronal unit
% Session: 
% Event: row vector with timestamps (in seconds) of all the leverpresses
%%%%%%%%%%%%%%%%%%%%%
% Output variables%%%
%%%%%%%%%%%%%%%%%%%%%
% PETH_data: structure with each of the trials alligned at Lever Press
%               (for all leverpresses)
% pethdata     = row vector with averaged values for moving time bins (all
%               lever presses)
% time         = time vector in milliseconds
% 4.4.19 Removed smoothing ('sgolay', 15), changed fail to < from <=
% 6.2.19 Change binning method to fixed bins instead of a rolling 1 ms
% window
%% Set initial conditions
% Define PETH Limits and Parameters
xmin = Session.base_time_start; % seconds before the event for PETH
xmax = Session.post_LP_time; % seconds after the event for PETH
bin_w = Session.bin_length * 1000; % bin width (ms)
spike_ts = unit' * 1000; % create row vector with timestamps for selected unit in milliseconds
xmin = (xmin*1000)-(bin_w/2); % adds - half bin to xmin in order to get all initial points in peth and converts everything in ms
xmax = (xmax*1000)+(bin_w/2); % adds + half bin to xmax in order to get all the end points in peth and converts everything in ms
%time_bins = (xmin+(bin_w/2):bin_w:xmax-(bin_w/2)); % Peri-event time
time_bins = (xmin+(bin_w/2):xmax-(bin_w/2)); % Peri-event time
Event_ts = Event' * 1000; % Event timestamps with ms resolution
%% Find spikes occurring between edges of event PETH
% Make strucutre storing spikes occurring between each event PETH
UC(1:length(Event_ts))={0};
trial = struct('spikes',UC);
ISI = nan(length(Event_ts),1);
for Event_Index = 1:length(Event_ts) % For each event timestamp
    from = Event_ts(Event_Index)+xmin; % First time stamp for PETH
    to = Event_ts(Event_Index)+xmax;   % Last time stamp for PETH
    spikes_between = spike_ts(spike_ts >= from & spike_ts  <= to); % Collect spikes that fall into the interval [minlim maxlim]
    trial(Event_Index).spikes = spikes_between - Event_ts(Event_Index); % Align spikes to zero LP time
    ISI(Event_Index) = mean(diff(spikes_between));
end
%% Compute the peri-event time histogram (PETH) by averaging the spike counts per time bin
% big_edges = [xmin : bin_w: xmax ]; % Edges of PETH bins
% bincount = nan(length(trial), length(big_edges) - 1); % Where binned histogram counts are stored
% for num_trial = 1:length(trial) % for each trial (e.g. event)
%     bincount(num_trial,:) = histcounts(trial(num_trial).spikes, big_edges); % Count spikes between bin edges
% end
% %% Use a 60 ms (three bins) Gaussian kernel to compute smooth spiking density functions
% % PETH of all events
% pethdata_all_count = mean(bincount)*(1000/bin_w); % convert to firing rate
% pethdata_all_smooth = smoothdata(pethdata_all_count,'gaussian', 3);
% PETH_all = pethdata_all_smooth;
% try
%     % PETH of events where hold down criteria was met
%     pethdata_met_count = mean(bincount(Session.LP_Length >= Session.Criteria,:))*(1000/bin_w); % convert to firing rate
%     pethdata_met_smooth = smoothdata(pethdata_met_count,'gaussian', 3);
%     PETH_met = pethdata_met_smooth;
% 
%     % PETH of events where hold down criteria was not met
%     pethdata_fail_count = mean(bincount(Session.LP_Length < Session.Criteria,:))*(1000/bin_w); % convert to firing rate
%     pethdata_fail_smooth = smoothdata(pethdata_fail_count,'gaussian', 3);
%     PETH_fail = pethdata_fail_smooth;
% catch
%     PETH_met = [];
%     PETH_fail = [];
% end
%% Compute the peri-event time histogram (PETH) by averaging the spike counts per milisecond time bin (for decoder)
%roll_time =(xmin+(bin_w/2):xmax-(bin_w/2));
binc = zeros(length(trial),2);
bincount=zeros(length(trial),xmax-xmin-(bin_w-1));
for j=1:length(time_bins)
    edges=[xmin+j-1 xmin+j+bin_w-1]; % Slides the bin window 1ms every iteration
    for i=1:length(trial)
        binc(i,:)= histc(trial(i).spikes,edges);
        bincount(i,j)=sum(binc(i,:)); % Counts the number of spikes in each trial for the current bin
    end
end
%% Use a 60 ms Gaussian kernel to compute smooth spiking density functions
% PETH of all events
pethdata_all_count = mean(bincount)*(1000/bin_w); % convert to firing rate
pethdata_all_smooth = smoothdata(pethdata_all_count, 'gaussian', 3);
PETH_all = pethdata_all_smooth;
try
    % PETH of events where hold down criteria was met
    pethdata_met_count = mean(bincount(Session.LP_Length >= Session.Criteria,:))*(1000/bin_w);
    pethdata_met_smooth = smoothdata(pethdata_met_count, 'gaussian', 3);
    PETH_met = pethdata_met_smooth;
    
    % PETH of events where hold down criteria was not met
    pethdata_fail_count = mean(bincount(Session.LP_Length < Session.Criteria,:))*(1000/bin_w);
    pethdata_fail_smooth = smoothdata(pethdata_fail_count, 'gaussian', 3);
    PETH_fail = pethdata_fail_smooth;
catch
    PETH_met = [];
    PETH_fail = [];
end
%% Compute the quantile-split peri-event time histogram (PETH) excluding successes
if ~strcmp(Event_Label,'Reinforcement Onset')
    Lengths = Session.LP_Length; % seconds
%     Failed_Lengths_idx = find(Lengths  < Session.Criteria);
%     Failed_Lengths = Lengths(Lengths  < Session.Criteria);
%     Failed_Lengths_idx = find(Lengths  < Session.Criteria);
%     Failed_Lengths = Lengths(Lengths  < Session.Criteria);
    edge_start = [0 0.25 0.50 0.75];
    edge_end = [0.25 0.50 0.75 1];
    Counts = [];
    True_edges = zeros(4,2);
    for quart = 1:4
        %edges = quantile(Failed_Lengths,[edge_start(quart) edge_end(quart)]);
        edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
%         if quart == 1
%             %quart_lenghts = Failed_Lengths(Failed_Lengths >= edges(1) & Failed_Lengths <= edges(2));
%             quart_lenghts = (Lengths >= edges(1) & (Lengths <= edges(2));
%         else
%             %quart_lenghts = Failed_Lengths(Failed_Lengths > edges(1) & Failed_Lengths <= edges(2));
%         end
        True_edges(quart,:) = edges;
    end
    %quant_1_idx = Failed_Lengths_idx(Failed_Lengths >= True_edges(1,1) & Failed_Lengths <= True_edges(1,2));
    quant_1_idx = (Lengths >= True_edges(1,1) & Lengths <= True_edges(1,2));
    quant_1_bincount = bincount(quant_1_idx,:);
    quant_1_mean_PETH = mean(quant_1_bincount)*(1000/bin_w);
    quant_1_PETH = smoothdata(quant_1_mean_PETH,'gaussian', 3);
    
    quant_2_idx = (Lengths > True_edges(2,1) & Lengths <= True_edges(2,2));
    quant_2_bincount = bincount(quant_2_idx,:);
    quant_2_mean_PETH = mean(quant_2_bincount)*(1000/bin_w);
    quant_2_PETH = smoothdata(quant_2_mean_PETH,'gaussian', 3);
    
    quant_3_idx = (Lengths > True_edges(3,1) & Lengths <= True_edges(3,2));
    quant_3_bincount = bincount(quant_3_idx,:);
    quant_3_mean_PETH = mean(quant_3_bincount)*(1000/bin_w);
    quant_3_PETH = smoothdata(quant_3_mean_PETH,'gaussian', 3);
    
    quant_4_idx = (Lengths > True_edges(4,1) & Lengths <= True_edges(4,2));
    quant_4_bincount = bincount(quant_4_idx,:);
    quant_4_mean_PETH = mean(quant_4_bincount)*(1000/bin_w);
    quant_4_PETH = smoothdata(quant_4_mean_PETH,'gaussian', 3);
    
    % Z score quantile durations
    Baseline_start_idx = find(Session.base_time_start*1000 == time_bins);
    Baseline_end_idx = find(Session.base_time_end*1000 == time_bins);
    Baseline = pethdata_all_count(Baseline_start_idx:Baseline_end_idx); % use unsmoothed mean PETH
    mu = mean(Baseline);
    sigma = std(Baseline, [], 2);
    z_score_PETH_quant_1 = (quant_1_PETH(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_2 = (quant_2_PETH(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_3 = (quant_3_PETH(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_4 = (quant_4_PETH(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    
    % Average histogram (split by duration quantiles)
    PETH_data.PETH_quant_1 = quant_1_PETH;
    PETH_data.PETH_quant_2 = quant_2_PETH;
    PETH_data.PETH_quant_3 = quant_3_PETH;
    PETH_data.PETH_quant_4 = quant_4_PETH;
    PETH_data.PETH_quant_1_z = z_score_PETH_quant_1;
    PETH_data.PETH_quant_2_z = z_score_PETH_quant_2;
    PETH_data.PETH_quant_3_z = z_score_PETH_quant_3;
    PETH_data.PETH_quant_4_z = z_score_PETH_quant_4;
end
%% Compute interpolated spike counts throughout duration of the lever press
if strcmp(Event_Label,'Lever Press Onset')
    interp_size = 40; % sample size for interpolated spike counts
    interp_spikes = nan(length(trial), interp_size);
    interp_spikes_count = nan(length(trial),1);
    interp_spikes_rate = nan(length(trial),1);
    interp_bincount_cell = cell(length(trial),1);
    interp_spikes_segmented_FR = nan(length(trial), 4);
    interp_spikes_segmented_count_FR = nan(length(trial), 4);
    interp_spikes_segmented_count_FR_mean = nan(length(trial), 4);
    z_scored_PETH_interp_all_trials_mean = nan(length(trial), 4);
%     interp_spikes_segmented_count_FR = nan(length(trial), 4);
    zero_index = find(time_bins == 0);
    for num_trial = 1:length(Lengths)
        Press_Duration_Sample_Length = round(Lengths(num_trial) / (bin_w/1000)); % Number of samples in lever press duration from zero
        lever_press_offset_index = zero_index + Press_Duration_Sample_Length;
        if lever_press_offset_index > size(bincount,2) % If duration exceeds PETH length (10 seconds), cut off excess
            interp_bincount = bincount(num_trial,zero_index:end);
            interp_bincount_cell{num_trial} = interp_bincount;
        else
            interp_bincount = bincount(num_trial,zero_index:lever_press_offset_index);
            interp_bincount_cell{num_trial} = interp_bincount;
        end
        total_samples = length(interp_bincount); % Number of samples in lever press duration including zero
        t0 = linspace(1,total_samples,total_samples); %original time vector
        t1 = linspace(1,total_samples,interp_size); % new time vector (specifying the time points at which you want to interpolate)
        try
            interp_spikes(num_trial,:) = interp1(t0,interp_bincount,t1,'linear'); %y0 data interpolated to 100 points
            interp_spikes_count(num_trial,1) = sum(interp_bincount);
            interp_spikes_rate(num_trial,1) = sum(interp_bincount) / Lengths(num_trial);
            interp_spikes_segmented_FR(num_trial,1) = mean(interp_spikes(num_trial,1:10))*(1000/bin_w);
            interp_spikes_segmented_FR(num_trial,2) = mean(interp_spikes(num_trial,11:20))*(1000/bin_w);
            interp_spikes_segmented_FR(num_trial,3) = mean(interp_spikes(num_trial,21:30))*(1000/bin_w);
            interp_spikes_segmented_FR(num_trial,4) = mean(interp_spikes(num_trial,31:40))*(1000/bin_w);
            
            interp_spikes_segmented_count_FR(num_trial,1) = sum(interp_spikes(num_trial,1:10));
            interp_spikes_segmented_count_FR(num_trial,2) = sum(interp_spikes(num_trial,11:20));
            interp_spikes_segmented_count_FR(num_trial,3) = sum(interp_spikes(num_trial,21:30));
            interp_spikes_segmented_count_FR(num_trial,4) = sum(interp_spikes(num_trial,31:40));
            
            interp_spikes_segmented_count_FR_mean(num_trial,1) = sum(interp_spikes(num_trial,1:10)) / 10;
            interp_spikes_segmented_count_FR_mean(num_trial,2) = sum(interp_spikes(num_trial,11:20)) / 10;
            interp_spikes_segmented_count_FR_mean(num_trial,3) = sum(interp_spikes(num_trial,21:30)) / 10;
            interp_spikes_segmented_count_FR_mean(num_trial,4) = sum(interp_spikes(num_trial,31:40)) / 10;
        catch
            warning('LP Duration < 20 ms');
            interp_spikes(num_trial,:) = zeros(1,interp_size);
        end
    end
    interp_PETH_all = mean(interp_spikes)*(1000/bin_w);
    interp_PETH_met = mean(interp_spikes(Lengths >= Session.Criteria,:))*(1000/bin_w);
    interp_PETH_fail = mean(interp_spikes(Lengths < Session.Criteria,:))*(1000/bin_w);
    
    quant_1_bincount_interp = interp_spikes(quant_1_idx,:);
    quant_1_mean_PETH_interp = mean(quant_1_bincount_interp)*(1000/bin_w);
    quant_1_PETH_interp = smoothdata(quant_1_mean_PETH_interp,'gaussian', 3);
    
    quant_2_bincount_interp = interp_spikes(quant_2_idx,:);
    quant_2_mean_PETH_interp = mean(quant_2_bincount_interp)*(1000/bin_w);
    quant_2_PETH_interp = smoothdata(quant_2_mean_PETH_interp,'gaussian', 3);
    
    quant_3_bincount_interp = interp_spikes(quant_3_idx,:);
    quant_3_mean_PETH_interp = mean(quant_3_bincount_interp)*(1000/bin_w);
    quant_3_PETH_interp = smoothdata(quant_3_mean_PETH_interp,'gaussian', 3);
    
    quant_4_bincount_interp = interp_spikes(quant_4_idx,:);
    quant_4_mean_PETH_interp = mean(quant_4_bincount_interp)*(1000/bin_w);
    quant_4_PETH_interp = smoothdata(quant_4_mean_PETH_interp,'gaussian', 3);
    
    % Z score interpolated durations
    Baseline_start_idx = find(Session.base_time_start*1000 == time_bins);
    Baseline_end_idx = find(Session.base_time_end*1000 == time_bins);
    Baseline = pethdata_all_count(Baseline_start_idx:Baseline_end_idx);
    mu = mean(Baseline);
    sigma = std(Baseline, [], 2);
    z_scored_PETH_interp_all = (interp_PETH_all - mu) ./  sigma;
    z_scored_PETH_interp_met = (interp_PETH_met - mu) ./  sigma;
    z_scored_PETH_interp_fail = (interp_PETH_fail - mu) ./  sigma;
    
    z_scored_PETH_interp_all_trials = ((interp_spikes.*(1000/bin_w)) - mu) ./  sigma;
    z_scored_PETH_interp_all_trials_mean(:,1) = mean(z_scored_PETH_interp_all_trials(:,1:10),2);
    z_scored_PETH_interp_all_trials_mean(:,2) = mean(z_scored_PETH_interp_all_trials(:,11:20),2);
    z_scored_PETH_interp_all_trials_mean(:,3) = mean(z_scored_PETH_interp_all_trials(:,21:30),2);
    z_scored_PETH_interp_all_trials_mean(:,4) = mean(z_scored_PETH_interp_all_trials(:,31:40),2);
    
    z_score_PETH_quant_1_interp = (quant_1_PETH_interp - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_2_interp = (quant_2_PETH_interp - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_3_interp = (quant_3_PETH_interp - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    z_score_PETH_quant_4_interp = (quant_4_PETH_interp - mu) ./  sigma; % Z-score FR from baseline end to PETH end
    
    % Interpolated Spike Counts throughout lever press duration
    PETH_data.PETH_interp_all = interp_PETH_all;
    PETH_data.PETH_interp_met = interp_PETH_met;
    PETH_data.PETH_interp_fail = interp_PETH_fail;
    PETH_data.PETH_interp_met_z = z_scored_PETH_interp_met;
    PETH_data.PETH_interp_all_z = z_scored_PETH_interp_all;
    PETH_data.PETH_interp_fail_z = z_scored_PETH_interp_fail;
    
    PETH_data.PETH_interp_segmented = interp_spikes_segmented_FR;
    PETH_data.PETH_interp_segmented_count = interp_spikes_segmented_count_FR ; 
    PETH_data.PETH_interp_segmented_count_mean = interp_spikes_segmented_count_FR_mean; 
    
    PETH_data.PETH_interp_all_z_count =  z_scored_PETH_interp_all_trials;
    PETH_data.PETH_interp_all_z_count_mean = z_scored_PETH_interp_all_trials_mean;
    
    
    PETH_data.PETH_interp_bincount = interp_spikes_count;
    PETH_data.PETH_interp_rate = interp_spikes_rate;
    PETH_data.PETH_interp_trial_count = interp_bincount_cell;
    % Average histogram (split by duration quantiles)
    PETH_data.PETH_quant_1_interp = quant_1_PETH_interp;
    PETH_data.PETH_quant_2_interp = quant_2_PETH_interp;
    PETH_data.PETH_quant_3_interp = quant_3_PETH_interp;
    PETH_data.PETH_quant_4_interp = quant_4_PETH_interp;
    PETH_data.PETH_quant_1_z_interp = z_score_PETH_quant_1_interp;
    PETH_data.PETH_quant_2_z_interp = z_score_PETH_quant_2_interp;
    PETH_data.PETH_quant_3_z_interp = z_score_PETH_quant_3_interp;
    PETH_data.PETH_quant_4_z_interp = z_score_PETH_quant_4_interp;
    
    
    
end
%% Z-score PETHs to pre-lever press onset baseline period
Baseline_start_idx = find(Session.base_time_start*1000 == time_bins);
Baseline_end_idx = find(Session.base_time_end*1000 == time_bins);
%Baseline_end_idx_roll = find(Session.base_time_end*1000 == time_bins);
if strcmp(Event_Label,'Lever Press Onset')
    Baseline = pethdata_all_count(Baseline_start_idx:Baseline_end_idx);
    PETH_data.Baseline = Baseline;

else
    Baseline = Session.Events.LPON.PETH_data(unit_idx).Baseline;
end
mu = mean(Baseline);
sigma = std(Baseline, [], 2);
z_scored_time_bins = time_bins(Baseline_end_idx:end); % Peri-event time
z_score_PETH_all = (PETH_all(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
z_score_PETH_met = (PETH_met(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
z_score_PETH_fail = (PETH_fail(Baseline_end_idx:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
% z_score_PETH_roll_all = (PETH_all(Baseline_end_idx_roll:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
% z_score_PETH_roll_met = (PETH_met(Baseline_end_idx_roll:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end
% z_score_PETH_roll_fail = (PETH_fail(Baseline_end_idx_roll:end) - mu) ./  sigma; % Z-score FR from baseline end to PETH end

%% Compute spikes occurring within each lever press
% if strcmp(Event_Label,'Lever Press Onset')
%     quant_1_duration_spikes = nan(length(trial),1);
%     quant_2_duration_spikes = nan(length(trial),1);
%     quant_3_duration_spikes = nan(length(trial),1);
%     quant_4_duration_spikes = nan(length(trial),1);
%     
%     duration_spikes_count = nan(length(trial),1);
%     duration_spikes_rate = nan(length(trial),1);
%     zero_index = find(time_bins == 0);
%     for num_trial = 1:length(Lengths)
%         Press_Duration_Sample_Length = round(Lengths(num_trial) / (bin_w/1000)); % Number of samples in lever press duration from zero
%         lever_press_offset_index = zero_index + Press_Duration_Sample_Length;
%         if lever_press_offset_index > size(bincount,2) % If duration exceeds PETH length (10 seconds), cut off excess
%             duration_bincount = bincount(num_trial,zero_index:end);
%             duration_bincount_cell{num_trial} = duration_bincount;
%         else
%             duration_bincount = bincount(num_trial,zero_index:lever_press_offset_index);
%             duration_bincount_cell{num_trial} = duration_bincount;
%         end
%         try
%             duration_spikes_count(num_trial,1) = sum(duration_bincount);
%             duration_spikes_rate(num_trial,1) = sum(duration_bincount) / Lengths(num_trial);
%             
%             
%         end
%         
%     end
% end




%% Save to Session structure
PETH_data.PETH_binned_FR_time = time_bins;
PETH_data.PETH_Z_Scored_FR_time = z_scored_time_bins;
% PETH_data.PETH_roll_FR_time = roll_time;
PETH_data.spike_ts_within_trial = trial;
% Histogram counts (by trial)
PETH_data.bincount = bincount;
% PETH_data.roll_bincount = bincount;
% Average histogram (1 ms resolution)
PETH_data.PETH_all = PETH_all;
PETH_data.PETH_met = PETH_met;
PETH_data.PETH_fail = PETH_fail;
PETH_data.PETH_all_z = z_score_PETH_all;
PETH_data.PETH_met_z = z_score_PETH_met;
PETH_data.PETH_fail_z = z_score_PETH_fail;
%% Inter Spike Interval
PETH_data.ISI = ISI;
% Average histogram (1 ms resolution)
% PETH_data.PETH_roll_all = PETH_all;
% PETH_data.PETH_roll_met = PETH_met;
% PETH_data.PETH_roll_fail = PETH_fail;
% PETH_data.PETH_roll_all_z = z_score_PETH_roll_all;
% PETH_data.PETH_roll_met_z = z_score_PETH_roll_met;
% PETH_data.PETH_roll_fail_z = z_score_PETH_roll_fail;

end


