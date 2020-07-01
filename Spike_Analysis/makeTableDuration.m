function [Durations] = makeTableDuration(Day)

PETH_time = Day.Mouse(1).Session.Events.LPON.PETH_data(1).PETH_binned_FR_time;
curr_mouse = 0;
curr_unit  = 1;
curr_LP_ON_up_unit = 1;
curr_LP_ON_down_unit = 1;
All_Units_Array = [];
LP_ON_Up_Units_Array = [];
LP_ON_Down_Units_Array = [];
LP_ON_Up_Sig_idx = [];
LP_ON_Down_Sig_idx = [];
for mouse = 1:size(Day.Mouse ,2)
    %% Update Mouse and Session Counters
    if rem(mouse,2) == 0
        session = 2;
    else
        session = 1;
        curr_mouse = curr_mouse + 1;
    end
    % Total Lever Presses
    Total_LPs = ones(length(Day.Mouse(mouse).Session.LP_Length),1);
    %% Quantile
    Lengths = Day.Mouse(mouse).Session.LP_Length; % seconds
    quant_id = nan(size(Lengths));
    edge_start = [0 0.25 0.50 0.75];
    edge_end = [0.25 0.50 0.75 1];
    True_edges = zeros(4,2);
    for quart = 1:4
        edges = quantile(Lengths,[edge_start(quart) edge_end(quart)]);
        True_edges(quart,:) = edges;
    end
    quant_1_idx = (Lengths >= True_edges(1,1) & Lengths <= True_edges(1,2));
    quant_2_idx = (Lengths > True_edges(2,1) & Lengths <= True_edges(2,2));
    quant_3_idx = (Lengths > True_edges(3,1) & Lengths <= True_edges(3,2));
    quant_4_idx = (Lengths > True_edges(4,1) & Lengths <= True_edges(4,2));
    quant_id(quant_1_idx) = 1;
    quant_id(quant_2_idx) = 2;
    quant_id(quant_3_idx) = 3;
    quant_id(quant_4_idx) = 4;
    %% Spikes during lever press (including each segment)
    LP_ON_ts = Day.Mouse(mouse).Session.Events.LPON.ts;
    LP_OFF_ts = Day.Mouse(mouse).Session.Events.LPOFF.ts;
    segment_time = (Lengths ./ 4);
    segment_1 = [LP_ON_ts (LP_ON_ts + segment_time)]; % timestamps of segments
    segment_2 = [segment_1(:,2) (segment_1(:,2) + segment_time)];
    segment_3 = [segment_2(:,2) (segment_2(:,2) + segment_time)];
    segment_4 = [segment_3(:,2) (segment_3(:,2) + segment_time)];
    for unit = 1:length(Day.Mouse(mouse).Session.ValidUnitsIdx)
        spike_ts = Day.Mouse(mouse).Session.ValidUnitData{unit};
        baseline_rate = nan(size(Lengths));
        duration_rate_z = nan(size(Lengths))';
        quant_rate_z = nan(size(Lengths))';
        quant_rate_segment_1_z = nan(size(Lengths))';
        quant_rate_segment_2_z = nan(size(Lengths))';
        quant_rate_segment_3_z = nan(size(Lengths))';
        quant_rate_segment_4_z = nan(size(Lengths))';
        duration_rate = nan(size(Lengths))';
        duration_count = nan(size(Lengths))';
        segment_1_rate = nan(size(Lengths)); segment_2_rate = nan(size(Lengths)); segment_3_rate = nan(size(Lengths)); segment_4_rate = nan(size(Lengths));
        segment_1_count = nan(size(Lengths));  segment_2_count = nan(size(Lengths)); segment_3_count = nan(size(Lengths)); segment_4_count = nan(size(Lengths));
        segment_1_proportion = nan(size(Lengths));  segment_2_proportion = nan(size(Lengths)); segment_3_proportion = nan(size(Lengths)); segment_4_proportion = nan(size(Lengths));
        for press = 1:length(Lengths) % for each lever press
            %spike_ts = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(press).spikes;% spikes that occured in PETH
            spikes_within_press = spike_ts(find((spike_ts < LP_OFF_ts(press)) & (spike_ts >= LP_ON_ts(press))));
            duration_count(press) = sum((spikes_within_press < LP_OFF_ts(press)) & (spikes_within_press >= LP_ON_ts(press)));
            duration_rate(press) = duration_count(press) / Lengths(press);
            segment_1_count(press) = sum((spikes_within_press < segment_1(press,2)) & (spikes_within_press >= segment_1(press,1)));
            segment_1_rate(press) =  segment_1_count(press) / segment_time(press);
            segment_2_count(press) = sum((spikes_within_press < segment_2(press,2)) & (spikes_within_press >= segment_2(press,1)));
            segment_2_rate(press) =  segment_2_count(press) / segment_time(press);
            segment_3_count(press) = sum((spikes_within_press < segment_3(press,2)) & (spikes_within_press >= segment_3(press,1)));
            segment_3_rate(press) =  segment_3_count(press) / segment_time(press);
            segment_4_count(press) = sum((spikes_within_press < segment_4(press,2)) & (spikes_within_press >= segment_4(press,1)));
            segment_4_rate(press) =  segment_4_count(press) / segment_time(press);
            
            
            % proportions
            segment_1_proportion(press) = segment_1_count(press) / duration_count(press);
            segment_2_proportion(press) = segment_2_count(press) / duration_count(press);
            segment_3_proportion(press) = segment_3_count(press) / duration_count(press);
            segment_4_proportion(press) = segment_4_count(press) / duration_count(press);
            
%             if sum([segment_1_count(press) segment_2_count(press) segment_3_count(press) segment_4_count(press)]) > duration_count(press)
%                 [mouse unit press segment_1_proportion(press) segment_2_proportion(press) segment_3_proportion(press) segment_4_proportion(press) duration_count(press)]
%             end
%            
%             if ~any(isnan(sum([segment_1_proportion(press) segment_2_proportion(press) segment_3_proportion(press) segment_4_proportion(press)])))
%                 if  ~(sum([segment_1_proportion(press) segment_2_proportion(press) segment_3_proportion(press) segment_4_proportion(press)]) == 1)
%                     ree = sum([segment_1_proportion(press) segment_2_proportion(press) segment_3_proportion(press) segment_4_proportion(press)]);
%                     [mouse unit press segment_1_proportion(press) segment_2_proportion(press) segment_3_proportion(press) segment_4_proportion(press) ree]
%                 end
%             end
            
            % baseline
            peri_event_bincount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).bincount(press,:);
            Baseline_end_time = (Day.Mouse(1).Session.base_time_end*1000);
            Baseline_end_ts = LP_ON_ts(press) + Day.Mouse(1).Session.base_time_end;
            Baseline_end_idx = find(PETH_time == Baseline_end_time);
            length_in_ms = Lengths(press)*1000;
            Baseline_start_time = Baseline_end_time - length_in_ms;
            if Baseline_start_time < (Day.Mouse(1).Session.base_time_start*1000) % if lever press exceeds 8 seconds (-2 to -10 window)
                Baseline_start_time = Day.Mouse(1).Session.base_time_start*1000;
            end
           % Baseline_start_idx = nearestpoint(Baseline_start_time, PETH_time);
            Baseline_start_ts = Baseline_end_ts - Lengths(press);
          %  baseline_window = peri_event_bincount(Baseline_start_idx:Baseline_end_idx);
            % Count spikes in baseline period of the same length as lever
            % press duration
            spikes_within_baseline = sum((spike_ts < Baseline_end_ts) & (spike_ts >= Baseline_start_ts));
            baseline_rate(press) = spikes_within_baseline / Lengths(press);
        end
        %% Baseline (all Lps)
        mu = mean(baseline_rate);
        sigma = std(baseline_rate);
        duration_rate_z = (duration_rate - mu) ./  sigma;
        %% Baseline (quantile)
        for curr_quant_id = 1:4
            quant_idx = find(quant_id == curr_quant_id);
            baseline_quant = baseline_rate(quant_idx);
            duration_rate_quant = duration_rate(quant_idx);
            segment_1_rate_quant = segment_1_rate(quant_idx);
            segment_2_rate_quant = segment_2_rate(quant_idx);
            segment_3_rate_quant = segment_3_rate(quant_idx);
            segment_4_rate_quant = segment_4_rate(quant_idx);
            mu = mean(baseline_quant);
            sigma = std(baseline_quant);
            quant_rate_z(quant_idx) = (duration_rate_quant - mu) ./  sigma;
            quant_rate_segment_1_z(quant_idx) = (segment_1_rate_quant - mu) ./  sigma;
            quant_rate_segment_2_z(quant_idx) = (segment_2_rate_quant - mu) ./  sigma;
            quant_rate_segment_3_z(quant_idx) = (segment_3_rate_quant - mu) ./  sigma;
            quant_rate_segment_4_z(quant_idx) = (segment_4_rate_quant - mu) ./  sigma;
        end
        
        %% Organize for table
        Duration = Lengths;
        QuantID = quant_id;
        HoldCount = duration_count';
        HoldRate = duration_rate';
        HoldRate_Z = duration_rate_z';
        Quant_Rate_Z = quant_rate_z';
        Quant_Rate_Z_Seg_1 = quant_rate_segment_1_z';
        Quant_Rate_Z_Seg_2 = quant_rate_segment_2_z';
        Quant_Rate_Z_Seg_3 = quant_rate_segment_3_z';
        Quant_Rate_Z_Seg_4 = quant_rate_segment_4_z';
        HoldBaselineRate = baseline_rate;
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        All_Units_Array = [All_Units_Array; Duration HoldCount QuantID  segment_1_proportion segment_2_proportion segment_3_proportion segment_4_proportion,...
            HoldRate HoldRate_Z Quant_Rate_Z Quant_Rate_Z_Seg_1 Quant_Rate_Z_Seg_2 Quant_Rate_Z_Seg_3 Quant_Rate_Z_Seg_4 HoldBaselineRate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_unit  = curr_unit + 1;
        
    end
    %% Sig Unit Indices UPMODULATED LP ON
    LP_ON_Up_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Up_Mod_Window}))]);
    LP_ON_Down_Sig_Units_Idx = unique([find(~cellfun(@isempty,{Day.Mouse(mouse).Session.Events.LPON.PETH_stats.Down_Mod_Window}))]);
    for unit = LP_ON_Up_Sig_Units_Idx
        spike_ts = Day.Mouse(mouse).Session.ValidUnitData{unit};
        baseline_rate = nan(size(Lengths));
        duration_rate_z = nan(size(Lengths))';
        quant_rate_z = nan(size(Lengths))';
        quant_rate_segment_1_z = nan(size(Lengths))';
        quant_rate_segment_2_z = nan(size(Lengths))';
        quant_rate_segment_3_z = nan(size(Lengths))';
        quant_rate_segment_4_z = nan(size(Lengths))';
        duration_rate = nan(size(Lengths))';
        duration_count = nan(size(Lengths))';
        segment_1_rate = nan(size(Lengths)); segment_2_rate = nan(size(Lengths)); segment_3_rate = nan(size(Lengths)); segment_4_rate = nan(size(Lengths));
        segment_1_count = nan(size(Lengths));  segment_2_count = nan(size(Lengths)); segment_3_count = nan(size(Lengths)); segment_4_count = nan(size(Lengths));
        segment_1_proportion = nan(size(Lengths));  segment_2_proportion = nan(size(Lengths)); segment_3_proportion = nan(size(Lengths)); segment_4_proportion = nan(size(Lengths));
        for press = 1:length(Lengths) % for each lever press
            %spike_ts = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).spike_ts_within_trial(press).spikes;% spikes that occured in PETH
            spikes_within_press = spike_ts(find((spike_ts < LP_OFF_ts(press)) & (spike_ts >= LP_ON_ts(press))));
            duration_count(press) = sum((spikes_within_press < LP_OFF_ts(press)) & (spikes_within_press >= LP_ON_ts(press)));
            duration_rate(press) = duration_count(press) / Lengths(press);
            segment_1_count(press) = sum((spikes_within_press < segment_1(press,2)) & (spikes_within_press >= segment_1(press,1)));
            segment_1_rate(press) =  segment_1_count(press) / segment_time(press);
            segment_2_count(press) = sum((spikes_within_press < segment_2(press,2)) & (spikes_within_press >= segment_2(press,1)));
            segment_2_rate(press) =  segment_2_count(press) / segment_time(press);
            segment_3_count(press) = sum((spikes_within_press < segment_3(press,2)) & (spikes_within_press >= segment_3(press,1)));
            segment_3_rate(press) =  segment_3_count(press) / segment_time(press);
            segment_4_count(press) = sum((spikes_within_press < segment_4(press,2)) & (spikes_within_press >= segment_4(press,1)));
            segment_4_rate(press) =  segment_4_count(press) / segment_time(press);
            
            
            % proportions
            segment_1_proportion(press) = segment_1_count(press) / duration_count(press);
            segment_2_proportion(press) = segment_2_count(press) / duration_count(press);
            segment_3_proportion(press) = segment_3_count(press) / duration_count(press);
            segment_4_proportion(press) = segment_4_count(press) / duration_count(press);
            
            % baseline
            peri_event_bincount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).bincount(press,:);
            Baseline_end_time = (Day.Mouse(1).Session.base_time_end*1000);
            Baseline_end_ts = LP_ON_ts(press) + Day.Mouse(1).Session.base_time_end;
            Baseline_end_idx = find(PETH_time == Baseline_end_time);
            length_in_ms = Lengths(press)*1000;
            Baseline_start_time = Baseline_end_time - length_in_ms;
            if Baseline_start_time < (Day.Mouse(1).Session.base_time_start*1000) % if lever press exceeds 8 seconds (-2 to -10 window)
                Baseline_start_time = Day.Mouse(1).Session.base_time_start*1000;
            end
        %    Baseline_start_idx = nearestpoint(Baseline_start_time, PETH_time);
            Baseline_start_ts = Baseline_end_ts - Lengths(press);
        %    baseline_window = peri_event_bincount(Baseline_start_idx:Baseline_end_idx);
            % Count spikes in baseline period of the same length as lever
            % press duration
            spikes_within_baseline = sum((spike_ts < Baseline_end_ts) & (spike_ts >= Baseline_start_ts));
            baseline_rate(press) = spikes_within_baseline / Lengths(press);
        end
        %% Baseline (all Lps)
        mu = mean(baseline_rate);
        sigma = std(baseline_rate);
        duration_rate_z = (duration_rate - mu) ./  sigma;
        %% Baseline (quantile)
        for curr_quant_id = 1:4
            quant_idx = find(quant_id == curr_quant_id);
            baseline_quant = baseline_rate(quant_idx);
            duration_rate_quant = duration_rate(quant_idx);
            segment_1_rate_quant = segment_1_rate(quant_idx);
            segment_2_rate_quant = segment_2_rate(quant_idx);
            segment_3_rate_quant = segment_3_rate(quant_idx);
            segment_4_rate_quant = segment_4_rate(quant_idx);
            mu = mean(baseline_quant);
            sigma = std(baseline_quant);
            quant_rate_z(quant_idx) = (duration_rate_quant - mu) ./  sigma;
            quant_rate_segment_1_z(quant_idx) = (segment_1_rate_quant - mu) ./  sigma;
            quant_rate_segment_2_z(quant_idx) = (segment_2_rate_quant - mu) ./  sigma;
            quant_rate_segment_3_z(quant_idx) = (segment_3_rate_quant - mu) ./  sigma;
            quant_rate_segment_4_z(quant_idx) = (segment_4_rate_quant - mu) ./  sigma;
        end
        %% Organize for table
        Duration = Lengths;
        QuantID = quant_id;
        HoldCount = duration_count';
        HoldRate = duration_rate';
        HoldRate_Z = duration_rate_z';
        Quant_Rate_Z = quant_rate_z';
        Quant_Rate_Z_Seg_1 = quant_rate_segment_1_z';
        Quant_Rate_Z_Seg_2 = quant_rate_segment_2_z';
        Quant_Rate_Z_Seg_3 = quant_rate_segment_3_z';
        Quant_Rate_Z_Seg_4 = quant_rate_segment_4_z';
        HoldBaselineRate = baseline_rate;
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_ON_up_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Up_Units_Array = [LP_ON_Up_Units_Array; Duration HoldCount QuantID  segment_1_proportion segment_2_proportion segment_3_proportion segment_4_proportion,...
            HoldRate HoldRate_Z Quant_Rate_Z Quant_Rate_Z_Seg_1 Quant_Rate_Z_Seg_2 Quant_Rate_Z_Seg_3 Quant_Rate_Z_Seg_4 HoldBaselineRate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_up_unit  = curr_LP_ON_up_unit + 1;
        
    end
    %% Sig Unit Indices UPMODULATED LP DOWN
    for unit = LP_ON_Down_Sig_Units_Idx
        spike_ts = Day.Mouse(mouse).Session.ValidUnitData{unit};
        baseline_rate = nan(size(Lengths));
        duration_rate_z = nan(size(Lengths))';
        quant_rate_z = nan(size(Lengths))';
        quant_rate_segment_1_z = nan(size(Lengths))';
        quant_rate_segment_2_z = nan(size(Lengths))';
        quant_rate_segment_3_z = nan(size(Lengths))';
        quant_rate_segment_4_z = nan(size(Lengths))';
        duration_rate = nan(size(Lengths))';
        duration_count = nan(size(Lengths))';
        segment_1_rate = nan(size(Lengths)); segment_2_rate = nan(size(Lengths)); segment_3_rate = nan(size(Lengths)); segment_4_rate = nan(size(Lengths));
        segment_1_count = nan(size(Lengths));  segment_2_count = nan(size(Lengths)); segment_3_count = nan(size(Lengths)); segment_4_count = nan(size(Lengths));
        segment_1_proportion = nan(size(Lengths));  segment_2_proportion = nan(size(Lengths)); segment_3_proportion = nan(size(Lengths)); segment_4_proportion = nan(size(Lengths));
        for press = 1:length(Lengths) % for each lever press
            spikes_within_press = spike_ts(find((spike_ts < LP_OFF_ts(press)) & (spike_ts >= LP_ON_ts(press))));
            duration_count(press) = sum((spikes_within_press < LP_OFF_ts(press)) & (spikes_within_press >= LP_ON_ts(press)));
            duration_rate(press) = duration_count(press) / Lengths(press);
            segment_1_count(press) = sum((spikes_within_press < segment_1(press,2)) & (spikes_within_press >= segment_1(press,1)));
            segment_1_rate(press) =  segment_1_count(press) / segment_time(press);
            segment_2_count(press) = sum((spikes_within_press < segment_2(press,2)) & (spikes_within_press >= segment_2(press,1)));
            segment_2_rate(press) =  segment_2_count(press) / segment_time(press);
            segment_3_count(press) = sum((spikes_within_press < segment_3(press,2)) & (spikes_within_press >= segment_3(press,1)));
            segment_3_rate(press) =  segment_3_count(press) / segment_time(press);
            segment_4_count(press) = sum((spikes_within_press < segment_4(press,2)) & (spikes_within_press >= segment_4(press,1)));
            segment_4_rate(press) =  segment_4_count(press) / segment_time(press);
            
            
            % proportions
            segment_1_proportion(press) = segment_1_count(press) / duration_count(press);
            segment_2_proportion(press) = segment_2_count(press) / duration_count(press);
            segment_3_proportion(press) = segment_3_count(press) / duration_count(press);
            segment_4_proportion(press) = segment_4_count(press) / duration_count(press);
            
            % baseline
            peri_event_bincount = Day.Mouse(mouse).Session.Events.LPON.PETH_data(unit).bincount(press,:);
            Baseline_end_time = (Day.Mouse(1).Session.base_time_end*1000);
            Baseline_end_ts = LP_ON_ts(press) + Day.Mouse(1).Session.base_time_end;
            Baseline_end_idx = find(PETH_time == Baseline_end_time);
            length_in_ms = Lengths(press)*1000;
            Baseline_start_time = Baseline_end_time - length_in_ms;
            if Baseline_start_time < (Day.Mouse(1).Session.base_time_start*1000) % if lever press exceeds 8 seconds (-2 to -10 window)
                Baseline_start_time = Day.Mouse(1).Session.base_time_start*1000;
            end
         %   Baseline_start_idx = nearestpoint(Baseline_start_time, PETH_time);
            Baseline_start_ts = Baseline_end_ts - Lengths(press);
          %  baseline_window = peri_event_bincount(Baseline_start_idx:Baseline_end_idx);
            % Count spikes in baseline period of the same length as lever
            % press duration
            spikes_within_baseline = sum((spike_ts < Baseline_end_ts) & (spike_ts >= Baseline_start_ts));
            baseline_rate(press) = spikes_within_baseline / Lengths(press);
        end
        %% Baseline (all Lps)
        mu = mean(baseline_rate);
        sigma = std(baseline_rate);
        duration_rate_z = (duration_rate - mu) ./  sigma;
        %% Baseline (quantile)
        for curr_quant_id = 1:4
            quant_idx = find(quant_id == curr_quant_id);
            baseline_quant = baseline_rate(quant_idx);
            duration_rate_quant = duration_rate(quant_idx);
            segment_1_rate_quant = segment_1_rate(quant_idx);
            segment_2_rate_quant = segment_2_rate(quant_idx);
            segment_3_rate_quant = segment_3_rate(quant_idx);
            segment_4_rate_quant = segment_4_rate(quant_idx);
            mu = mean(baseline_quant);
            sigma = std(baseline_quant);
            quant_rate_z(quant_idx) = (duration_rate_quant - mu) ./  sigma;
            quant_rate_segment_1_z(quant_idx) = (segment_1_rate_quant - mu) ./  sigma;
            quant_rate_segment_2_z(quant_idx) = (segment_2_rate_quant - mu) ./  sigma;
            quant_rate_segment_3_z(quant_idx) = (segment_3_rate_quant - mu) ./  sigma;
            quant_rate_segment_4_z(quant_idx) = (segment_4_rate_quant - mu) ./  sigma;
        end
        %% Organize for table
        Duration = Lengths;
        QuantID = quant_id;
        HoldCount = duration_count';
        HoldRate = duration_rate';
        HoldRate_Z = duration_rate_z';
        Quant_Rate_Z = quant_rate_z';
        Quant_Rate_Z_Seg_1 = quant_rate_segment_1_z';
        Quant_Rate_Z_Seg_2 = quant_rate_segment_2_z';
        Quant_Rate_Z_Seg_3 = quant_rate_segment_3_z';
        Quant_Rate_Z_Seg_4 = quant_rate_segment_4_z';
        HoldBaselineRate = baseline_rate;
        Mouse = Total_LPs*curr_mouse;
        Session = Total_LPs*session;
        Unit = Total_LPs*curr_LP_ON_down_unit;
        True_Unit = Total_LPs*unit;
        File = Total_LPs*mouse;
        
        % Concatenate Information into Arracy
        LP_ON_Down_Units_Array = [LP_ON_Down_Units_Array; Duration HoldCount QuantID  segment_1_proportion segment_2_proportion segment_3_proportion segment_4_proportion,...
            HoldRate HoldRate_Z Quant_Rate_Z Quant_Rate_Z_Seg_1 Quant_Rate_Z_Seg_2 Quant_Rate_Z_Seg_3 Quant_Rate_Z_Seg_4 HoldBaselineRate Mouse Session Unit True_Unit File];
        % Update Unit Counter
        curr_LP_ON_down_unit  = curr_LP_ON_down_unit + 1;
        
    end
end
%% Make Table
Duration_All_Units_All_LPs = array2table(All_Units_Array,'VariableNames',{'Duration','HoldCount', 'QuantID', 'segment_1_Proportion', 'segment_2_Proportion',...
    'segment_3_Proportion', 'segment_4_Proportion', 'HoldRate', 'HoldRate_Z', 'Quant_Rate_Z', 'Quant_Rate_Z_Seg_1', 'Quant_Rate_Z_Seg_2', 'Quant_Rate_Z_Seg_3', 'Quant_Rate_Z_Seg_4', 'HoldBaselineRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

Duration_All_Units_Spike_LPs = Duration_All_Units_All_LPs(find(Duration_All_Units_All_LPs.HoldCount),:);

Duration_Up_Units_All_LPs = array2table(LP_ON_Up_Units_Array,'VariableNames',{'Duration','HoldCount', 'QuantID', 'segment_1_Proportion', 'segment_2_Proportion',...
    'segment_3_Proportion', 'segment_4_Proportion', 'HoldRate', 'HoldRate_Z', 'Quant_Rate_Z', 'Quant_Rate_Z_Seg_1', 'Quant_Rate_Z_Seg_2', 'Quant_Rate_Z_Seg_3', 'Quant_Rate_Z_Seg_4', 'HoldBaselineRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

Duration_Up_Units_Spike_LPs = Duration_Up_Units_All_LPs(find(Duration_Up_Units_All_LPs.HoldCount),:);

Duration_Down_Units_All_LPs = array2table(LP_ON_Down_Units_Array,'VariableNames',{'Duration','HoldCount', 'QuantID', 'segment_1_Proportion', 'segment_2_Proportion',...
    'segment_3_Proportion', 'segment_4_Proportion', 'HoldRate', 'HoldRate_Z', 'Quant_Rate_Z', 'Quant_Rate_Z_Seg_1', 'Quant_Rate_Z_Seg_2', 'Quant_Rate_Z_Seg_3', 'Quant_Rate_Z_Seg_4', 'HoldBaselineRate', 'Mouse','Session','Unit', 'True_Unit', 'File'});

Duration_Down_Units_Spike_LPs = Duration_Down_Units_All_LPs(find(Duration_Down_Units_All_LPs.HoldCount),:);



Durations.Duration_All_Units_All_LPs = Duration_All_Units_All_LPs;
Durations.Duration_All_Units_Spike_LPs = Duration_All_Units_Spike_LPs;

Durations.Duration_Up_Units_All_LPs = Duration_Up_Units_All_LPs;
Durations.Duration_Up_Units_Spike_LPs = Duration_Up_Units_Spike_LPs;

Durations.Duration_Down_Units_All_LPs = Duration_Down_Units_All_LPs;
Durations.Duration_Down_Units_Spike_LPs = Duration_Down_Units_Spike_LPs;


%% Proportions & Quantile Means: Up-Modulated
    seg_1_prop_mean = [];
    seg_2_prop_mean = [];
    seg_3_prop_mean = [];
    seg_4_prop_mean = [];
    seg_1_prop_mean_succ = [];
    seg_2_prop_mean_succ = [];
    seg_3_prop_mean_succ = [];
    seg_4_prop_mean_succ = [];
    quant_1_All_LPs_mean = [];
    quant_2_All_LPs_mean = [];
    quant_3_All_LPs_mean = [];
    quant_4_All_LPs_mean = [];
    quant_1_Spike_LPs_mean = [];
    quant_2_Spike_LPs_mean = [];
    quant_3_Spike_LPs_mean = [];
    quant_4_Spike_LPs_mean = [];
    quant_1_All_LPs_seg_1_mean = [];
    quant_2_All_LPs_seg_1_mean = [];
    quant_3_All_LPs_seg_1_mean = [];
    quant_4_All_LPs_seg_1_mean = [];
    quant_1_All_LPs_seg_2_mean = [];
    quant_2_All_LPs_seg_2_mean = [];
    quant_3_All_LPs_seg_2_mean = [];
    quant_4_All_LPs_seg_2_mean = [];
    quant_1_All_LPs_seg_3_mean = [];
    quant_2_All_LPs_seg_3_mean = [];
    quant_3_All_LPs_seg_3_mean = [];
    quant_4_All_LPs_seg_3_mean = [];
    quant_1_All_LPs_seg_4_mean = [];
    quant_2_All_LPs_seg_4_mean = [];
    quant_3_All_LPs_seg_4_mean = [];
    quant_4_All_LPs_seg_4_mean = [];
    
    quant_1_Spike_LPs_seg_1_mean = [];
    quant_2_Spike_LPs_seg_1_mean = [];
    quant_3_Spike_LPs_seg_1_mean = [];
    quant_4_Spike_LPs_seg_1_mean = [];
    quant_1_Spike_LPs_seg_2_mean = [];
    quant_2_Spike_LPs_seg_2_mean = [];
    quant_3_Spike_LPs_seg_2_mean = [];
    quant_4_Spike_LPs_seg_2_mean = [];
    quant_1_Spike_LPs_seg_3_mean = [];
    quant_2_Spike_LPs_seg_3_mean = [];
    quant_3_Spike_LPs_seg_3_mean = [];
    quant_4_Spike_LPs_seg_3_mean = [];
    quant_1_Spike_LPs_seg_4_mean = [];
    quant_2_Spike_LPs_seg_4_mean = [];
    quant_3_Spike_LPs_seg_4_mean = [];
    quant_4_Spike_LPs_seg_4_mean = [];
    
    unit_proportion = [];
    sig_unit_indices = [];
    unique_mice = unique(Durations.Duration_Up_Units_All_LPs.File)';
    for file = unique_mice
        mouse_data_all = Durations.Duration_Up_Units_All_LPs(find(Durations.Duration_Up_Units_All_LPs.File == file),:);
        mouse_data_spike = Durations.Duration_Up_Units_Spike_LPs(find(Durations.Duration_Up_Units_Spike_LPs.File == file),:);
        Up_idx = unique(mouse_data_all.True_Unit)';
        sig_unit_indices = [sig_unit_indices Up_idx];
        for unit = Up_idx
            % Proportion (minimum 1 spike in duration)
            within_unit_data_spikes = mouse_data_spike(find(mouse_data_spike.True_Unit == unit),:);
            seg_1_prop_mean = [seg_1_prop_mean; mean(within_unit_data_spikes.segment_1_Proportion)];
            seg_2_prop_mean = [seg_2_prop_mean; mean(within_unit_data_spikes.segment_2_Proportion)];
            seg_3_prop_mean = [seg_3_prop_mean; mean(within_unit_data_spikes.segment_3_Proportion)];
            seg_4_prop_mean = [seg_4_prop_mean; mean(within_unit_data_spikes.segment_4_Proportion)];
            
            % Proportion (minimum 1 spike in duration) successess
            success_idx =  find(within_unit_data_spikes.Duration >= 1.6);
            seg_1_prop_mean_succ = [seg_1_prop_mean_succ; mean(within_unit_data_spikes.segment_1_Proportion(success_idx,:))];
            seg_2_prop_mean_succ = [seg_2_prop_mean_succ; mean(within_unit_data_spikes.segment_2_Proportion(success_idx,:))];
            seg_3_prop_mean_succ = [seg_3_prop_mean_succ; mean(within_unit_data_spikes.segment_3_Proportion(success_idx,:))];
            seg_4_prop_mean_succ = [seg_4_prop_mean_succ; mean(within_unit_data_spikes.segment_4_Proportion(success_idx,:))];
            
            % Quantile (all lever presses)
            within_unit_data_all = mouse_data_all(find(mouse_data_all.True_Unit == unit),:);
            quant_1_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 1),:);
            quant_2_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 2),:);
            quant_3_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 3),:);
            quant_4_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 4),:);
            
            quant_1_All_LPs_mean = [quant_1_All_LPs_mean; mean(quant_1_All_LPs.Quant_Rate_Z)];
            quant_2_All_LPs_mean = [quant_2_All_LPs_mean; mean(quant_2_All_LPs.Quant_Rate_Z)];
            quant_3_All_LPs_mean = [quant_3_All_LPs_mean; mean(quant_3_All_LPs.Quant_Rate_Z)];
            quant_4_All_LPs_mean = [quant_4_All_LPs_mean; mean(quant_4_All_LPs.Quant_Rate_Z)];
            
            % Quantile (minimum 1 spike in duration)
            quant_1_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 1),:);
            quant_2_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 2),:);
            quant_3_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 3),:);
            quant_4_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 4),:);
            
            quant_1_Spike_LPs_mean = [quant_1_Spike_LPs_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z)];
            quant_2_Spike_LPs_mean = [quant_2_Spike_LPs_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z)];
            quant_3_Spike_LPs_mean = [quant_3_Spike_LPs_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z)];
            quant_4_Spike_LPs_mean = [quant_4_Spike_LPs_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z)];
            
            % Quantile (all lever presses) Segmented
            quant_1_All_LPs_seg_1_mean = [quant_1_All_LPs_seg_1_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_2_All_LPs_seg_1_mean = [quant_2_All_LPs_seg_1_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_3_All_LPs_seg_1_mean = [quant_3_All_LPs_seg_1_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_4_All_LPs_seg_1_mean = [quant_4_All_LPs_seg_1_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_1_All_LPs_seg_2_mean = [quant_1_All_LPs_seg_2_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_2_All_LPs_seg_2_mean = [quant_2_All_LPs_seg_2_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_3_All_LPs_seg_2_mean = [quant_3_All_LPs_seg_2_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_4_All_LPs_seg_2_mean = [quant_4_All_LPs_seg_2_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_1_All_LPs_seg_3_mean = [quant_1_All_LPs_seg_3_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_2_All_LPs_seg_3_mean = [quant_2_All_LPs_seg_3_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_3_All_LPs_seg_3_mean = [quant_3_All_LPs_seg_3_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_4_All_LPs_seg_3_mean = [quant_4_All_LPs_seg_3_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_1_All_LPs_seg_4_mean = [quant_1_All_LPs_seg_4_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_2_All_LPs_seg_4_mean = [quant_2_All_LPs_seg_4_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_3_All_LPs_seg_4_mean = [quant_3_All_LPs_seg_4_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_4_All_LPs_seg_4_mean = [quant_4_All_LPs_seg_4_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_4)];
            
            % Quantile (minimum 1 spike in duration) Segmented
            quant_1_Spike_LPs_seg_1_mean = [quant_1_Spike_LPs_seg_1_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_2_Spike_LPs_seg_1_mean = [quant_2_Spike_LPs_seg_1_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_3_Spike_LPs_seg_1_mean = [quant_3_Spike_LPs_seg_1_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_4_Spike_LPs_seg_1_mean = [quant_4_Spike_LPs_seg_1_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_1_Spike_LPs_seg_2_mean = [quant_1_Spike_LPs_seg_2_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_2_Spike_LPs_seg_2_mean = [quant_2_Spike_LPs_seg_2_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_3_Spike_LPs_seg_2_mean = [quant_3_Spike_LPs_seg_2_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_4_Spike_LPs_seg_2_mean = [quant_4_Spike_LPs_seg_2_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_1_Spike_LPs_seg_3_mean = [quant_1_Spike_LPs_seg_3_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_2_Spike_LPs_seg_3_mean = [quant_2_Spike_LPs_seg_3_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_3_Spike_LPs_seg_3_mean = [quant_3_Spike_LPs_seg_3_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_4_Spike_LPs_seg_3_mean = [quant_4_Spike_LPs_seg_3_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_1_Spike_LPs_seg_4_mean = [quant_1_Spike_LPs_seg_4_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_2_Spike_LPs_seg_4_mean = [quant_2_Spike_LPs_seg_4_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_3_Spike_LPs_seg_4_mean = [quant_3_Spike_LPs_seg_4_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_4_Spike_LPs_seg_4_mean = [quant_4_Spike_LPs_seg_4_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_4)];
            
            
            % Proportion of Lever Presses that spikes within that unit
            unit_proportion = [unit_proportion; length(find(within_unit_data_all.HoldCount == 0)) / length(within_unit_data_all.HoldCount)];
            
            
        end
    end

up_array_prop = [seg_1_prop_mean seg_2_prop_mean seg_3_prop_mean seg_4_prop_mean sig_unit_indices'];
Duration_Up_Units_Segment_Proportion_Means = array2table(up_array_prop,'VariableNames', {'Seg1', 'Seg2', 'Seg3', 'Seg4', 'SigUnitID'});

up_array_prop_succ = [seg_1_prop_mean_succ seg_2_prop_mean_succ seg_3_prop_mean_succ seg_4_prop_mean_succ sig_unit_indices'];
Duration_Up_Units_Segment_Proportion_Means_Succ = array2table(up_array_prop_succ,'VariableNames', {'Seg1', 'Seg2', 'Seg3', 'Seg4', 'SigUnitID'});

up_array_quant = [quant_1_All_LPs_mean quant_2_All_LPs_mean quant_3_All_LPs_mean quant_4_All_LPs_mean sig_unit_indices' unit_proportion];
Duration_Up_Units_Quantile_Means = array2table(up_array_quant,'VariableNames', {'Quant1', 'Quant2', 'Quant3', 'Quant4', 'SigUnitID', 'UnitProp'});

up_array_quant_min_spike = [quant_1_Spike_LPs_mean quant_2_Spike_LPs_mean quant_3_Spike_LPs_mean quant_4_Spike_LPs_mean sig_unit_indices' unit_proportion];
Duration_Up_Units_Quantile_Spikes_Means = array2table(up_array_quant_min_spike,'VariableNames', {'Quant1', 'Quant2', 'Quant3', 'Quant4', 'SigUnitID', 'UnitProp'});

up_array_quant_segment = [quant_1_All_LPs_seg_1_mean quant_1_All_LPs_seg_2_mean quant_1_All_LPs_seg_3_mean quant_1_All_LPs_seg_4_mean...
    quant_2_All_LPs_seg_1_mean quant_2_All_LPs_seg_2_mean quant_2_All_LPs_seg_3_mean quant_2_All_LPs_seg_4_mean...
    quant_3_All_LPs_seg_1_mean quant_3_All_LPs_seg_2_mean quant_3_All_LPs_seg_3_mean quant_3_All_LPs_seg_4_mean...
    quant_4_All_LPs_seg_1_mean quant_4_All_LPs_seg_2_mean quant_4_All_LPs_seg_3_mean quant_4_All_LPs_seg_4_mean...
    sig_unit_indices' unit_proportion];
Duration_Up_Units_Quantile_Segment_Means = array2table(up_array_quant_segment,'VariableNames', {'Quant1_Seg1', 'Quant1_Seg2', 'Quant1_Seg3', 'Quant1_Seg4',...
    'Quant2_Seg1', 'Quant2_Seg2', 'Quant2_Seg3', 'Quant2_Seg4',...
    'Quant3_Seg1', 'Quant3_Seg2', 'Quant3_Seg3', 'Quant3_Seg4',...
    'Quant4_Seg1', 'Quant4_Seg2', 'Quant4_Seg3', 'Quant4_Seg4',...
    'SigUnitID', 'UnitProp'});

up_array_quant_segment_min_spike = [quant_1_Spike_LPs_seg_1_mean quant_1_Spike_LPs_seg_2_mean quant_1_Spike_LPs_seg_3_mean quant_1_Spike_LPs_seg_4_mean...
    quant_2_Spike_LPs_seg_1_mean quant_2_Spike_LPs_seg_2_mean quant_2_Spike_LPs_seg_3_mean quant_2_Spike_LPs_seg_4_mean...
    quant_3_Spike_LPs_seg_1_mean quant_3_Spike_LPs_seg_2_mean quant_3_Spike_LPs_seg_3_mean quant_3_Spike_LPs_seg_4_mean...
    quant_4_Spike_LPs_seg_1_mean quant_4_Spike_LPs_seg_2_mean quant_4_Spike_LPs_seg_3_mean quant_4_Spike_LPs_seg_4_mean...
    sig_unit_indices' unit_proportion];
Duration_Up_Units_Quantile_Segment_Spikes_Means = array2table(up_array_quant_segment_min_spike,'VariableNames', {'Quant1_Seg1', 'Quant1_Seg2', 'Quant1_Seg3', 'Quant1_Seg4',...
    'Quant2_Seg1', 'Quant2_Seg2', 'Quant2_Seg3', 'Quant2_Seg4',...
    'Quant3_Seg1', 'Quant3_Seg2', 'Quant3_Seg3', 'Quant3_Seg4',...
    'Quant4_Seg1', 'Quant4_Seg2', 'Quant4_Seg3', 'Quant4_Seg4',...
    'SigUnitID', 'UnitProp'});


%% Proportions & Quantile Means: Down-Modulated
    seg_1_prop_mean = [];
    seg_2_prop_mean = [];
    seg_3_prop_mean = [];
    seg_4_prop_mean = [];
    seg_1_prop_mean_succ = [];
    seg_2_prop_mean_succ = [];
    seg_3_prop_mean_succ = [];
    seg_4_prop_mean_succ = [];
    quant_1_All_LPs_mean = [];
    quant_2_All_LPs_mean = [];
    quant_3_All_LPs_mean = [];
    quant_4_All_LPs_mean = [];
    quant_1_Spike_LPs_mean = [];
    quant_2_Spike_LPs_mean = [];
    quant_3_Spike_LPs_mean = [];
    quant_4_Spike_LPs_mean = [];
    quant_1_All_LPs_seg_1_mean = [];
    quant_2_All_LPs_seg_1_mean = [];
    quant_3_All_LPs_seg_1_mean = [];
    quant_4_All_LPs_seg_1_mean = [];
    quant_1_All_LPs_seg_2_mean = [];
    quant_2_All_LPs_seg_2_mean = [];
    quant_3_All_LPs_seg_2_mean = [];
    quant_4_All_LPs_seg_2_mean = [];
    quant_1_All_LPs_seg_3_mean = [];
    quant_2_All_LPs_seg_3_mean = [];
    quant_3_All_LPs_seg_3_mean = [];
    quant_4_All_LPs_seg_3_mean = [];
    quant_1_All_LPs_seg_4_mean = [];
    quant_2_All_LPs_seg_4_mean = [];
    quant_3_All_LPs_seg_4_mean = [];
    quant_4_All_LPs_seg_4_mean = [];
    
    quant_1_Spike_LPs_seg_1_mean = [];
    quant_2_Spike_LPs_seg_1_mean = [];
    quant_3_Spike_LPs_seg_1_mean = [];
    quant_4_Spike_LPs_seg_1_mean = [];
    quant_1_Spike_LPs_seg_2_mean = [];
    quant_2_Spike_LPs_seg_2_mean = [];
    quant_3_Spike_LPs_seg_2_mean = [];
    quant_4_Spike_LPs_seg_2_mean = [];
    quant_1_Spike_LPs_seg_3_mean = [];
    quant_2_Spike_LPs_seg_3_mean = [];
    quant_3_Spike_LPs_seg_3_mean = [];
    quant_4_Spike_LPs_seg_3_mean = [];
    quant_1_Spike_LPs_seg_4_mean = [];
    quant_2_Spike_LPs_seg_4_mean = [];
    quant_3_Spike_LPs_seg_4_mean = [];
    quant_4_Spike_LPs_seg_4_mean = [];
    unit_proportion = [];
    sig_unit_indices = [];
    unique_mice = unique(Durations.Duration_Down_Units_All_LPs.File)';
    for file = unique_mice
        mouse_data_all = Durations.Duration_Down_Units_All_LPs(find(Durations.Duration_Down_Units_All_LPs.File == file),:);
        mouse_data_spike = Durations.Duration_Down_Units_Spike_LPs(find(Durations.Duration_Down_Units_Spike_LPs.File == file),:);
        Down_idx = unique(mouse_data_all.True_Unit)';
        sig_unit_indices = [sig_unit_indices Down_idx];
        for unit = Down_idx
            % Proportion (minimum 1 spike in duration)
            within_unit_data_spikes = mouse_data_spike(find(mouse_data_spike.True_Unit == unit),:);
            seg_1_prop_mean = [seg_1_prop_mean; mean(within_unit_data_spikes.segment_1_Proportion)];
            seg_2_prop_mean = [seg_2_prop_mean; mean(within_unit_data_spikes.segment_2_Proportion)];
            seg_3_prop_mean = [seg_3_prop_mean; mean(within_unit_data_spikes.segment_3_Proportion)];
            seg_4_prop_mean = [seg_4_prop_mean; mean(within_unit_data_spikes.segment_4_Proportion)];
            
            % Proportion (minimum 1 spike in duration) successess
            success_idx =  find(within_unit_data_spikes.Duration >= 1.6);
            seg_1_prop_mean_succ = [seg_1_prop_mean_succ; mean(within_unit_data_spikes.segment_1_Proportion(success_idx,:))];
            seg_2_prop_mean_succ = [seg_2_prop_mean_succ; mean(within_unit_data_spikes.segment_2_Proportion(success_idx,:))];
            seg_3_prop_mean_succ = [seg_3_prop_mean_succ; mean(within_unit_data_spikes.segment_3_Proportion(success_idx,:))];
            seg_4_prop_mean_succ = [seg_4_prop_mean_succ; mean(within_unit_data_spikes.segment_4_Proportion(success_idx,:))];
            
            % Quantile (all lever presses)
            within_unit_data_all = mouse_data_all(find(mouse_data_all.True_Unit == unit),:);
            quant_1_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 1),:);
            quant_2_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 2),:);
            quant_3_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 3),:);
            quant_4_All_LPs = within_unit_data_all(find(within_unit_data_all.QuantID == 4),:);
            
            
            quant_1_All_LPs_mean = [quant_1_All_LPs_mean; mean(quant_1_All_LPs.Quant_Rate_Z)];
            quant_2_All_LPs_mean = [quant_2_All_LPs_mean; mean(quant_2_All_LPs.Quant_Rate_Z)];
            quant_3_All_LPs_mean = [quant_3_All_LPs_mean; mean(quant_3_All_LPs.Quant_Rate_Z)];
            quant_4_All_LPs_mean = [quant_4_All_LPs_mean; mean(quant_4_All_LPs.Quant_Rate_Z)];
            
            % Quantile (minimum 1 spike in duration)
            quant_1_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 1),:);
            quant_2_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 2),:);
            quant_3_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 3),:);
            quant_4_Spike_LPs = within_unit_data_spikes(find(within_unit_data_spikes.QuantID == 4),:);
            
            quant_1_Spike_LPs_mean = [quant_1_Spike_LPs_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z)];
            quant_2_Spike_LPs_mean = [quant_2_Spike_LPs_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z)];
            quant_3_Spike_LPs_mean = [quant_3_Spike_LPs_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z)];
            quant_4_Spike_LPs_mean = [quant_4_Spike_LPs_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z)];
            
            % Quantile (all lever presses) Segmented
            quant_1_All_LPs_seg_1_mean = [quant_1_All_LPs_seg_1_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_2_All_LPs_seg_1_mean = [quant_2_All_LPs_seg_1_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_3_All_LPs_seg_1_mean = [quant_3_All_LPs_seg_1_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_4_All_LPs_seg_1_mean = [quant_4_All_LPs_seg_1_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_1)];
            quant_1_All_LPs_seg_2_mean = [quant_1_All_LPs_seg_2_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_2_All_LPs_seg_2_mean = [quant_2_All_LPs_seg_2_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_3_All_LPs_seg_2_mean = [quant_3_All_LPs_seg_2_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_4_All_LPs_seg_2_mean = [quant_4_All_LPs_seg_2_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_2)];
            quant_1_All_LPs_seg_3_mean = [quant_1_All_LPs_seg_3_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_2_All_LPs_seg_3_mean = [quant_2_All_LPs_seg_3_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_3_All_LPs_seg_3_mean = [quant_3_All_LPs_seg_3_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_4_All_LPs_seg_3_mean = [quant_4_All_LPs_seg_3_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_3)];
            quant_1_All_LPs_seg_4_mean = [quant_1_All_LPs_seg_4_mean; mean(quant_1_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_2_All_LPs_seg_4_mean = [quant_2_All_LPs_seg_4_mean; mean(quant_2_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_3_All_LPs_seg_4_mean = [quant_3_All_LPs_seg_4_mean; mean(quant_3_All_LPs.Quant_Rate_Z_Seg_4)];
            quant_4_All_LPs_seg_4_mean = [quant_4_All_LPs_seg_4_mean; mean(quant_4_All_LPs.Quant_Rate_Z_Seg_4)];
            
            % Quantile (minimum 1 spike in duration) Segmented
            quant_1_Spike_LPs_seg_1_mean = [quant_1_Spike_LPs_seg_1_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_2_Spike_LPs_seg_1_mean = [quant_2_Spike_LPs_seg_1_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_3_Spike_LPs_seg_1_mean = [quant_3_Spike_LPs_seg_1_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_4_Spike_LPs_seg_1_mean = [quant_4_Spike_LPs_seg_1_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_1)];
            quant_1_Spike_LPs_seg_2_mean = [quant_1_Spike_LPs_seg_2_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_2_Spike_LPs_seg_2_mean = [quant_2_Spike_LPs_seg_2_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_3_Spike_LPs_seg_2_mean = [quant_3_Spike_LPs_seg_2_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_4_Spike_LPs_seg_2_mean = [quant_4_Spike_LPs_seg_2_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_2)];
            quant_1_Spike_LPs_seg_3_mean = [quant_1_Spike_LPs_seg_3_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_2_Spike_LPs_seg_3_mean = [quant_2_Spike_LPs_seg_3_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_3_Spike_LPs_seg_3_mean = [quant_3_Spike_LPs_seg_3_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_4_Spike_LPs_seg_3_mean = [quant_4_Spike_LPs_seg_3_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_3)];
            quant_1_Spike_LPs_seg_4_mean = [quant_1_Spike_LPs_seg_4_mean; mean(quant_1_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_2_Spike_LPs_seg_4_mean = [quant_2_Spike_LPs_seg_4_mean; mean(quant_2_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_3_Spike_LPs_seg_4_mean = [quant_3_Spike_LPs_seg_4_mean; mean(quant_3_Spike_LPs.Quant_Rate_Z_Seg_4)];
            quant_4_Spike_LPs_seg_4_mean = [quant_4_Spike_LPs_seg_4_mean; mean(quant_4_Spike_LPs.Quant_Rate_Z_Seg_4)];
            
            % Proportion of Lever Presses that spikes within that unit
            unit_proportion = [unit_proportion; length(find(within_unit_data_all.HoldCount == 0)) / length(within_unit_data_all.HoldCount)];
        end
    end
down_array_prop = [seg_1_prop_mean seg_2_prop_mean seg_3_prop_mean seg_4_prop_mean sig_unit_indices' ];
Duration_Down_Units_Segment_Proportion_Means = array2table(down_array_prop,'VariableNames', {'Seg1', 'Seg2', 'Seg3', 'Seg4', 'SigUnitID'});

down_array_prop_succ = [seg_1_prop_mean_succ seg_2_prop_mean_succ seg_3_prop_mean_succ seg_4_prop_mean_succ sig_unit_indices'];
Duration_Down_Units_Segment_Proportion_Means_Succ = array2table(down_array_prop_succ,'VariableNames', {'Seg1', 'Seg2', 'Seg3', 'Seg4', 'SigUnitID'});

down_array_quant = [quant_1_All_LPs_mean quant_2_All_LPs_mean quant_3_All_LPs_mean quant_4_All_LPs_mean sig_unit_indices' unit_proportion];
Duration_Down_Units_Quantile_Means = array2table(down_array_quant,'VariableNames', {'Quant1', 'Quant2', 'Quant3', 'Quant4', 'SigUnitID', 'UnitProp'});

down_array_quant_min_spike = [quant_1_Spike_LPs_mean quant_2_Spike_LPs_mean quant_3_Spike_LPs_mean quant_4_Spike_LPs_mean sig_unit_indices' unit_proportion];
Duration_Down_Units_Quantile_Spikes_Means = array2table(down_array_quant_min_spike,'VariableNames', {'Quant1', 'Quant2', 'Quant3', 'Quant4', 'SigUnitID', 'UnitProp'});

down_array_quant_segment = [quant_1_All_LPs_seg_1_mean quant_1_All_LPs_seg_2_mean quant_1_All_LPs_seg_3_mean quant_1_All_LPs_seg_4_mean...
    quant_2_All_LPs_seg_1_mean quant_2_All_LPs_seg_2_mean quant_2_All_LPs_seg_3_mean quant_2_All_LPs_seg_4_mean...
    quant_3_All_LPs_seg_1_mean quant_3_All_LPs_seg_2_mean quant_3_All_LPs_seg_3_mean quant_3_All_LPs_seg_4_mean...
    quant_4_All_LPs_seg_1_mean quant_4_All_LPs_seg_2_mean quant_4_All_LPs_seg_3_mean quant_4_All_LPs_seg_4_mean...
    sig_unit_indices' unit_proportion];
Duration_Down_Units_Quantile_Segment_Means = array2table(down_array_quant_segment,'VariableNames', {'Quant1_Seg1', 'Quant1_Seg2', 'Quant1_Seg3', 'Quant1_Seg4',...
    'Quant2_Seg1', 'Quant2_Seg2', 'Quant2_Seg3', 'Quant2_Seg4',...
    'Quant3_Seg1', 'Quant3_Seg2', 'Quant3_Seg3', 'Quant3_Seg4',...
    'Quant4_Seg1', 'Quant4_Seg2', 'Quant4_Seg3', 'Quant4_Seg4',...
    'SigUnitID', 'UnitProp'});

down_array_quant_segment_min_spike = [quant_1_Spike_LPs_seg_1_mean quant_1_Spike_LPs_seg_2_mean quant_1_Spike_LPs_seg_3_mean quant_1_Spike_LPs_seg_4_mean...
    quant_2_Spike_LPs_seg_1_mean quant_2_Spike_LPs_seg_2_mean quant_2_Spike_LPs_seg_3_mean quant_2_Spike_LPs_seg_4_mean...
    quant_3_Spike_LPs_seg_1_mean quant_3_Spike_LPs_seg_2_mean quant_3_Spike_LPs_seg_3_mean quant_3_Spike_LPs_seg_4_mean...
    quant_4_Spike_LPs_seg_1_mean quant_4_Spike_LPs_seg_2_mean quant_4_Spike_LPs_seg_3_mean quant_4_Spike_LPs_seg_4_mean...
    sig_unit_indices' unit_proportion];
Duration_Down_Units_Quantile_Segment_Spikes_Means = array2table(down_array_quant_segment_min_spike,'VariableNames', {'Quant1_Seg1', 'Quant1_Seg2', 'Quant1_Seg3', 'Quant1_Seg4',...
    'Quant2_Seg1', 'Quant2_Seg2', 'Quant2_Seg3', 'Quant2_Seg4',...
    'Quant3_Seg1', 'Quant3_Seg2', 'Quant3_Seg3', 'Quant3_Seg4',...
    'Quant4_Seg1', 'Quant4_Seg2', 'Quant4_Seg3', 'Quant4_Seg4',...
    'SigUnitID', 'UnitProp'});

%% Store in Data Structure
Durations.Duration_Up_Units_Segment_Proportion_Means = Duration_Up_Units_Segment_Proportion_Means;
Durations.Duration_Up_Units_Segment_Proportion_Means_Succ = Duration_Up_Units_Segment_Proportion_Means_Succ;
Durations.Duration_Up_Units_Quantile_Means = Duration_Up_Units_Quantile_Means;
Durations.Duration_Up_Units_Quantile_Spikes_Means = Duration_Up_Units_Quantile_Spikes_Means;

Durations.Duration_Down_Units_Segment_Proportion_Means = Duration_Down_Units_Segment_Proportion_Means;
Durations.Duration_Down_Units_Segment_Proportion_Means_Succ = Duration_Down_Units_Segment_Proportion_Means_Succ;
Durations.Duration_Down_Units_Quantile_Means = Duration_Down_Units_Quantile_Means;
Durations.Duration_Down_Units_Quantile_Spikes_Means = Duration_Down_Units_Quantile_Spikes_Means;


Durations.Duration_Up_Units_Quantile_Segment_Means = Duration_Up_Units_Quantile_Segment_Means;
Durations.Duration_Up_Units_Quantile_Segment_Spike_Means = Duration_Up_Units_Quantile_Segment_Spikes_Means; 
Durations.Duration_Down_Units_Quantile_Segment_Means = Duration_Down_Units_Quantile_Segment_Means;
Durations.Duration_Down_Units_Quantile_Segment_Spike_Means = Duration_Down_Units_Quantile_Segment_Spikes_Means; 
end

