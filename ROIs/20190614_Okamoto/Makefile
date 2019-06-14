.PHONY: idvmask rename_masks

RFFA_all_HORFFmasked.nii.gz: ./00_mk_coord_img.bash coords.txt
	./00_mk_coord_img.bash

idvmask: RFFA_all_HORFFmasked.nii.gz ./01_warp_to_subject.bash
	./01_warp_to_subject.bash

rename_masks: ./02_link_like_BL.bash idvmask
	./02_link_like_BL.bash
