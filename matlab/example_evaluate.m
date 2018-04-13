% EXAMPLE_EVALUATE  Code to evaluate example results on Oxford, ROxford, Paris, and RParis datasets.
% Original protocol (Oxford and Paris) evaluate the performance using mean average precision (mAP).
% Revisited protocol (ROxford and RParis) has 3 difficulty setups: Easy (E), Medium (M), and Hard(H), 
% and evaluates the performance using mean average precision (mAP), as well as mean precision @ k (mP@k)
%
% More details about the revisited annotation and evaluation can be found in:
% Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking, CVPR 2018
%
% Authors: Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., 2018

clear;

%---------------------------------------------------------------------
% Set data folder and testing parameters
%---------------------------------------------------------------------

% Set data folder, change if you have downloaded the data somewhere else
data_root = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'data');
% Check, and, if necessary, download test data (Oxford and Pairs), 
% original and revisited annotation, and example feature vectors for evaluation
% download_test(data_root); 

% Set test dataset: oxford5k | roxford5k | paris6k | rparis6k
test_dataset = 'roxford5k';

%---------------------------------------------------------------------
% Evaluate
%---------------------------------------------------------------------

fprintf('>> %s: Evaluating test dataset...\n', test_dataset);		
% config file for the dataset
% separates query image list from database image list, if revisited protocol used
cfg = configdataset (test_dataset, fullfile(data_root, 'datasets/')); 

% load query and database features
fprintf('>> %s: Loading features...\n', test_dataset);		
load(fullfile(data_root, 'features', sprintf('%s_resnet_rsfm120k_gem.mat', test_dataset)), 'Q', 'X');

% perform search
fprintf('>> %s: Retrieval...\n', test_dataset);
sim = X'*Q;
[sim, ranks] = sort(sim, 'descend');

% evaluate performance and print results
if strcmp(test_dataset, 'oxford5k') || strcmp(test_dataset, 'paris6k')
	% original evaluation
	map = compute_map (ranks, cfg.gnd);	
	fprintf('>> %s: mAP %.2f\n', test_dataset, 100*map);
elseif strcmp(test_dataset, 'roxford5k') || strcmp(test_dataset, 'rparis6k')
	% revisited evaluation

	% evaluate ranks
	ks = [1, 5, 10];
	% search for easy
	for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).hard]; end
	[mapE, apsE, mprE, prsE] = compute_map (ranks, gnd, ks);
	% search for easy & hard
	for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy, cfg.gnd(i).hard]; gnd(i).junk = cfg.gnd(i).junk; end
	[mapM, apsM, mprM, prsM] = compute_map (ranks, gnd, ks);
	% search for hard
	for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).hard]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).easy]; end
	[mapH, apsH, mprH, prsH] = compute_map (ranks, gnd, ks);
	
	fprintf('>> %s: mAP E: %.2f, M: %.2f, H: %.2f\n', test_dataset, 100*mapE, 100*mapM, 100*mapH);
	fprintf('>> %s: mP@k[%d %d %d] E: [%.2f %.2f %.2f], M: [%.2f %.2f %.2f], H: [%.2f %.2f %.2f]\n', test_dataset, ks(1), ks(2), ks(3), 100*mprE, 100*mprM, 100*mprH);
end
