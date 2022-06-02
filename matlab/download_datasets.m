function download_datasets(data_dir)
% DOWNLOAD_DATASETS Checks, and, if required, downloads the necessary datasets for the testing.
%
%   download_datasets(DATA_ROOT) checks if the data necessary for running the example script exist.
%   If not it downloads it in the folder structure:
%     DATA_ROOT/datasets/roxford5k/ : folder with Oxford images
%     DATA_ROOT/datasets/rparis6k/  : folder with Paris images

    % Create data folder if it does not exist
    if ~exist(data_dir, 'dir')
        mkdir(data_dir);
    end

    % Create datasets folder if it does not exist
    datasets_dir = fullfile(data_dir, 'datasets');
    if ~exist(datasets_dir, 'dir')
        mkdir(datasets_dir);
    end

    % Download datasets folders datasets/DATASETNAME/
    datasets = {'roxford5k', 'rparis6k'};
    for di = 1:numel(datasets)
        dataset = datasets{di};
        switch dataset
            case 'roxford5k'
                src_dir = fullfile('https://www.robots.ox.ac.uk/~vgg/data/oxbuildings');
                dl_files = {'oxbuild_images-v1.tgz'};
            case 'rparis6k'
                src_dir = fullfile('https://www.robots.ox.ac.uk/~vgg/data/parisbuildings');
                dl_files = {'paris_1-v1.tgz', 'paris_2-v1.tgz'};
            otherwise
                error ('Unkown dataset %s\n', dataset);
        end
        dst_dir = fullfile(data_dir, 'datasets', dataset, 'jpg');
        if ~exist(dst_dir, 'dir')
            fprintf('>> Dataset %s directory does not exist. Creating: %s\n', dataset, dst_dir);
            mkdir(dst_dir);
            for dli = 1:numel(dl_files)
                dl_file = dl_files{dli};
                src_file = fullfile(src_dir, dl_file);
                dst_file = fullfile(dst_dir, dl_file);
                fprintf('>> Downloading dataset %s archive %s...\n', dataset, dl_file);
                system(sprintf('wget %s -O %s', src_file, dst_file));
                fprintf('>> Extracting dataset %s archive %s...\n', dataset, dl_file);
                % create tmp folder
                dst_dir_tmp = fullfile(dst_dir, 'tmp');
                system(sprintf('mkdir %s', dst_dir_tmp));
                % extract in tmp folder
                system(sprintf('tar -zxf %s -C %s', dst_file, dst_dir_tmp));
                % remove all (possible) subfolders by moving only files in dst_dir
                system(sprintf('find %s -type f -exec mv -i {} %s \\;', dst_dir_tmp, dst_dir));
                % remove tmp folder
                system(sprintf('rm -rf %s', dst_dir_tmp));
                fprintf('>> Extracted, deleting dataset %s archive %s...\n', dataset, dl_file);
                system(sprintf('rm %s', dst_file));
            end
        end
        gnd_src_dir = fullfile('http://cmp.felk.cvut.cz/revisitop/data', 'datasets', dataset);
        gnd_dst_dir = fullfile(data_dir, 'datasets', dataset);
        gnd_dl_file = sprintf('gnd_%s.mat', dataset);
        gnd_src_file = fullfile(gnd_src_dir, gnd_dl_file);
        gnd_dst_file = fullfile(gnd_dst_dir, gnd_dl_file);
        if ~exist(gnd_dst_file, 'file')
            fprintf('>> Downloading dataset %s ground truth file...\n', dataset);
            system(sprintf('wget %s -O %s', gnd_src_file, gnd_dst_file));
        end
    end
