function [] = BehaviorEventsfromMEDPC()
%BEHAVIOR Summary of this function goes here
%   Detailed explanation goes here

format long %make sure matlab doesn't truncate your numbers or use scientific notation

%% -----Specify what behavior you want to extract by letter assignment with MEDPC variables as reference (i.e. LP, HE, REIN)----- %%

Alphabet = 'ABDEFGHIJKLMNOPQRSTUVWXYZC';%modified alphabet because for some reason MEDPC puts C last
LP_var = 'Q'; HE_var = 'B'; REIN_var = 'D'; Hold_Criteria_var = 'L'; %specify MEDPC variable for your behavior
LP = []; HE = []; REIN = []; % iniatialize individual behavior matrices
LP_idx = strfind(Alphabet, LP_var); HE_idx = strfind(Alphabet, HE_var); REIN_idx = strfind(Alphabet, REIN_var); % index of behaviors in MEDPC file
Hold_Criteria_idx = strfind(Alphabet, Hold_Criteria_var);
%% -----Set path of your folders containing MEDPC files----- %%

Experiment_name = 'CC-EXP28-2-DREADD-OFC-Hold-All'; % Name of experiment (will be named of saved .mat for all of the following)
%PathName_Master = 'C:\Matlab code\Gremel\MedPC Master\'; % Path with these functions
PathName_Master = 'I:\Christian\MedPC Master';
PathName_Folders = uigetdir(PathName_Master); % Path with MEDPC Folders, click on 'Select Folder' DO NOT DOUBLE CLICK
MedPCFolders = dir(PathName_Folders); % get names of MEDPC Folders
MedPCFolders = MedPCFolders(3:end); %remove invalid directory entries '.' and '..'
cd(PathName_Folders) %change directory to where MEDPC Folders are
Events = cell(1, length(MedPCFolders)); % initialize cell matrix where MEDPC data will be stored
Names = cell(1, length(MedPCFolders));


%% -----Loop through each folder (i.e. experiment day) and within it, each subject to extract event (i.e. timing) and behavior data (i.e. # LPs)----- %%

for folder = 1:length(MedPCFolders) % For each MEDPC Folder
    cd([MedPCFolders(folder).folder '\' MedPCFolders(folder).name]) % Change directory to that folder
    PathName_Folder = cd; % get path of current directory (folder)
    MedPCFiles = dir(PathName_Folder); % get names of individual MEDPC files within that folder
    MedPCFiles = MedPCFiles(3:end); %remove invalid directory entries '.' and '..'

    for file = 1:length(MedPCFiles) % for each MEDPC file in this folder
        MedPCFileName = MedPCFiles(file).name % get MEDPC filename
        [folder, file]
        Events{file, folder} = importfile_MEDPC(MedPCFileName, 37, 500000); % Import event and timing data
        subject_beh = importfile_MEDPC(MedPCFileName, 11, 35); % Import LP, HE, REIN data
        subject_beh = subject_beh(:,1); % remove NaNs in matrix
        

        %--Modify these if you're looking at different/more behavior--%
        LP(file, folder) = subject_beh(LP_idx); % get Lever presses
        HE(file, folder) = subject_beh(HE_idx); % get Head entries
        REIN(file, folder) = subject_beh(REIN_idx); % get Reinforcers earned
        Hold_Criteria(file,folder) = subject_beh(Hold_Criteria_idx) * 10;
        Name{file, folder} = MedPCFileName;
    end
    
    cd(PathName_Folders)
end

%% ----- Choose where you save your extracted MEDPC data -----%%

cd(PathName_Master) % Change directory to one above each day's folder
save(Experiment_name , 'Events', 'LP', 'HE', 'REIN', 'Hold_Criteria', 'Name')
end

