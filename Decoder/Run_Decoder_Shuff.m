function [] = Run_Decoder_Shuff(shuff_num, specific_binned_labels_names, Binned_Directory, Decoder_Destination, Decoder_Shuffled_Destination)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tic
%selpath = uigetdir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding');
%selpath = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\1600-Early-Air';
listing = dir(Binned_Directory);
DayFolder= listing(3:end);

% use 20 cross-validation splits (which means that 19 examples of each object are 
% used for training and 1 example of each object is used for testing)


for folder = 1:2%1:length(DayFolder) %[1:2 6] Performance
    %% Make new folder to put decoder data in
    binned_data_directory_name = [DayFolder(folder).folder '\' DayFolder(folder).name];
    cd(binned_data_directory_name)
    destdirectory = Decoder_Destination;% MouseFolder(folder).name];
    mkdir(destdirectory);   %create the directory
    %% Specify identity labels to decode
    listing = dir(binned_data_directory_name);
    Binned_data_listing = listing(3:end);
    binned_data_file_name = Binned_data_listing.name;
    load(binned_data_file_name);  % load the binned data
    binned_data_file_directory_name = [binned_data_directory_name '\' binned_data_file_name];
    %specific_binned_labels_names = 'Performance';%{'Performance', 'Percentile', 'State', 'State_Performance'};
    %%  5.  Calculate how many times each stimulus has been shown to each neuron
%     for k = 0:60
%         [inds_of_sites_with_at_least_k_repeats, min_num_repeats_all_sites, num_repeats_matrix, label_names_used]...
%             = find_sites_with_k_label_repetitions(binned_labels.Performance, k);
%         num_sites_with_k_repeats(k + 1) = length(inds_of_sites_with_at_least_k_repeats);
%         max_k = max(num_sites_with_k_repeats);
%     end
%     for k = 1:100
%         inds_of_sites_with_at_least_k_repeats = find_sites_with_k_label_repetitions(binned_labels.percentile, k);
%         num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats);
%         max_k = max(num_sites_with_k_repeats);
%     end
   % ds.curr_resample_sites_to_use = inds_of_sites_with_at_least_k_repeats;
    %% create the basic datasource object
    num_cv_splits = 10;%floor(max_k * .2); 
    ds = basic_DS(binned_data_file_directory_name, specific_binned_labels_names,  num_cv_splits);
    %ds.sample_sites_with_replacement
    %ds.create_simultaneously_recorded_populations = 1;
    ds.num_times_to_repeat_each_label_per_cv_split = 1;
    
    %ds.time_periods_to_get_data_from = {[1:22]};  %  a cell array containing vectors that specify which time bins to use from the_data 
    % ds.sites_to_use = find_sites_with_k_label_repetitions(binned_labels.Performance, num_cv_splits);
    %% create a feature preprocess that z-score normalizes each feature
    the_feature_preprocessors{1} = zscore_normalize_FP;
    % other useful options:
    % can include a feature-selection features preprocessor to only use the top k most selective neurons
    % fp = select_or_exclude_top_k_features_FP;
    % fp.num_features_to_use = 25;   % use only the 25 most selective neurons as determined by a univariate one-way ANOVA
    % the_feature_preprocessors{2} = fp;
    %% select a classifier
   % the_classifier = max_correlation_coefficient_CL;
    the_classifier = libsvm_CL;
    % other useful options:
    % use a poisson naive bayes classifier (note: the data needs to be loaded as spike counts to use this classifier)
    %the_classifier = poisson_naive_bayes_CL;
    % use a support vector machine (see the documentation for all the optional parameters for this classifier)
    %the_classifier = libsvm_CL;
    %% shuffle
    if shuff_num == 0
        
        'Currently running regular decoding results'
        
        % if running the regular results, create the regular cross-validator
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        the_cross_validator.num_resample_runs = 500;  % usually more than 2 resample runs are used to get more accurate results, but to save time we are using a small number here
        % other useful options:
        % can greatly speed up the run-time of the analysis by not creating a full TCT matrix (i.e., only trainging and testing the classifier on the same time bin)
        the_cross_validator.test_only_at_training_times = 1;
        % the name of where to save the results for regular (non-shuffled) decoding results as before

        save_file_name = [destdirectory '\' DayFolder(folder).name '_decoding_results'];
        
    else
        
        'Currently running shuffled label decoding results (data for the null distribution)'
        
        ds.randomly_shuffle_labels_before_running = 1;  % randomly shuffled the labels before running
        
        % create the cross validator as before
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        
        the_cross_validator.num_resample_runs = 500;  % only do 10 resample runs to save time
        
        % don't show progress to reduce visual clutter while the code is running
        the_cross_validator.display_progress.zero_one_loss = 0;
        the_cross_validator.display_progress.resample_run_time = 0;
        
        % save the results with the appropriate name to the shuff_results/ directory
        destdirectory = Decoder_Shuffled_Destination;% MouseFolder(folder).name '_shuff_' num2str(shuff_num, '%03d')];
        %mkdir(destdirectory);
        save_file_name = [destdirectory '\' DayFolder(folder).name '_decoding_results_shuff_run_' num2str(shuff_num, '%03d')];
        
    end
    
    %%  create the cross-validator
%     the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
%     the_cross_validator.num_resample_runs = 3;  % usually more than 2 resample runs are used to get more accurate results, but to save time we are using a small number here
%     % other useful options:
%     % can greatly speed up the run-time of the analysis by not creating a full TCT matrix (i.e., only trainging and testing the classifier on the same time bin)
%     the_cross_validator.test_only_at_training_times = 1;
    %%  10.  Run the decoding analysis
    % if calling the code from a script, one can log the code so that one can recreate the results
    %log_code_obj = log_code_object;
    %log_code_obj.log_current_file;
    % run the decoding analysis
    DayFolder(folder).name
    DECODING_RESULTS = the_cross_validator.run_cv_decoding;
    % save the results
    % save_file_name = [destdirectory '\' MouseFolder(folder).name '_decoding_results'];
    save(save_file_name, 'DECODING_RESULTS');
end
toc
end

