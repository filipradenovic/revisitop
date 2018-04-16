function download_features(data_dir)
% DOWNLOAD_FEATURES Checks, and, if required, downloads the necessary features for the example testing.
%
%   download_features(DATA_ROOT) checks if the data necessary for running the example script exist.
%   If not it downloads it in the folder: DATA_ROOT/features

    % Create data folder if it does not exist
    if ~exist(data_dir, 'dir')
        mkdir(data_dir);
    end

    % Create features folder if it does not exist
    features_dir = fullfile(data_dir, 'features');
    if ~exist(features_dir, 'dir')
        mkdir(features_dir);
    end

    % Download example features
    datasets = {'roxford5k', 'rparis6k'};
    for di = 1:numel(datasets)
        dataset = datasets{di};

        feat_src_dir = fullfile('http://cmp.felk.cvut.cz/revisitop/data', 'features');
        feat_dst_dir = fullfile(data_dir, 'features');
        feat_dl_file = sprintf('%s_resnet_rsfm120k_gem.mat', dataset);
        feat_src_file = fullfile(feat_src_dir, feat_dl_file);
        feat_dst_file = fullfile(feat_dst_dir, feat_dl_file);
        if ~exist(feat_dst_file, 'file')
            fprintf('>> Downloading dataset %s features file %s...\n', dataset, feat_dl_file);
            system(sprintf('wget %s -O %s', feat_src_file, feat_dst_file));
        end
    end
    