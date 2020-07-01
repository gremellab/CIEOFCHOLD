function [] = Plot_Decoder_Results()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Find files
tic
set(0,'defaultfigurecolor',[1 1 1])
selpath = uigetdir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding');
%selpath = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\1600-Early-Air';
listing = dir(selpath );
MouseFolder = listing(3:end);
size_w_peth = 150;
size_h_peth = 200;
%% Get encoder results
encoder_result_file_names = {};
for folder = 1:length(MouseFolder)
    listing = dir([MouseFolder(folder).folder '\' MouseFolder(folder).name]);
    Encoder_file_listing = listing(3:end);
    encoder_result_file_names{folder,1} = [Encoder_file_listing.folder '\'  Encoder_file_listing.name];
end
errorbar_file_names = encoder_result_file_names;
    %%  12.  Plot the basic results
    % create an object to plot the results
    %plot_obj = plot_standard_results_object(result_names);
    plot_obj = plot_standard_results_object(encoder_result_file_names);
    % put a line at the time when the stimulus was shown
    plot_obj.significant_event_regions = {[2001 2001+1000]};
    plot_obj.significant_event_region_alphas = .3;
    plot_obj.significant_event_region_colors = [.5 .5 .5];
    
    figure('Name',['Decoder: MI'],'NumberTitle','off', 'rend','painters','pos',[100 100 size_w_peth size_h_peth]);
    plot_obj.result_type_to_plot = 6; %MI
    plot_obj.line_width = 2;
    plot_obj.font_size = 8;
    plot_obj.legend_names = {'Air', 'CIE'};
    plot_obj.plot_results;   % actually plot the results
    
    % optional argument, can plot different types of results
    %plot_obj.result_type_to_plot = 2;  % for example, setting this to 2 plots the normalized rank results
    figure('Name',['Decoder: CA'],'NumberTitle','off', 'rend','painters','pos',[100 100 size_w_peth size_h_peth]);
    plot_obj.result_type_to_plot = 1; %MI
    plot_obj.line_width = 2;
    plot_obj.font_size = 8;
    plot_obj.legend_names = {'Air', 'CIE'};
    
    % Errorbar
%     plot_obj.errorbar_file_names = errorbar_file_names;
%     plot_obj.errorbar_type_to_plot = 1;
%     plot_obj.errorbar_transparency_level = .3;
%     plot_obj.errorbar_edge_transparency_level = .3;
    
    plot_obj.plot_results;   % actually plot the results
    

    
    
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

