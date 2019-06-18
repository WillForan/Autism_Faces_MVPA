# Generate alternative Fusiform ROIS
20190614WF/JF - init

ROIs from [DOI:10.1016/j.neures.2017.02.001](https://doi.org/10.1016/j.neures.2017.02.001)
> Age-dependent atypicalities in body- and face-sensitive activation of the EBA and FFA in individuals with ASD

as in `coords.txt`

| mask val/bucket position | roi |
|--------------------------|-----|
|  1                       | TD Adults    |
|  2                       | ASD Adults   |
|  3                       | TD Children  |
|  4                       | ASD Children |


## warps and files
see `Makefile`

 * `./00_mk_coord_img.bash` makes `RFFA_all_HORFFmasked.nii.gz` with 10mm radius spheres masked by harvard oxford FF annotation
 * `./01_warp_to_subject.bash` makes e.g. `native_space/102/102_faces_usa_RFFA_func.nii.gz` and `102_RFA_mprage`
 * `./02_link_like_BL.bash` offers `3dcopy` suggestion to matching previous runs
