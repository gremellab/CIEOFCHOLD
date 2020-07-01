function [] = Nex2Mat_Validity(Criteria, Nex_Directory, Session_Directory)
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cazares_Nex2Mat_Validity: Imports data from .nex5 file and validates units
% Invalidated units are those that were composed of bad waveforms as
% assesed manually from Offline Sorter clustering
% Input:
%   Criteria: Testing day's minimum time criteria for reward, in seconds
% Output:
%   Session: Data structure with valid waveform data and corrected event
%    timestamps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listing = dir(Nex_Directory);
Nex5Files = listing(3:end);

for file = 1:3%length(Nex5Files)
    cd(Nex_Directory)
    nex5FileData = readNex5File(Nex5Files(file).name);
    Session.Name = Nex5Files(file).name(1:end-5);
    status = ['Starting  ' Session.Name]
    SESS_OFF = max(nex5FileData.events{5}.timestamps); %Session end
    if isempty(SESS_OFF)
       SESS_OFF =  max(nex5FileData.events{4}.timestamps) + 10; % If session off var missing, add 10 secs to last reinforcer
    end
    SESS_ON = min(nex5FileData.events{6}.timestamps); %Session start
    Session.StartStop = [SESS_ON; SESS_OFF];
    %% Exclude unsorted clusters spike timings and waveforms
    units = nex5FileData.neurons;
    waves = nex5FileData.waves;
    valid_units_idx = [];
    for unit = 1:size(units,1)
        if isempty(strfind(units{unit,1}.name,'U')) && isempty(strfind(units{unit,1}.name,'template'))...
                && isempty(strfind(units{unit,1}.name,'wf'))
            valid_units_idx = [valid_units_idx unit];
        end
    end
    %% Exclude units with inconsistent firing throughout session 
    % 1. no spikes in approximately a minute (removed)
    % 2. < 1,000 total spikes in session
    bins = floor((SESS_OFF - SESS_ON) / 60);
    edges = linspace(Session.StartStop(1),Session.StartStop(2),bins);
    remove_idx = [];
    for unit = 1:length(valid_units_idx)
        check_unit = units{valid_units_idx(unit)}.timestamps;
        session_histcounts = histcounts(check_unit,edges);
%         if ~isempty(find(session_histcounts==0))
%             figure;
%             histogram(check_unit,edges)
%             remove_idx = [remove_idx unit];
%             status = {'Excluding unit' valid_units_idx(unit) ': spike pause'}
%         end
        if sum(session_histcounts) < 1000
            remove_idx = [remove_idx unit];
            status = {'Excluding unit' valid_units_idx(unit) ': < 1,000 spikes'}
        end
    end
    if ~isempty(remove_idx)
        valid_units_idx(remove_idx) = [];
    end
    %% These are the valid units and their corresponding waveforms
    valid_units = {};
    valid_units_data = {};
    valid_waves = {};
    valid_waves_data = {};
    for x = 1:length(valid_units_idx)
        valid_units{x} = units{valid_units_idx(x),1}.name;
        valid_units_data{x} = units{valid_units_idx(x),1}.timestamps;
        valid_waves{x} = waves{valid_units_idx(x),1}.name;
        valid_waves_data{x} = waves{valid_units_idx(x),1}.waveforms;
    end
    %% Create Data Structure
    Session.Units=units;
    Session.ValidUnits = valid_units';
    Session.ValidUnitData = valid_units_data';
    Session.ValidUnitsIdx = valid_units_idx';
    Session.Criteria = Criteria;% Set Session's Lever Press REIN Criteria in Seconds
    Session.Waves=waves;
    Session.ValidWaves = valid_waves';
    Session.ValidWavesData = valid_waves_data';
    %% Event variables
    % Load from nex5 struct
    LP_OFF = nex5FileData.events{1}.timestamps;
    LP_ON = nex5FileData.events{2}.timestamps;
    REIN_OFF = nex5FileData.events{3}.timestamps;
    REIN_ON = nex5FileData.events{4}.timestamps;
    % Removes Lever Press Onset and Offsets Occuring Outside of Session Start
    % (t = "true" press)
    t_LP_OFF = LP_OFF(find(LP_OFF > SESS_ON));
    t_LP_OFF = t_LP_OFF(find(t_LP_OFF < SESS_OFF));
    %t_LP_OFF = t_LP_OFF(2:end);
    t_LP_ON = LP_ON(LP_ON > SESS_ON);
    t_LP_ON = t_LP_ON(t_LP_ON < SESS_OFF);
    t_LP_ON = t_LP_ON(1:end-1);
    % Remove lever press onset and offset that don't follow each other
    %(e.g. Offsets occuring before Onsets)
    if ~(length(t_LP_OFF) == length(t_LP_ON))
        if length(t_LP_OFF) > length(t_LP_ON)
            t_LP_OFF = t_LP_OFF(1:end-2);
        end
        if length(t_LP_OFF) < length(t_LP_ON)
            t_LP_ON = t_LP_ON(1:end-1);
        end
    end
    LP_Length = t_LP_OFF - t_LP_ON;
    %Get Lever Press Lengths by subtraction and remove LPs with <100 ms IPI
    %(shorter than a single bin in the PETH)
    LPs_too_short = sum(LP_Length < .02);
    
    t_LP_ON = t_LP_ON(~(LP_Length < .02));
    t_LP_OFF = t_LP_OFF(~(LP_Length < .02));
    LP_Length = t_LP_OFF - t_LP_ON;
    %Get Lever Press Lengths by subtraction and remove LPs with > 10
    %seconds in duration (exceeding raster limits)
    LPs_too_long = sum(LP_Length > 10);
    t_LP_ON = t_LP_ON(~(LP_Length > 10));
    t_LP_OFF = t_LP_OFF(~(LP_Length > 10));
    LP_Length = t_LP_OFF - t_LP_ON;
    % Categorize Lever Press On/Off Timestamps by whether it met REIN criteria or not
    Total_REIN = sum(LP_Length >= Criteria);
    Time_REIN_LP_ON = t_LP_ON(LP_Length > Criteria);
    Time_REIN_LP_OFF = t_LP_OFF(LP_Length > Criteria);
    Time_noREIN_LP_ON = t_LP_ON(LP_Length <= Criteria);
    Time_noREIN_LP_OFF = t_LP_OFF(LP_Length <= Criteria);
    %% Append data to Session data structure for PETH analysis
    Session.Events.ReinON.ts = REIN_ON;
    Session.Events.ReinON.Event_Label = 'Reinforcement Onset';
    Session.Events.ReinOFF.ts = REIN_OFF;
    Session.Events.ReinOFF.Event_Label = 'Reinforcement Offset';
    Session.Events.LPOFF.ts = t_LP_OFF;
    Session.Events.LPOFF.Event_Label = 'Lever Press Offset';
    Session.Events.LPON.ts = t_LP_ON;
    Session.Events.LPON.Event_Label = 'Lever Press Onset';
    Session.LP_Length = LP_Length;
    Session.TotalRein = length(REIN_ON);
    Session.LPs_too_short = LPs_too_short;
    Session.LPs_too_long = LPs_too_long;
    %% Save Session Data in data directory
    data_directory = Session_Directory;
    SaveName = [data_directory 'Exp35-' char(Session.Name)];
    save(SaveName, 'Session', '-v7.3');
    clear Session
end
toc
end

