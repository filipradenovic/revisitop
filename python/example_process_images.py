# EXAMPLE_PROCESS_IMAGES  Code to read and process images for ROxford and RParis datasets.
# Revisited protocol requires query images to be removed from the database, and cropped prior to any processing.
# This code makes sure the protocol is strictly followed.
#
# More details about the revisited annotation and evaluation can be found in:
# Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking, CVPR 2018
#
# Authors: Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., 2018

import os
import numpy as np

from PIL import Image, ImageFile

from dataset import configdataset
from download import download_datasets

#---------------------------------------------------------------------
# Set data folder and testing parameters
#---------------------------------------------------------------------
# Set data folder, change if you have downloaded the data somewhere else
data_root = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
# Check, and, if necessary, download test data (Oxford and Pairs) and revisited annotation
download_datasets(data_root)

# Set test dataset: roxford5k | rparis6k
test_dataset = 'roxford5k'

#---------------------------------------------------------------------
# Read images
#---------------------------------------------------------------------

def pil_loader(path):
    # to avoid crashing for truncated (corrupted images)
    ImageFile.LOAD_TRUNCATED_IMAGES = True
    # open path as file to avoid ResourceWarning 
    # (https://github.com/python-pillow/Pillow/issues/835)
    with open(path, 'rb') as f:
        img = Image.open(f)
        return img.convert('RGB')

print('>> {}: Processing test dataset...'.format(test_dataset)) 
# config file for the dataset
# separates query image list from database image list, if revisited protocol used
cfg = configdataset(test_dataset, os.path.join(data_root, 'datasets'))

# query images
for i in np.arange(cfg['nq']):
    qim = pil_loader(cfg['qim_fname'](cfg, i)).crop(cfg['gnd'][i]['bbx'])
    ##------------------------------------------------------
    ## Perform image processing here, eg, feature extraction
    ##------------------------------------------------------
    print('>> {}: Processing query image {}'.format(test_dataset, i+1))

for i in np.arange(cfg['n']):
    im = pil_loader(cfg['im_fname'](cfg, i))
    ##------------------------------------------------------
    ## Perform image processing here, eg, feature extraction
    ##------------------------------------------------------
    print('>> {}: Processing database image {}'.format(test_dataset, i+1))
