#!/usr/bin/env bash

# create mask from roi centers reported by DOI:10.1016/j.neures.2017.02.001
# restrict 10mm radious spheres to be within harox FF
# 20190614WF/JF - init
#

set -e

# 2x2x2 as is used in anatomical preprocessing to create warp_coef for MNI <-> T1
exampleMaster=/Users/lncd/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain_2mm.nii 

# create a new file with a single sphere for each line in coord.txt
cat coords.txt | while read x y z v label; do
   3dUndump -prefix RFFA/RFFA_$label.nii.gz \
     -master $exampleMaster \
     -overwrite -srad 10  -xyz <(echo "$x $y $z $v")
done

# lump them all together as a timeseries 
# timepoint and value should match: mask in subbrick 2 values are 2
3dBucket -overwrite -prefix RFFA_all.nii.gz RFFA/*.nii.gz 

# restrict mask to harvox FF region
3dresample -overwrite -inset ../HO_R_fusiform.nii -master RFFA_all.nii.gz -rmode NN -prefix HO_RFF_2mm.nii.gz
3dcalc -overwrite -a RFFA_all.nii.gz -m HO_RFF_2mm.nii -expr 'step(m)*a' -prefix RFFA_all_HORFFmasked.nii.gz
