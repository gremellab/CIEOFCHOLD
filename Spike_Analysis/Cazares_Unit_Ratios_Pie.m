function [Ratios] = Cazares_Unit_Ratios_Pie(Day)
% Categorize Unit Modulation for Pie Chart

for mouse = 1:length(Day.Mouse)
    all_units_total = size(Day.Mouse(mouse).Session.ValidUnits,1);
    %% Units by Event
     up_sig_idx_LPON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}));
     down_sig_idx_LPON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}));
     unique_LP_ON_sig = unique([up_sig_idx_LPON,  down_sig_idx_LPON]);
     
     
     up_sig_idx_LPOFF = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Up_Mod_Window}));
     down_sig_idx_LPOFF = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Down_Mod_Window}));
     unique_LP_OFF_sig = unique([up_sig_idx_LPOFF,  down_sig_idx_LPOFF]);
     
     up_sig_idx_ReinON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Up_Mod_Window}));
     down_sig_idx_ReinON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Down_Mod_Window}));
     unique_Rein_ON_sig = unique([up_sig_idx_ReinON,  down_sig_idx_ReinON]);
     
     %% For One Event
     [Lia] = ismember(unique_LP_ON_sig, unique_LP_OFF_sig);
     only_LP_ON_sig_idx = find(~Lia);
     only_LP_ON = unique_LP_ON_sig(only_LP_ON_sig_idx);
     [Lia] = ismember(only_LP_ON, unique_Rein_ON_sig);
     only_LP_ON_sig_idx = find(~Lia);
     only_LP_ON =  only_LP_ON(only_LP_ON_sig_idx);
     
     [Lia] = ismember(unique_LP_OFF_sig, unique_LP_ON_sig);
     only_LP_OFF_sig_idx = find(~Lia);
     only_LP_OFF = unique_LP_OFF_sig(only_LP_OFF_sig_idx);
     [Lia] = ismember(only_LP_OFF, unique_Rein_ON_sig);
     only_LP_OFF_sig_idx = find(~Lia);
     only_LP_OFF =  only_LP_OFF(only_LP_OFF_sig_idx);
     
     [Lia] = ismember(unique_Rein_ON_sig, unique_LP_ON_sig);
     only_Rein_ON_sig_idx = find(~Lia);
     only_Rein_ON = unique_Rein_ON_sig(only_Rein_ON_sig_idx);
     [Lia] = ismember(only_Rein_ON, unique_LP_OFF_sig);
     only_Rein_ON_sig_idx = find(~Lia);
     only_Rein_ON =  only_Rein_ON(only_Rein_ON_sig_idx);
     
     %% For Two Events
     [LP_ON_LP_OFF_intersection,~,~] = intersect(unique_LP_ON_sig, unique_LP_OFF_sig); 
     [Lia] = ismember(LP_ON_LP_OFF_intersection, unique_Rein_ON_sig);
     only_LP_ON_LP_OFF_sig_idx = find(~Lia);
     only_LP_ON_LP_OFF = LP_ON_LP_OFF_intersection(only_LP_ON_LP_OFF_sig_idx);
     
     [LP_ON_Rein_ON_intersection,~,~] = intersect(unique_LP_ON_sig, unique_Rein_ON_sig); 
     [Lia] = ismember(LP_ON_Rein_ON_intersection, unique_LP_OFF_sig);
     only_LP_ON_Rein_ON_sig_idx = find(~Lia);
     only_LP_ON_Rein_ON = LP_ON_Rein_ON_intersection(only_LP_ON_Rein_ON_sig_idx);

     [LP_OFF_Rein_ON_intersection,~,~] = intersect(unique_LP_OFF_sig, unique_Rein_ON_sig); 
     [Lia] = ismember(LP_OFF_Rein_ON_intersection, unique_LP_ON_sig);
     only_LP_OFF_Rein_ON_sig_idx = find(~Lia);
     only_LP_OFF_Rein_ON = LP_OFF_Rein_ON_intersection(only_LP_OFF_Rein_ON_sig_idx);
     
     %% For Three Events
     [LP_ON_LP_OFF_intersection,~,~] = intersect(unique_LP_ON_sig, unique_LP_OFF_sig);
     [only_Rein_ON_LP_ON_LP_OFF,~,~] = intersect(LP_ON_LP_OFF_intersection, unique_Rein_ON_sig);
     found_text = ['All event sig unit in session '  num2str(mouse) ' units ' num2str(only_Rein_ON_LP_ON_LP_OFF)]
     %% Structure
     Ratios(mouse).Total_Units = all_units_total;
     Ratios(mouse).Sig_Units = length(unique([only_LP_ON,only_LP_OFF,...
         only_Rein_ON, only_LP_ON_LP_OFF, only_LP_ON_Rein_ON, only_LP_OFF_Rein_ON, only_Rein_ON_LP_ON_LP_OFF  ]));
     % One Event
     Ratios(mouse).LP_Onset = length(only_LP_ON);
     Ratios(mouse).LP_Offset = length(only_LP_OFF);
     Ratios(mouse).Rein_Onset = length(only_Rein_ON);
     % Two Events
     Ratios(mouse).LP_Onset_LP_Offset = length(only_LP_ON_LP_OFF);
     Ratios(mouse).LP_Onset_Rein_Onset = length(only_LP_ON_Rein_ON);
     Ratios(mouse).LP_Offset_Rein_Onset = length(only_LP_OFF_Rein_ON);
     % Three Events
     Ratios(mouse).LP_Onset_LP_Offset_Rein_Onset = length(only_Rein_ON_LP_ON_LP_OFF);
     
     % CHECK!!!!
     all_sum = sum([Ratios(mouse).LP_Onset Ratios(mouse).LP_Offset Ratios(mouse).Rein_Onset...
             Ratios(mouse).LP_Onset_LP_Offset, Ratios(mouse).LP_Onset_Rein_Onset,...
             Ratios(mouse).LP_Offset_Rein_Onset, Ratios(mouse).LP_Onset_LP_Offset_Rein_Onset]);
    if all_sum ~= Ratios(mouse).Sig_Units
        check_text = ['unmatched sig unit total in mouse '  num2str(mouse) ] 
    end
end
    %% Sums
    mouse = mouse + 1;
    Ratios(mouse).Total_Units = sum([Ratios(:).Total_Units]);
    Ratios(mouse).Sig_Units = sum([Ratios(:).Sig_Units]);
    Ratios(mouse).LP_Onset = sum([Ratios(:).LP_Onset]);
    Ratios(mouse).LP_Offset = sum([Ratios(:).LP_Offset]);
    Ratios(mouse).Rein_Onset = sum([Ratios(:).Rein_Onset]);
    Ratios(mouse).LP_Onset_LP_Offset = sum([Ratios(:).LP_Onset_LP_Offset]);
    Ratios(mouse).LP_Onset_Rein_Onset = sum([Ratios(:).LP_Onset_Rein_Onset]);
    Ratios(mouse).LP_Offset_Rein_Onset = sum([Ratios(:).LP_Offset_Rein_Onset]);
    Ratios(mouse).LP_Onset_LP_Offset_Rein_Onset = sum([Ratios(:).LP_Onset_LP_Offset_Rein_Onset]);
%     %% Up Modulated
%     up_sig_idx_LPON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}));
%     up_sig_idx_LPOFF = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Up_Mod_Window}));
%     up_sig_idx_ReinON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Up_Mod_Window}));
%     
%     [exclusion, up_onset_idx, up_offset_idx] = setxor(up_sig_idx_LPON, up_sig_idx_LPOFF);
%     [intersection,ia,ib] = intersect(up_sig_idx_LPON, up_sig_idx_LPOFF);
%     
%     up_onset = length(up_onset_idx);
%     up_offset = length(up_offset_idx);
%     up_both = length(intersection);
%     
%     %% Down Modulated
%     down_sig_idx_LPON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}));
%     down_sig_idx_LPOFF = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPOFF.PETH_stats.Down_Mod_Window}));
%     down_sig_idx_ReinON = find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.ReinON.PETH_stats.Down_Mod_Window}));
%     
%     [exclusion, down_onset_idx, down_offset_idx] = setxor(down_sig_idx_LPON, down_sig_idx_LPOFF);
%     [intersection,ia,ib] = intersect(down_sig_idx_LPON, down_sig_idx_LPOFF);
%     
%     down_onset = length(down_onset_idx);
%     down_offset = length(down_offset_idx);
%     down_both = length(intersection);
%     %% Both Up and Down Modulated
%     [both_onset,~,~] = intersect(up_sig_idx_LPON, down_sig_idx_LPON);
%     [both_offset,~,~] = intersect(up_sig_idx_LPOFF, down_sig_idx_LPOFF);
%     
%     %% Structure array with counts
%     Ratios(mouse).all_units_total = all_units_total;
%     Ratios(mouse).all_units_sig_total = length(unique([up_sig_idx_LPON, up_sig_idx_LPOFF, down_sig_idx_LPON, down_sig_idx_LPOFF]));
%     
%     Ratios(mouse).Up.onset = up_onset;
%     Ratios(mouse).Up.offset = up_offset;
%     Ratios(mouse).Up.both = up_both;
%     Ratios(mouse).Up.sig_units_total = up_onset + up_offset + up_both;
%     
%     Ratios(mouse).Down.onset = down_onset;
%     Ratios(mouse).Down.offset = down_offset;
%     Ratios(mouse).Down.both = down_both;
%     Ratios(mouse).Down.sig_units_total = down_onset + down_offset + down_both;
end

