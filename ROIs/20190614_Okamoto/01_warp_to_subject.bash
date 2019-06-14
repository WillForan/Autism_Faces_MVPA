#!/usr/bin/env bash

# use previous files to warp MNI ROI (centered at coords.txt, see ./00_mk_coord_img.bash)
# to each individual+task's native space
# 20190614WF/JF - init

# get directories
cd $(dirname $0)
subjdir=$(cd ../../../../subject_data/; pwd)

# for each task functional (cars, faces_aus, faces_usa) for every subject 102 -> 267
for f in $subjdir/byID/*/experiment1/*/functional.nii.gz; do
   # extract subject id and expermiment
   [[ $f =~ byID/([0-9]{3})/experiment1/(cars|faces_aus|faces_usa) ]] || continue
   subj=${BASH_REMATCH[1]}
   exprmt=${BASH_REMATCH[2]}
   d=native_space/${subj}

   # find previous files we depend on
   funcdir=$(dirname $f)
   anatwarp=$funcdir/../../anatomical/MNI_to_mprage_xfm.nii 
   mprage=$funcdir/../../anatomical/mprage.nii.gz
   funcwarp=$funcdir/mprage_to_func.mat

   [ ! -r $anatwarp ] && echo "do not have anat warp: '$anatwarp'" && continue
   [ ! -r $funcwarp ] && echo "do not have anat warp: '$funcwarp'" && continue

   # prepare directories and warp
   [ ! -d $d ] && mkdir -p $d
   echo $subj $exprmt

   # N.B. warp was way off if we used mprage.nii.gz as the reference
   #      but using functional.nii.gz seems wrong!

   # skip if we've done this
   out=$d/${subj}_${exprmt}_RFFA_func.nii.gz
   if [ ! -r $out  ]; then
      set -x
      applywarp -i ./RFFA_all_HORFFmasked.nii.gz \
         -r $f -w $anatwarp -o $out \
         --interp=nn --postmat=$funcwarp
      set +x
   fi


   [ ! -r $mprage ] && echo "do not have mprage: '$mprage'" && continue
   out_mprage=$d/${subj}_RFFA_mprage.nii.gz
   if [ ! -r $out_mprage  ]; then
      set -x
      applywarp -i ./RFFA_all_HORFFmasked.nii.gz -r $mprage -w $anatwarp -o $out_mprage --interp=nn
      set +x
   fi

   # link in functional for visually inspecting warp
   [ ! -r $d/${subj}_${exprmt}_func.nii.gz ] && ln -s $f $d/${subj}_${exprmt}_func.nii.gz 
   [ ! -r $d/${subj}_mprage.nii.gz ] && ln -s $mprage $d/${subj}_mprage.nii.gz 
done
