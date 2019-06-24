% 20190624 BL+WF 
% - run RSA on rois created in ROIs/20190614_Okamoto/
addpath('/usr/share/afni/matlab/')
cd RSA_scripts
makeMaskedSets_NewROIs_20190618()
makeCorMat_RSA_newROIs_20190618()
makeANOVAtable_newROIs_20190618()
