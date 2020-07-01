%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Using the firing rate vector created by for the PETH
%           it outputs variable SigTime and SigSignal that read out the
%           first time a signigicant change occured and its signal (pos or
%           neg)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PETH_stats] = PETHstatistics_Rolling(Session, PETH, Event_Label, valid_unit_idx, time, Baseline)
sig_window_on = [-1000 0];
sig_window_off = [0 1000];
sig_window_rein = [0 1000];
% Calculate CI thresholds base on baseline window before Lever Press Onset
if strcmp(Event_Label,'Lever Press Onset')
    %T = (Session.base_time_end + abs(Session.base_time_start)) * 1000; %time (in ms) where background is going to be taken from
    %b=R(1:T); %background - from t=1ms to T
    %b =Session.pethdata_all{valid_unit_idx}(1:T);
    %Baseline = PETH(1:find(Session.base_time_end*1000 == time));
    %Baseline = Session.Events.LPON.PETH_data.Baseline;

    PETH_stats.Baseline = Baseline;
    
    %P=mean(b)+2.58*std(b); %P for 99% confidence if df=inf?! why the 2.58? should be straightforward - check!!
    P = mean(Baseline)+2.58*std(Baseline); %P for 99% confidence if df=n-1<=>df=20-1=19 (changed from 2.86)
    N = mean(Baseline)-2.58*std(Baseline); %N for 99% confidence if df=inf
    % n = max(N,0);
    Positive_CI = P;
    Negative_CI = N;
else
    P =  Session.Events.LPON.PETH_stats(valid_unit_idx).Positive_CI;
    N =  Session.Events.LPON.PETH_stats(valid_unit_idx).Negative_CI;
    Positive_CI = P;
    Negative_CI = N;
end
if strcmp(Event_Label,'Reinforcement Onset')
     sig_crit_time = (Session.bin_length * 1000)*5;
else
     sig_crit_time = Session.bin_length * 1000;
end
%% Positive CI
threshold = P;  % CI Threshold
aboveThreshold = (PETH >= threshold);  %where above threshold
%aboveThreshold is a logical array, where 1 when above threshold, 0, below.
%we thus want to calculate the difference between rising and falling edges
aboveThreshold = [false, aboveThreshold, false];  %pad with 0's at ends
edges = diff(aboveThreshold);
rising = find(edges==1);     %rising/falling edges
falling = find(edges==-1);
spanWidth = falling - rising;  %width of span of 1's (above threshold)
wideEnough = spanWidth >= sig_crit_time;   % greater than or equal to 20 1 ms bins
startPos = rising(wideEnough);    %start of each span
endPos = falling(wideEnough)-1;   %end of each span
%all points which are in the 20-ms span (i.e. between startPos and endPos).
up_modulated_window = cell2mat(arrayfun(@(x,y) x:1:y, startPos, endPos, 'uni', false));
if strcmp(Event_Label,'Reinforcement Onset') % remove sig times before -1000 event onset
    before_onset_idx = up_modulated_window < find(time == sig_window_rein(1));
    up_modulated_window(before_onset_idx) = [];
    after_onset_idx = up_modulated_window > find(time == sig_window_rein(2));
    up_modulated_window(after_onset_idx) = [];
elseif strcmp(Event_Label,'Lever Press Onset') % remove sig times before -1000 and after 3000 ms event onset
    before_onset_idx = up_modulated_window < find(time == sig_window_on(1));
    up_modulated_window(before_onset_idx) = [];
    after_onset_idx = up_modulated_window > find(time == sig_window_on(2));
    up_modulated_window(after_onset_idx) = [];
elseif strcmp(Event_Label,'Lever Press Offset') % remove sig times before -1000 and after 3000 ms event onset
    before_onset_idx = up_modulated_window < find(time == sig_window_off(1));
    up_modulated_window(before_onset_idx) = [];
    after_onset_idx = up_modulated_window > find(time == sig_window_off(2));
    up_modulated_window(after_onset_idx) = [];
end
%% Negative CI
threshold = N; % CI Threshold
belowThreshold = (PETH < threshold);  %where above threshold
%aboveThreshold is a logical array, where 1 when above threshold, 0, below.
%we thus want to calculate the difference between rising and falling edges
belowThreshold = [false, belowThreshold, false];  %pad with 0's at ends
edges = diff(belowThreshold);
rising = find(edges==1);     %rising/falling edges
falling = find(edges==-1);
spanWidth = falling - rising;  %width of span of 1's (above threshold)
wideEnough = spanWidth >= sig_crit_time;   % greater than or equal to 20 1 ms bins
startPos = rising(wideEnough);    %start of each span
endPos = falling(wideEnough)-1;   %end of each span
%all points which are in the 20-ms span (i.e. between startPos and endPos).
down_modulated_window = cell2mat(arrayfun(@(x,y) x:1:y, startPos, endPos, 'uni', false));
if strcmp(Event_Label,'Reinforcement Onset') % remove sig times before -1000  onset
    before_onset_idx = down_modulated_window < find(time == sig_window_rein(1));
    down_modulated_window(before_onset_idx) = [];
    after_onset_idx = down_modulated_window > find(time == sig_window_rein(2));
    down_modulated_window(after_onset_idx) = [];
elseif strcmp(Event_Label,'Lever Press Onset')
    before_onset_idx = down_modulated_window < find(time == sig_window_on(1));
    down_modulated_window(before_onset_idx) = [];
    after_onset_idx = down_modulated_window > find(time == sig_window_on(2));
    down_modulated_window(after_onset_idx) = [];
elseif strcmp(Event_Label,'Lever Press Offset')
    before_onset_idx = down_modulated_window < find(time == sig_window_off(1));
    down_modulated_window(before_onset_idx) = [];
    after_onset_idx = down_modulated_window > find(time == sig_window_off(2));
    down_modulated_window(after_onset_idx) = [];
end
%% Save to Session structure
PETH_stats.Positive_CI = Positive_CI;
PETH_stats.Negative_CI = Negative_CI;
PETH_stats.Up_Mod_Window = up_modulated_window;
PETH_stats.Down_Mod_Window = down_modulated_window;
end