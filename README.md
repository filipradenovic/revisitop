# Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking

We revisit and address issues with Oxford 5k and Paris 6k image retrieval benchmarks. New annotation for both datasets is created with an extra attention to the reliability of the ground truth and three new protocols of varying difficulty are introduced. We additionally introduce 15 new challenging queries per dataset and a new set of 1M hard distractors.

This package provides support in downloading and using the new benchmark.

<img src="http://cmp.felk.cvut.cz/revisitop/img/revisitop_teaser_medium.png" width=\textwidth/>

## MATLAB

Tested with MATLAB R2017a on Debian 8.1.

### Process images

This example script first downloads dataset images and the revisited annotation files. Then, it describes how to: read and process database images; read, crop and process query images:
```
>> example_process_images
```
Similarly, this example script first downloads one million images from the revisited distractor dataset (this can take a while). Then, it describes how to read and process images.
```
>> example_process_distractors
```

### Evaluate results

Example script that describes how to evaluate according to the revisited annotation and the three protocol setups:
```
>> example_evaluate
```
It automatically downloads dataset images, the revisited annotation file, and example features (R-[37]-GeM from the paper) to be used in the evaluation.
The final output should look like this (depending on the selected ```test_dataset```):
```
>> roxford5k: mAP E: 84.81, M: 64.67, H: 38.47
>> roxford5k: mP@k[1 5 10] E: [97.06 92.06 86.49], M: [97.14 90.67 84.67], H: [81.43 63.00 53.00]
```
or
```
>> rparis6k: mAP E: 92.12, M: 77.20, H: 56.32
>> rparis6k: mP@k[1 5 10] E: [100.00 97.14 96.14], M: [100.00 98.86 98.14], H: [94.29 90.29 89.14]
```

## Python

Tested with Python 3.5.3 on Debian 8.1.

### Process images

This example script first downloads dataset images and the revisited annotation files. Then, it describes how to: read and process database images; read, crop and process query images:
```
>> python3 example_process_images
```
Similarly, this example script first downloads one million images from the revisited distractor dataset (this can take a while). Then, it describes how to read and process images.
```
>> python3 example_process_distractors
```

### Evaluate results

Example script that describes how to evaluate according to the revisited annotation and the three protocol setups:
```
>> python3 example_evaluate
```
It automatically downloads dataset images, revisited annotation file, and example features (R-[37]-GeM from the paper) to be used in the evaluation.
The final output should look like this (depending on the selected ```test_dataset```):
```
>> roxford5k: mAP E: 84.81, M: 64.67, H: 38.47
>> roxford5k: mP@k[ 1  5 10] E: [97.06 92.06 86.49], M: [97.14 90.67 84.67], H: [81.43 63.   53.  ]
```
or
```
>> rparis6k: mAP E: 92.12, M: 77.2, H: 56.32
>> rparis6k: mP@k[ 1  5 10] E: [100.    97.14  96.14], M: [100.    98.86  98.14], H: [94.29 90.29 89.14]
```

> **Note** (June 2022): We updated download files for [Oxford 5k](https://www.robots.ox.ac.uk/~vgg/data/oxbuildings/) and [Paris 6k](https://www.robots.ox.ac.uk/~vgg/data/parisbuildings/) images to use images with blurred faces as suggested by the original dataset owners. Bear in mind, "experiments have shown that one can use the face-blurred version for benchmarking image retrieval with negligible loss of accuracy".

## Related publication

```
@inproceedings{RITAC18,
 author = {Radenovi\'{c}, F. and Iscen, A. and Tolias, G. and Avrithis, Y. and Chum, O.},
 title = {Revisiting Oxford and Paris: Large-Scale Image Retrieval Benchmarking},
 booktitle = {CVPR},
 year = {2018}
}
```
