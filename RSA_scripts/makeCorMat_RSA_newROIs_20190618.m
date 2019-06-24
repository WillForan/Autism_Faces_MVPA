function makeCorMat_RSA_newROI_20190618
%RSA analysis for face and car stimuli
savename=mfilename;

parseSubInfo;
subjects=MVPAsubs(:,1);
numSubs=numel(subjects);

masks={'L_fusi_ffa','R_fusi_ffa','HO_L_amy','HO_L_fusiform',...
    'HO_L_IFG','HO_L_inftemporal','HO_L_TPJ','HO_L_suptemporal'...
    'HO_R_amy','HO_R_fusiform','HO_R_IFG',...
    'HO_R_inftemporal','HO_R_TPJ','HO_R_suptemporal',...
    'A-AD-FFA','A-TD-FFA','C-AD-FFA','C-TD-FFA'};
numMasks=numel(masks);
maskedSetfname='maskedSets/%d_%s_maskedSet';

conds={'cars','faces_usa','faces_aus'};
numConds=numel(conds);

corMatsT=cell(numSubs,numMasks);
corMatsB=cell(numSubs,numMasks);
offDiagIdx=find(triu(ones(18),1));

subVoxCounts=nan(numSubs,numMasks);

for s=1:numSubs
    for m=1:numMasks
        load(sprintf(maskedSetfname,subjects(s),masks{m}));
        if size(maskedSet.tval_samples,1)<=6
            disp(masks{m});disp(subjects(s));
            subIdx(s,m)=0;
            continue
        else
            subIdx(s,m)=1;
        end
        
        subVoxCounts(s,m)=size(maskedSet.tval_samples,1);
        
        tvals=maskedSet.tval_samples;
%         if any(size(tvals(:))==[0 0]);disp(subjects{s});end
        Bvals=maskedSet.Bval_samples;
        
%         r=corrcoef(tvals);r=1-r;
%         corMatsT{s,m}=r(offDiagIdx);
%         r=corrcoef(Bvals);r=1-r;
%         corMatsB{s,m}=r(offDiagIdx);
% Don't do corr distance yet
        r=corrcoef(tvals);
        if sum(isnan(r(:)))~=0
            fprintf('bad correlation for %d %s\n',subjects(s),masks{m});
        end
        corMatsT{s,m}=r(offDiagIdx);
        r=corrcoef(Bvals);
        corMatsB{s,m}=r(offDiagIdx);
    end
    clin_label(s,1)=maskedSet.clin_group;
    age_label(s,1)=maskedSet.age_group;
    age(s,1)=maskedSet.age; 
end 
save(savename,'corMatsB','corMatsT','clin_label','age_label','age','subjects',...
    'masks','conds','subIdx');
csvwrite('subject_voxel_counts_newROIs_20190618.csv',subVoxCounts);
end


