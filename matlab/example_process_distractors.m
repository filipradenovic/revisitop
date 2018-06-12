% EXAMPLE_PROCESS_DISTRACTORS  Code to read and process 1M distractor images.
%
% More details about the revisited 1M distractors and evaluation can be found in:
% Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking, CVPR 2018
%
% Authors: Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., 2018

clear;

%---------------------------------------------------------------------
% Set data folder and testing parameters
%---------------------------------------------------------------------

% Set data folder, change if you have downloaded the data somewhere else
data_root = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'data');
% Check, and, if necessary, download distractor dataset
download_distractors(data_root); 
% Set up the dataset name
distractors_dataset = 'revisitop1m';

%---------------------------------------------------------------------
% Read and process images
%---------------------------------------------------------------------

fprintf('>> %s: Processing dataset...\n', distractors_dataset);       
% config file for the dataset
cfg = configdataset (distractors_dataset, fullfile(data_root, 'datasets/')); 

% images
for i = 1:cfg.n
    im = imread(cfg.im_fname(cfg, i));
    %%------------------------------------------------------
    %% Perform image processing here, eg, feature extraction
    %%------------------------------------------------------
    fprintf('>> %s: Processing image %d\n', distractors_dataset, i);
end