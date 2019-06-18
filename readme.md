Resurrected 20190614. See `ROIs/20190614_Okamoto/readme.md`


### masked_space
20190617 - what space is `masked_space`? mprage space

in `scripts/warp.bash`
```
applywarp --rel --ref=coreg_target \
  --warp=mni_to_func_allwarp \
  --interp=nn \
  --in=/Volumes/TX/Autism_Faces/MVPA/ROIs/${roi}.nii \
  --out=${subj}_${roi}_func_space.nii
```

in `scripts/mask.bash`
```
3dcalc -a ${subj}_${roi}_func_space.nii.gz -b full_mask.${subj}+orig -expr 'a*b' -prefix ${subj}_${roi}_masked_space.nii
```
