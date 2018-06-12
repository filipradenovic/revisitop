function download_distractors(data_dir)
% DOWNLOAD_DISTRACTORS Checks, and, if required, downloads the distractor dataset.
%
%   download_distractors(DATA_ROOT) checks if the distractor dataset exist.
%   If not it downloads it in the folder:
%     DATA_ROOT/datasets/revisitop1m/   : folder with 1M distractor images

    % Create data folder if it does not exist
    if ~exist(data_dir, 'dir')
        mkdir(data_dir);
    end

    % Create datasets folder if it does not exist
    datasets_dir = fullfile(data_dir, 'datasets');
    if ~exist(datasets_dir, 'dir')
        mkdir(datasets_dir);
    end

    dataset = 'revisitop1m';
    nfiles = 100;
    src_dir = 'http://ptak.felk.cvut.cz/revisitop/revisitop1m/jpg/';
    dl_files = 'revisitop1m.%d.tar.gz';
    dst_dir = fullfile(data_dir, 'datasets', dataset, 'jpg');
    dst_dir_tmp = fullfile(data_dir, 'datasets', dataset, 'jpg_tmp');
    if ~exist(dst_dir, 'dir')
        fprintf('>> Dataset %s directory does not exist.\n>> Creating: %s\n', dataset, dst_dir);
        % first create a tmp folder
        if ~exist(dst_dir_tmp, 'dir')
            mkdir(dst_dir_tmp);
        end
        for dfi = 1:nfiles
            dl_file = sprintf(dl_files, dfi);
            src_file = fullfile(src_dir, dl_file);
            dst_file = fullfile(dst_dir_tmp, dl_file);
            dst_file_tmp = fullfile(dst_dir_tmp, [dl_file, '.tmp']);
            if exist(dst_file)
                fprintf('>> [%d/%d] Skipping dataset %s archive %s, already exists...\n', dfi, nfiles, dataset, dl_file);
            else
                while 1
                    try
                        fprintf('>> [%d/%d] Downloading dataset %s archive %s...\n', dfi, nfiles, dataset, dl_file);
                        websave(dst_file_tmp, src_file);
                        movefile(dst_file_tmp, dst_file);
                        break
                    catch
                        fprintf('>>>> Download failed. Try this one again...\n');
                    end
                end
            end
        end
        for dfi = 1:nfiles
            dl_file = sprintf(dl_files, dfi);
            dst_file = fullfile(dst_dir_tmp, dl_file);
            fprintf('>> [%d/%d] Extracting dataset %s archive %s...\n', dfi, nfiles, dataset, dl_file);
            untar(dst_file, dst_dir_tmp);
            fprintf('>> [%d/%d] Extracted, deleting dataset %s archive %s...\n', dfi, nfiles, dataset, dl_file);
            delete(dst_file);
        end
        % rename tmp folder
        movefile(dst_dir_tmp, dst_dir);
    end
    gnd_src_dir = fullfile('http://ptak.felk.cvut.cz/revisitop/revisitop1m/');
    gnd_dst_dir = fullfile(data_dir, 'datasets', dataset);
    gnd_dl_file = sprintf('%s.txt', dataset);
    gnd_src_file = fullfile(gnd_src_dir, gnd_dl_file);
    gnd_dst_file = fullfile(gnd_dst_dir, gnd_dl_file);
    if ~exist(gnd_dst_file, 'file')
        fprintf('>> Downloading dataset %s image list file...\n', dataset);
        websave(gnd_dst_file, gnd_src_file);
    end