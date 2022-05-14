import os
import urllib.request
import tarfile

def download_datasets(data_dir):
    """
    DOWNLOAD_DATASETS Checks, and, if required, downloads the necessary datasets for the testing.
      
        download_datasets(DATA_ROOT) checks if the data necessary for running the example script exist.
        If not it downloads it in the folder structure:
            DATA_ROOT/datasets/roxford5k/ : folder with Oxford images
            DATA_ROOT/datasets/rparis6k/  : folder with Paris images
    """

    # Create data folder if it does not exist
    if not os.path.isdir(data_dir):
        os.mkdir(data_dir)
    
    # Create datasets folder if it does not exist
    datasets_dir = os.path.join(data_dir, 'datasets')
    if not os.path.isdir(datasets_dir):
        os.mkdir(datasets_dir)

    # Download datasets folders datasets/DATASETNAME/
    datasets = ['roxford5k', 'rparis6k']
    for di in range(len(datasets)):
        dataset = datasets[di]

        if dataset == 'roxford5k':
            src_dir = 'https://www.robots.ox.ac.uk/~vgg/data/oxbuildings'
            dl_files = ['oxbuild_images-v1.tgz']
        elif dataset == 'rparis6k':
            src_dir = 'https://www.robots.ox.ac.uk/~vgg/data/parisbuildings'
            dl_files = ['paris_1-v1.tgz', 'paris_2-v1.tgz']
        else:
            raise ValueError('Unknown dataset: {}!'.format(dataset))

        dst_dir = os.path.join(data_dir, 'datasets', dataset, 'jpg')
        if not os.path.isdir(dst_dir):
            print('>> Dataset {} directory does not exist. Creating: {}'.format(dataset, dst_dir))
            os.makedirs(dst_dir)
            for dli in range(len(dl_files)):
                dl_file = dl_files[dli]
                src_file = os.path.join(src_dir, dl_file)
                dst_file = os.path.join(dst_dir, dl_file)
                print('>> Downloading dataset {} archive {}...'.format(dataset, dl_file))
                os.system('wget {} -O {}'.format(src_file, dst_file))
                print('>> Extracting dataset {} archive {}...'.format(dataset, dl_file))
                # create tmp folder
                dst_dir_tmp = os.path.join(dst_dir, 'tmp')
                os.system('mkdir {}'.format(dst_dir_tmp))
                # extract in tmp folder
                os.system('tar -zxf {} -C {}'.format(dst_file, dst_dir_tmp))
                # remove all (possible) subfolders by moving only files in dst_dir
                os.system('find {} -type f -exec mv -i {{}} {} \\;'.format(dst_dir_tmp, dst_dir))
                # remove tmp folder
                os.system('rm -rf {}'.format(dst_dir_tmp))
                print('>> Extracted, deleting dataset {} archive {}...'.format(dataset, dl_file))
                os.system('rm {}'.format(dst_file))

        gnd_src_dir = os.path.join('http://cmp.felk.cvut.cz/revisitop/data', 'datasets', dataset)
        gnd_dst_dir = os.path.join(data_dir, 'datasets', dataset)
        gnd_dl_file = 'gnd_{}.pkl'.format(dataset)
        gnd_src_file = os.path.join(gnd_src_dir, gnd_dl_file)
        gnd_dst_file = os.path.join(gnd_dst_dir, gnd_dl_file)
        if not os.path.exists(gnd_dst_file):
            print('>> Downloading dataset {} ground truth file...'.format(dataset))
            os.system('wget {} -O {}'.format(gnd_src_file, gnd_dst_file))


def download_distractors(data_dir):
    """
    DOWNLOAD_DISTRACTORS Checks, and, if required, downloads the distractor dataset.

    download_distractors(DATA_ROOT) checks if the distractor dataset exist.
    If not it downloads it in the folder:
        DATA_ROOT/datasets/revisitop1m/   : folder with 1M distractor images
    """

    # Create data folder if it does not exist
    if not os.path.isdir(data_dir):
        os.mkdir(data_dir)
    
    # Create datasets folder if it does not exist
    datasets_dir = os.path.join(data_dir, 'datasets')
    if not os.path.isdir(datasets_dir):
        os.mkdir(datasets_dir)

    dataset = 'revisitop1m'
    nfiles = 100
    src_dir = 'http://ptak.felk.cvut.cz/revisitop/revisitop1m/jpg'
    dl_files = 'revisitop1m.{}.tar.gz'
    dst_dir = os.path.join(data_dir, 'datasets', dataset, 'jpg')
    dst_dir_tmp = os.path.join(data_dir, 'datasets', dataset, 'jpg_tmp')
    if not os.path.isdir(dst_dir):
        print('>> Dataset {} directory does not exist.\n>> Creating: {}'.format(dataset, dst_dir))
        if not os.path.isdir(dst_dir_tmp):
            os.makedirs(dst_dir_tmp)
        for dfi in range(nfiles):
            dl_file = dl_files.format(dfi+1)
            src_file = os.path.join(src_dir, dl_file)
            dst_file = os.path.join(dst_dir_tmp, dl_file)
            dst_file_tmp = os.path.join(dst_dir_tmp, dl_file + '.tmp')
            if os.path.exists(dst_file):
                print('>> [{}/{}] Skipping dataset {} archive {}, already exists...'.format(dfi+1, nfiles, dataset, dl_file))
            else:
                while 1:
                    try:
                        print('>> [{}/{}] Downloading dataset {} archive {}...'.format(dfi+1, nfiles, dataset, dl_file))
                        urllib.request.urlretrieve(src_file, dst_file_tmp)
                        os.rename(dst_file_tmp, dst_file)
                        break
                    except:
                        print('>>>> Download failed. Try this one again...')
        for dfi in range(nfiles):
            dl_file = dl_files.format(dfi+1)
            dst_file = os.path.join(dst_dir_tmp, dl_file)
            print('>> [{}/{}] Extracting dataset {} archive {}...'.format(dfi+1, nfiles, dataset, dl_file))
            tar = tarfile.open(dst_file)
            tar.extractall(path=dst_dir_tmp)
            tar.close()
            print('>> [{}/{}] Extracted, deleting dataset {} archive {}...'.format(dfi+1, nfiles, dataset, dl_file))
            os.remove(dst_file)
        # rename tmp folder
        os.rename(dst_dir_tmp, dst_dir)

        # download image list
        gnd_src_dir = 'http://ptak.felk.cvut.cz/revisitop/revisitop1m/'
        gnd_dst_dir = os.path.join(data_dir, 'datasets', dataset)
        gnd_dl_file = '{}.txt'.format(dataset)
        gnd_src_file = os.path.join(gnd_src_dir, gnd_dl_file)
        gnd_dst_file = os.path.join(gnd_dst_dir, gnd_dl_file)
        if not os.path.exists(gnd_dst_file):
            print('>> Downloading dataset {} image list file...'.format(dataset))
            urllib.request.urlretrieve(gnd_src_file, gnd_dst_file)


def download_features(data_dir):
    """
    DOWNLOAD_FEATURES Checks, and, if required, downloads the necessary features for the example testing.

        download_features(DATA_ROOT) checks if the data necessary for running the example script exist.
        If not it downloads it in the folder: DATA_ROOT/features
    """

    # Create data folder if it does not exist
    if not os.path.isdir(data_dir):
        os.mkdir(data_dir)
    
    # Create features folder if it does not exist
    features_dir = os.path.join(data_dir, 'features')
    if not os.path.isdir(features_dir):
        os.mkdir(features_dir)

    # Download example features
    datasets = ['roxford5k', 'rparis6k']
    for di in range(len(datasets)):
        dataset = datasets[di]

        feat_src_dir = os.path.join('http://cmp.felk.cvut.cz/revisitop/data', 'features')
        feat_dst_dir = os.path.join(data_dir, 'features')
        feat_dl_file = '{}_resnet_rsfm120k_gem.mat'.format(dataset)
        feat_src_file = os.path.join(feat_src_dir, feat_dl_file)
        feat_dst_file = os.path.join(feat_dst_dir, feat_dl_file)
        if not os.path.exists(feat_dst_file):
            print('>> Downloading dataset {} features file {}...'.format(dataset, feat_dl_file))
            os.system('wget {} -O {}'.format(feat_src_file, feat_dst_file))
    