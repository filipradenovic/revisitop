# EXAMPLE_EVALUATE  Code to evaluate example results on ROxford and RParis datasets.
# Revisited protocol has 3 difficulty setups: Easy (E), Medium (M), and Hard (H), 
# and evaluates the performance using mean average precision (mAP), as well as mean precision @ k (mP@k)
#
# More details about the revisited annotation and evaluation can be found in:
# Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking, CVPR 2018
#
# Authors: Radenovic F., Iscen A., Tolias G., Avrithis Y., Chum O., 2018

import os
import numpy as np

from scipy.io import loadmat

from dataset import configdataset
from download import download_datasets, download_features
from evaluate import compute_map

#---------------------------------------------------------------------
# Set data folder and testing parameters
#---------------------------------------------------------------------
# Set data folder, change if you have downloaded the data somewhere else
data_root = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'data')
# Check, and, if necessary, download test data (Oxford and Pairs), 
# revisited annotation, and example feature vectors for evaluation
download_datasets(data_root)
download_features(data_root)

# Set test dataset: roxford5k | rparis6k
test_dataset = 'roxford5k'

#---------------------------------------------------------------------
# Evaluate
#---------------------------------------------------------------------

print('>> {}: Evaluating test dataset...'.format(test_dataset)) 
# config file for the dataset
# separates query image list from database image list, when revisited protocol used
cfg = configdataset(test_dataset, os.path.join(data_root, 'datasets'))

# load query and database features
print('>> {}: Loading features...'.format(test_dataset))    
features = loadmat(os.path.join(data_root, 'features', '{}_resnet_rsfm120k_gem.mat'.format(test_dataset)))
Q = features['Q']
X = features['X']

# perform search
print('>> {}: Retrieval...'.format(test_dataset))
sim = np.dot(X.T, Q)
ranks = np.argsort(-sim, axis=0)

# revisited evaluation
gnd = cfg['gnd']

# evaluate ranks
ks = [1, 5, 10]

# search for easy
gnd_t = []
for i in range(len(gnd)):
    g = {}
    g['ok'] = np.concatenate([gnd[i]['easy']])
    g['junk'] = np.concatenate([gnd[i]['junk'], gnd[i]['hard']])
    gnd_t.append(g)
mapE, apsE, mprE, prsE = compute_map(ranks, gnd_t, ks)

# search for easy & hard
gnd_t = []
for i in range(len(gnd)):
    g = {}
    g['ok'] = np.concatenate([gnd[i]['easy'], gnd[i]['hard']])
    g['junk'] = np.concatenate([gnd[i]['junk']])
    gnd_t.append(g)
mapM, apsM, mprM, prsM = compute_map(ranks, gnd_t, ks)

# search for hard
gnd_t = []
for i in range(len(gnd)):
    g = {}
    g['ok'] = np.concatenate([gnd[i]['hard']])
    g['junk'] = np.concatenate([gnd[i]['junk'], gnd[i]['easy']])
    gnd_t.append(g)
mapH, apsH, mprH, prsH = compute_map(ranks, gnd_t, ks)

print('>> {}: mAP E: {}, M: {}, H: {}'.format(test_dataset, np.around(mapE*100, decimals=2), np.around(mapM*100, decimals=2), np.around(mapH*100, decimals=2)))
print('>> {}: mP@k{} E: {}, M: {}, H: {}'.format(test_dataset, np.array(ks), np.around(mprE*100, decimals=2), np.around(mprM*100, decimals=2), np.around(mprH*100, decimals=2)))