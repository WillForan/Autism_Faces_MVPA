function makeMaskedSets_NewROIs_20190618

parseSubInfo;
subs=MVPAsubs(:,1);
numSubs=numel(subs);

masks={'A-AD-FFA','A-TD-FFA','C-AD-FFA','C-TD-FFA'};
numMasks=numel(masks);
maskfname='../results/%d.results/%d_%s_masked_space+orig';
savename='maskedSets/%d_%s_maskedSet';

datafname='../results/%d.results/stats.%d+orig';
brikIdxfname='../results/%d.results/%d_%s_memory_%s.txt';


for s=1:numSubs
    maskedSet.subID=subs(s);
    maskedSet.clin_group=MVPAsubs(s,2);
    maskedSet.age_group=MVPAsubs(s,3);
    maskedSet.age=MVPAsubs(s,4);
    maskedSet.VIQ=MVPAsubs(s,5);
    maskedSet.PIQ=MVPAsubs(s,6);
    maskedSet.FSIQ=MVPAsubs(s,7);
    
    faces_tval_idx=importdata(sprintf(brikIdxfname,subs(s),subs(s),'faces','tstat'));
    usa_tvals_idx=faces_tval_idx(1:6);
    aus_tvals_idx=faces_tval_idx(7:12);
    faces_bval_idx=importdata(sprintf(brikIdxfname,subs(s),subs(s),'faces','coef'));
    usa_bvals_idx=faces_bval_idx(1:6);
    aus_bvals_idx=faces_bval_idx(7:12);
    
    cars_tvals_idx=importdata(sprintf(brikIdxfname,subs(s),subs(s),'cars','tstat'));
    cars_bvals_idx=importdata(sprintf(brikIdxfname,subs(s),subs(s),'cars','coef'));

    tVals=[cars_tvals_idx usa_tvals_idx aus_tvals_idx];
    bVals=[cars_bvals_idx usa_bvals_idx aus_bvals_idx];
    
    for m=1:numMasks
        fprintf('preparing maskedSet for sub %d/%d, mask %d/%d......\n',s,numSubs,m,numMasks);
        thisMask=BrikLoad(sprintf(maskfname,subs(s),subs(s),masks{m}));
        thisMaskIdx=find(thisMask);
        
        if length(thisMaskIdx)<5; sprintf('%d',MVPAsubs(s));end
        
        tVal_samples=nan(length(thisMaskIdx),numel(tVals));
        bVal_samples=nan(length(thisMaskIdx),numel(bVals));
        thisDset=BrikLoad(sprintf(datafname,subs(s),subs(s)));
        for x=1:numel(tVals);
            thisBrik=thisDset(:,:,:,tVals(x));
            tVal_samples(:,x)=thisBrik(thisMaskIdx);
        end

        for x=1:numel(bVals);
            thisBrik=thisDset(:,:,:,bVals(x));
            bVal_samples(:,x)=thisBrik(thisMaskIdx);
        end
        maskedSet.tval_samples=tVal_samples;
        maskedSet.Bval_samples=bVal_samples;
        fprintf('saving maskedSet for sub %d/%d, mask %d/%d......\n',s,numSubs,m,numMasks);
        save(sprintf(savename,subs(s),masks{m}),'maskedSet');
    end
end
        