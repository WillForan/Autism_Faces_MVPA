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

### new scripts
20190624 - `RSA_20190614_Okamoto.m`
```
 rclone copy --dry-run -v --size-only box:backup/TX/Autism_Faces/Andrew/MVPA/RSA_scripts RSA_scripts
     makeANOVAtable_newROIs_20190618.m: Copied (new)
     makeANOVAtable_20140509.m: Copied (replaced existing)
     makeCorMat_RSA_newROIs_20190618.m: Copied (new)
     makeMaskedSets_NewROIs_20190618.m: Copied (new)
     makeANOVAtable_20140509_multi_area.mat: Copied (replaced existing)
     parseSubInfo.m: Copied (replaced existing)
```

> 1. `makeMaskedSets_NewROIs_20190618.m`
> 2. `makeCorMat_RSA_newROIs_20190618.m`
> 3. `makeANOVAtable_newROIs_20190618.m`
> They should be run in that order. The first one could take a few minutes. Really hoping they just work and there is no debugging needed!! �

* update `RSA_scripts/parseSubInfo.m` and `addpath('/usr/share/afni/matlab/')`
* use native space resolution for mask instead of mprage (`3x3x4` not `1x1x1`) replacing old roi creation with `ROIs/20190614_Okamoto/01_warp_to_coreg.bash`
