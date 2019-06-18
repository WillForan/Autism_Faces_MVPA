#!/usr/bin/env bash

# copy "results" and "ROIs" to box
#
# expliclty exclude symlinks to avoid spamming errors like
#   2019/06/14 16:24:20 ERROR : 20190614_Okamoto/native_space/231/231_cars_func.nii.gz: Failed to copy: failed to open source object: open /Volumes/TX/Autism_Faces/Andrew/MVPA/ROIs/20190614_Okamoto/native_space/231/231_cars_func.nii.gz: object is remote
#
# 20190614WF  - init
# TODO: change to sync?


cd $(dirname $0) # make sure we are where the script is

# copy new files (by size comparison only) 
rclone copy -v --size-only results box:backup/TX/Autism_Faces/Andrew/MVPA/results --exclude template_brain.nii --exclude mprage.nii.gz 
rclone copy -v --size-only ROIs box:backup/TX/Autism_Faces/Andrew/MVPA/ROIs \
  --exclude '[12][0-9][0-9]_mprage.nii.gz' --exclude '[12][0-9][0-9]_cars_func.nii.gz' \
  --exclude '[12][0-9][0-9]_faces_usa_func.nii.gz' --exclude '[12][0-9][0-9]_faces_aus_func.nii.gz' \
  


