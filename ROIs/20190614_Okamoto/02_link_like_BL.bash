#!/usr/bin/env bash

# move to
#   [sub#].results/[sub#]_[maskname]_masked_space+orig'
#
# ISSUE:
#  e.g. 102_*_RFFA_func.nii.gz are all in their own functional space
#       should be mprage space?
# 20190614WF

USEMPRAGE="yes"
#"yes" for mprage,  "" for func
#  MPRAGE |  SEARCHES                            | SAVES 
# --------|--------------------------------------|-------
#  yes    | 'native_space/*/*RFFA_mprage.nii.gz' | '_masked_space+orig'
#  ""     | 'native_space/*/*RFFA_func.nii.gz'   | '_masked_${exprmt}+orig'

# for all the roi files
for f in native_space/*/*_RFFA_*.nii.gz; do
   # figure out if we want to use this file
   # get settings fromf ile
   if [ -n $USEMPRAGE ]; then
      [[ $f =~ /([0-9]{3})_RFFA_mprage ]] || continue
      exprmt="space" # use generic "space" instead of experiment name
   else
      [[ $f =~ /([0-9]{3})_(cars|faces_aus|faces_usa)_RFFA_func ]] || continue
      exprmt=${BASH_REMATCH[2]}
   fi
   subj=${BASH_REMATCH[1]}

   echo $subj $f

   # for each roi in coordates read index and maskname
   cat coords.txt | while read x y z i maskname; do
     # use zero based indexing and make underscore a hyphen
     let i--
     maskname=${maskname/_/-}-FFA

     # copy to corrected name 
     outname=/Volumes/TX/Autism_Faces/Andrew/MVPA/results/$subj.results/${subj}_${maskname}_masked_${exprmt}+orig
     [ -r $outname.HEAD ] && continue
     3dTcat -prefix  $outname $f[$i]
   done

   #break
done
