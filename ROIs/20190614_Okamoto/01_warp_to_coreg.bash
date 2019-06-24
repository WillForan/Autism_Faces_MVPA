#!/usr/bin/env bash
set -euo pipefail
scriptdir="$(cd $(dirname "$0"); pwd)"
# 20190624 -  redo warps
#  copy warp and masking from  ../../scripts/warp.bash ../../scripts/mask.bash
#  copy subbrick extraction from nouse_02_link_like_BL.bash

mni_roi=$scriptdir/RFFA_all_HORFFmasked.nii.gz
[ ! -r $mni_roi ] && echo "run 00_mk_coord_img.bash for $mni_roi" && exit 1

for coreg in $scriptdir/../../results/*.results/coreg_target.nii.gz; do

   [[ $coreg =~ /([0-9]{3}).results ]] || continue
   subj=${BASH_REMATCH[1]}
   cd $(dirname $coreg)
   [ ! -r coreg_target.nii.gz ] && echo "$subj missing coreg_target.nii.gz" && continue
   [ ! -r mni_to_func_allwarp.nii.gz ] && echo "$subj missing mni_to_func_allwarp.nii.gz" && continue

   echo "$subj $(pwd)"

   ## warp to subject's coregistred (exp1/usa) space and mask by fullmask
   roi_coreg=${subj}_RFFA_coreg_space.nii.gz
   if [ ! -r $roi_coreg ]; then
      cmd="applywarp --rel --ref=coreg_target.nii.gz \
                --warp=mni_to_func_allwarp \
                --interp=nn \
                --in=$mni_roi \
                --out=$roi_coreg"
      eval $cmd
      3dNotes -h "$cmd" $roi_coreg
      3dcalc -a $roi_coreg -b full_mask.${subj}+orig -expr 'a*b' -prefix ${subj}_RFFA_masked.nii.gz
   fi

   ## generate files with expected names
   # for each of the mask centeres (named like A_TD A_AD C_TD C_AD)
   cat $scriptdir/coords.txt | while read x y z i maskname; do
      # use zero based indexing and make underscore a hyphen
      let i--
      # use - in mask name
      maskname=${maskname/_/-}-FFA
      outname=${subj}_${maskname}_masked_space+orig
      echo -e "\t$i $maskname"
      # [ -r $outname_final.HEAD ] && continue
      3dTcat -overwrite -prefix  $outname ${subj}_RFFA_masked.nii.gz[$i] 
   done
done
