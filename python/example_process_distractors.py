# EXAMPLE_PROCESS_DISTRACTORS  Code to read and process 1M distractor images.
#
# More details about the revisited 1M distractors and evaluation can be found in:
# Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking, CVPR 2018
#
# Authors: Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., 2018

import os
import numpy as np

from PIL import Image, ImageFile

from dataset import configdataset
from download import download_distractors

#---------------------------------------------------------------------
# Set data folder and testing parameters
#---------------------------------------------------------------------

# Set data folder, change if you have downloaded the data somewhere else
data_root = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
# Check, and, if necessary, download distractor dataset
download_distractors(data_root)
# Set up the dataset name
distractors_dataset = 'revisitop1m'

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

print('>> {}: Processing dataset...'.format(distractors_dataset)) 
# config file for the dataset
cfg = configdataset(distractors_dataset, os.path.join(data_root, 'datasets'))

for i in np.arange(cfg['n']):
    im = pil_loader(cfg['im_fname'](cfg, i))
    ##------------------------------------------------------
    ## Perform image processing here, eg, feature extraction
    ##------------------------------------------------------
    print('>> {}: Processing image {}'.format(distractors_dataset, i+1))
