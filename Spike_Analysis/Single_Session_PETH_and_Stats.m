function [] = Single_Session_PETH_and_Stats(Session_Directory, Processed_Session_Destination_Directory)
% Iterates through individual recording session files and calls on
% functions that calculate PETH for each event (Lever Press Onset, Lever
% Press Offset, Reward Onset) and determines wether they are significantly
% modulated with respects to a pre-lever-press onset baseline period
tic
%% Select folder where individual recording session files are stored
Folder_Containing_Session_Files = Session_Directory;
Folder_Contents = dir(Folder_Containing_Session_Files);
cd(Folder_Containing_Session_Files)
SessionFiles = Folder_Contents(3:end);
%% Iterate through each individual recording session file
for file = 1:3%length(SessionFiles) % For each recording file
    load(SessionFiles(file).name,'-mat','Session') % Load the file
    Session.base_time_start = -10; % Beginning of PETH and Baseline Period (s)
    Session.base_time_end = -2; % End of Baseline Period (s)
    Session.post_LP_time = 10; % End of PETH (s)
    Session.bin_length = 0.02; % PETH bin size (s)
    Session.sig_criteria_time = 60; % Criteria for sustained significance (ms)
    %% For each valid unit, calculate the pethdata and check for statistically significant changes
    for unit_idx = 1:length(Session.ValidUnits)
        % Assign Unit
        status = {unit_idx 'out of' length(Session.ValidUnits) 'units' ' in ' Session.Name}
        unit = Session.ValidUnitData{unit_idx}; 
        %% Calculate PETH
        % PETH of LP Onset
        [Session.Events.LPON.PETH_data(unit_idx)] = make_PETH(unit, unit_idx, Session, Session.Events.LPON.ts, Session.Events.LPON.Event_Label);
        % PETH of LP Offset
        [Session.Events.LPOFF.PETH_data(unit_idx)] = make_PETH(unit, unit_idx, Session, Session.Events.LPOFF.ts, Session.Events.LPOFF.Event_Label);
        % PETH of Reinforcement delivery
        [Session.Events.ReinON.PETH_data(unit_idx)] = make_PETH(unit,unit_idx, Session, Session.Events.ReinON.ts, Session.Events.ReinON.Event_Label);    
        %% Calculate statistically significant activity changes from baseline
        % LP Onset
%         [Session.Events.LPON.PETH_stats(unit_idx)] = Cazares_PETHstatistics(Session, Session.Events.LPON.PETH_data(unit_idx).PETH_all,...
%             Session.Events.LPON.Event_Label, unit_idx,  Session.Events.LPON.PETH_data(unit_idx).PETH_binned_FR_time);
%         % LP Offset
%        [Session.Events.LPOFF.PETH_stats(unit_idx)] = Cazares_PETHstatistics(Session, Session.Events.LPOFF.PETH_data(unit_idx).PETH_all,...
%             Session.Events.LPOFF.Event_Label, unit_idx,  Session.Events.LPOFF.PETH_data(unit_idx).PETH_binned_FR_time);
%         % Reinforcement Onset
%         [Session.Events.ReinON.PETH_stats(unit_idx)] = Cazares_PETHstatistics(Session, Session.Events.ReinON.PETH_data(unit_idx).PETH_all,...
%             Session.Events.ReinON.Event_Label, unit_idx,  Session.Events.ReinON.PETH_data(unit_idx).PETH_binned_FR_time);
%         
        %% Calculate statistically significant activity changes from baseline
        % LP Onset
        [Session.Events.LPON.PETH_stats(unit_idx)] = PETHstatistics_Rolling(Session, Session.Events.LPON.PETH_data(unit_idx).PETH_all,...
            Session.Events.LPON.Event_Label, unit_idx,  Session.Events.LPON.PETH_data(unit_idx).PETH_binned_FR_time, ...
            Session.Events.LPON.PETH_data(unit_idx).Baseline);
        % LP Offset
       [Session.Events.LPOFF.PETH_stats(unit_idx)] = PETHstatistics_Rolling(Session, Session.Events.LPOFF.PETH_data(unit_idx).PETH_all,...
            Session.Events.LPOFF.Event_Label, unit_idx,  Session.Events.LPOFF.PETH_data(unit_idx).PETH_binned_FR_time, ...
            Session.Events.LPON.PETH_data(unit_idx).Baseline);
        % Reinforcement Onset
        [Session.Events.ReinON.PETH_stats(unit_idx)] = PETHstatistics_Rolling(Session, Session.Events.ReinON.PETH_data(unit_idx).PETH_all,...
            Session.Events.ReinON.Event_Label, unit_idx,  Session.Events.ReinON.PETH_data(unit_idx).PETH_binned_FR_time, ...
            Session.Events.LPON.PETH_data(unit_idx).Baseline);
    end
    %% Perievent timings for plotting
%     time = Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
%     Session.base_idx_end = find(time == (Session.base_time_end*1000));
%     Session.data_idx_end = length(time);
%     Session.event_idx = find(time == 0);
%     Session.plot_time = time;
    %% Categorize units by peri-event epoch significance timings
    %[Session.SigEpochs] = Cazares_Unit_Epoch(Session);
    %% Set counts of unit categories
    %[Session.Ratios] = Cazares_Unit_Ratios(Session);
    %% Save Session Data in current directory
    SaveName = [Processed_Session_Destination_Directory 'Exp35-' char(Session.Name)];
    save(SaveName, 'Session', '-v7.3');
    clear Session
    toc
end

