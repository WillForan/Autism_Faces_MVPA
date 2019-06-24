.PHONY: all

RFFA_all_HORFFmasked.nii.gz: ./00_mk_coord_img.bash coords.txt
	./00_mk_coord_img.bash

all: RFFA_all_HORFFmasked.nii.gz ./01_warp_to_coreg.bash
	./01_warp_to_coreg.bash
