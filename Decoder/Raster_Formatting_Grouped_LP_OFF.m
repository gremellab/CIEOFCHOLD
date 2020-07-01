function [] = Raster_Formatting_Grouped_LP_OFF(Session_Directory, Raster_Destination)
%RASTER_FORMATTING Summary of this function goes here
%   Detailed explanation goes here
tic
%selpath = uigetdir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Data');
%selpath = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\1600-Early-Air';
listing = dir(Session_Directory);
SessionFiles = listing(3:end);


for file = 1:length(SessionFiles)
    %% Make new folder to put raster data in
    file
    Data = load(SessionFiles(file).name,'-mat','Session');
    destdirectory = Raster_Destination;% Session.Name];
    %destdirectory = ['I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Raster_Format_Data\Cohort_Grouped_LP_OFF_Sig\CIE\']
   % mkdir(destdirectory);   %create the directory
    %% Get indices of met vs fail 
    met_idx = find(Data.Session.LP_Length > Data.Session.Criteria);
    fail_idx = find(Data.Session.LP_Length <= Data.Session.Criteria);
    percentile_values = prctile(Data.Session.LP_Length,[25 50 75],1);
    logic_trials = Data.Session.LP_Length > Data.Session.Criteria;
    [iupper,ilower,uppersum,lowersum] = cusum(Data.Session.LP_Length,2,1,mean(Data.Session.LP_Length),std(Data.Session.LP_Length),'all');
    Durations_Above = Data.Session.LP_Length(iupper);
    Durations_Above_Idx = iupper;
    
    
    Durations_Above_Reward_Idx = Durations_Above_Idx(find(Durations_Above >= Data.Session.Criteria));
    Durations_Above_Fail_Idx = Durations_Above_Idx(find(~(Durations_Above >= Data.Session.Criteria)));
    Durations_Above_Reward = Durations_Above(Durations_Above >= Data.Session.Criteria);
    Durations_Above_Fail = Durations_Above(~(Durations_Above >= Data.Session.Criteria));
    
    Durations_Below = Data.Session.LP_Length;
    Durations_Below(iupper,:) = [];
    Durations_Below_Idx = (1:length(Data.Session.LP_Length))';
    Durations_Below_Idx(iupper) = [];
    Durations_Below_Reward_Idx = Durations_Below_Idx(find(Durations_Below >= Data.Session.Criteria));
    Durations_Below_Fail_Idx = Durations_Below_Idx(find(~(Durations_Below >= Data.Session.Criteria)));
    Durations_Below_Reward = Durations_Below(Durations_Below >= Data.Session.Criteria);
    Durations_Below_Fail = Durations_Below(~(Durations_Below >= Data.Session.Criteria));

    for trial = 1:length(logic_trials)
        if logic_trials(trial) == 1
            raster_labels.Performance(1,trial) = {char('yes')};
        else
            raster_labels.Performance(1,trial) = {char('no')};
        end

   
        if Data.Session.LP_Length(trial) <= percentile_values(1)
            raster_labels.Percentile(1,trial) = {char('25')};
        elseif Data.Session.LP_Length(trial) <= percentile_values(2)
            raster_labels.Percentile(1,trial) = {char('50')};
        elseif Data.Session.LP_Length(trial) <= percentile_values(3)
            raster_labels.Percentile(1,trial) = {char('75')};
        else
            raster_labels.Percentile(1,trial) = {char('100')};
        end


        if any(trial == Durations_Above_Idx)
            raster_labels.State(1,trial) = {char('Up')};
        elseif any(trial == Durations_Below_Idx)
            raster_labels.State(1,trial) = {char('Down')};
        end



        if any(trial == Durations_Above_Idx) & any(trial == Durations_Above_Reward_Idx)
            raster_labels.State_Performance(1,trial) = {char('Up_Met')};
        elseif any(trial == Durations_Above_Idx) & any(trial == Durations_Above_Fail_Idx)
            raster_labels.State_Performance(1,trial) = {char('Up_Fail')};
        elseif any(trial == Durations_Below_Idx) & any(trial == Durations_Below_Reward_Idx)
            raster_labels.State_Performance(1,trial) = {char('Down_Met')};
        elseif any(trial == Durations_Below_Idx) & any(trial == Durations_Below_Fail_Idx)
            raster_labels.State_Performance(1,trial) = {char('Down_Fail')};
        end
    end

    raster_site_info.session_ID = Data.Session.Name;
    raster_site_info.Criteria = Data.Session.Criteria;
    raster_site_info.Total_Met = length(met_idx);
    raster_site_info.Total_Fail = length(fail_idx);
    raster_site_info.aligment_event_time = 1001;
    sig_idx = unique([find(~cellfun(@isempty,{Data.Session.Events.LPOFF.PETH_stats.Up_Mod_Window}))...
        find(~cellfun(@isempty,{Data.Session.Events.LPOFF.PETH_stats.Down_Mod_Window}))]);
    for neuron = 1:size(Data.Session.Events.LPOFF.PETH_stats,2) %sig_idx
         %raster_data = Data.Session.Events.LPOFF.PETH_data(neuron).roll_bincount(:,8001:15001); % from -2 to 5 perievent
        raster_data = Data.Session.Events.LPOFF.PETH_data(neuron).bincount(:,8001:15001); % from -2 to 5 perievent
        raster_site_info.electrode_ID = Data.Session.ValidUnits{neuron};
        save([destdirectory '\' raster_site_info.session_ID '_' raster_site_info.electrode_ID '_raster_data'], 'raster_data', 'raster_labels', 'raster_site_info')
    end
    clear raster_data raster_site_info raster_labels
end
toc
end

