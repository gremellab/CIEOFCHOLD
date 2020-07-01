function [] = Binned_Formatting(Raster_Directory, Raster_Destination, save_prefix_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic
% selpath = uigetdir('I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Raster_Format_Data\Cohort_Grouped_LP_ON_Sig');
% %selpath = 'I:\Christian\Code_Exp35_CIE_Hold_Eth\Data\1600-Early\1600-Early-Air';
% listing = dir(selpath );
% MouseFolder= listing(3:end);
%for folder = 1:length(MouseFolder)
    %% Make new folder to put binned data in
    %raster_data_directory_name = [MouseFolder(folder).folder '\' MouseFolder(folder).name];
    %raster_data_directory_name = [MouseFolder(1).folder '\'];
    raster_data_directory_name = Raster_Directory;
    %cd(raster_data_directory_name)
    %destdirectory = ['I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Binned_Format_Data\Grouped_LP_ON_Sig\Air\'];
    destdirectory = Raster_Destination;
    %destdirectory = ['I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Binned_Format_Data\Grouped_LP_ON_Sig\Air\' MouseFolder(folder).name];
    %destdirectory = ['I:\Christian\Code_Exp35_CIE_Hold_Eth\Code\Encoding\Binned_Format_Data\Grouped_LP_ON_Sig\CIE' MouseFolder(folder).name];
    %mkdir(destdirectory);   %create the directory
    %% Bin the data and save it
    %save_prefix_name = [MouseFolder(folder).name '_binned_data'];
    %save_prefix_name = ['Air_binned_data'];
    bin_width = 200; 
    step_size = 100;
    start_time = 3751;
    end_time = 9000;
    cd(destdirectory)
    binned_data_file_name = create_binned_data_from_raster_data(raster_data_directory_name,save_prefix_name,... 
        bin_width, step_size);
    %% Save it
    %save([destdirectory '\' MouseFolder(1).name '_binned_data'], 'binned_data', 'binned_labels', 'binned_site_info')
%end
toc
end

