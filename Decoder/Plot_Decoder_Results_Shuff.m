function [] = Plot_Decoder_Results_Shuff(Decoder_Directory, Shuffled_Decoder_Directory)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Find files
tic
selpath = Decoder_Directory;%uigetdir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding');
%selpath = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\1600-Early-Air';
listing = dir(selpath );
MouseFolder = listing(3:end);
size_w_peth = 150;
size_h_peth = 200;
%% Shuff dirs

    %dir_2 = dir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Decoder_Results\Test_Shuff_2');
    dir_2 = dir(Shuffled_Decoder_Directory);
    dir_2 = dir_2(3:end);
    
%% Get encoder results
encoder_result_file_names = {};
shuff_1_file_names = {};
shuff_2_file_names = {}; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for folder = 1:length(MouseFolder)
    listing = dir([MouseFolder(folder).folder '\' MouseFolder(folder).name]);
    Encoder_file_listing = listing(3:end);
    encoder_result_file_names{folder,1} = [Encoder_file_listing.folder '\'  Encoder_file_listing.name];

%     listing_shuff_1 = dir([dir_1(folder).folder '\' dir_1(folder).name]);
%     Encoder_file_listing_shuff_1 = listing_shuff_1(3:end);
%     shuff_1_file_names{folder,1} = [Encoder_file_listing_shuff_1.folder '\'  Encoder_file_listing_shuff_1.name];
%     
%     listing_shuff_2 = dir([dir_2(folder).folder '\' dir_2(folder).name]);
%     Encoder_file_listing_shuff_2 = listing_shuff_2(3:end);
     shuff_2_file_names{folder,1} = [dir_2(folder).folder '\' dir_2(folder).name]; %%%%%%%%%%%%%%%%%%%%%%
    
end
errorbar_file_names = encoder_result_file_names;
    %%  12.  Plot the basic results
    % create an object to plot the results
    %plot_obj = plot_standard_results_object(result_names);
    plot_obj = plot_standard_results_object(encoder_result_file_names);
    % put a line at the time when the stimulus was shown
    plot_obj.significant_event_regions = {[2001 2001+200]};%1600]};
    plot_obj.significant_event_region_alphas = .3;
    plot_obj.significant_event_region_colors = [.5 .5 .5];
    % Errorbar
%     plot_obj.errorbar_file_names = errorbar_file_names;
%     plot_obj.errorbar_type_to_plot = 2;
    % optional argument, can plot different types of results
        %% Plot shuff
    % create the names of directories that contain the shuffled data for creating null distributions
% (this is a cell array so that multiple p-values are created when comparing results)
pval_dir_name = shuff_2_file_names;%{};%{shuff_1_file_names, shuff_2_file_names}; %%%%%%%%%%%%%%%%%%%%%%
plot_obj.p_values = pval_dir_name; %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use data from all time bins when creating the null distribution
plot_obj.collapse_all_times_when_estimating_pvals = 1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
 % Errorbar
    
    s = figure('Name',['Decoder: MI'],'NumberTitle','off', 'rend','painters','pos',[100 100 size_w_peth size_h_peth]);
    plot_obj.result_type_to_plot = 6; %MI
    plot_obj.line_width = 2;
    plot_obj.font_size = 8;
    plot_obj.legend_names = {'Air', 'CIE'};
    plot_obj.plot_results;   % actually plot the results
    
    t = figure('Name',['Decoder: CA2'],'NumberTitle','off', 'rend','painters','pos',[100 100 size_w_peth size_h_peth]);
    plot_obj.result_type_to_plot = 1; %MI
    plot_obj.line_width = 2;
    plot_obj.font_size = 8;
    plot_obj.legend_names = {'Air', 'CIE'};

    
    % Errorbar
    %plot_obj.errorbar_file_names = errorbar_file_names;
    %plot_obj.errorbar_type_to_plot = 1;
   % plot_obj.errorbar_transparency_level = .3;
    %plot_obj.errorbar_edge_transparency_level = .3;
    plot_obj.plot_results;   % actually plot the results

    %%
    % create the plot results object
% note that this object takes a string in its constructor not a cell array
% clear plot_obj
%  figure('Name',['Decoder: TCT'],'NumberTitle','off', 'rend','painters','pos',[10 10 1200 700]);
% plot_obj = plot_standard_results_TCT_object(encoder_result_file_names);
% 
%  % put a line at the time when the stimulus was shown
% plot_obj.significant_event_times = 5001;
% % display the results
% plot_obj.plot_results;

end

