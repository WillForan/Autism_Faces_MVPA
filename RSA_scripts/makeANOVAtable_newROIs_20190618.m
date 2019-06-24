function makeANOVAtable_20140509

savename=mfilename;

excelfname='RSA_ANOVA_table';
excel_headers={'subID','age_grp','clin_grp','cc','cf','ff','ff_uu','ff_aa','ff_ua'};

%set up comparison labels
cf=[16:21,22:27,29:34,37:42,46:51,56:61,67:72,79:84,92:97,106:111,121:126,137:142];
cc=1:15;
% ff=setdiff(1:153,[cc cf]);
ff=setdiff(1:153,[cc cf]);
ffuu=[28,35,36,43:45,52:55,62:66];ffaa=[91,104,105,118:120,133:136,149:153];
ffua=setdiff(ff,[ffuu ffaa]);

labels=[];
labels(cc)=1;
labels(cf)=2;
labels(ff)=3;
labels=labels';

%data storage
maskData=cell(1,2);

%variables
parseSubInfo;
subjects=MVPAsubs(:,1);
%subjects={'102','103','104','105','109','110','111','112','113','115','116',...
%    '121','124','125','128','129','130','131','135','136','141','143','144',...
%    '146','147','148','149','150','153','156','158','160','164','167','168',...
%    '170','174','177','178','179','182','183','184','186','191','193','194',...
%    '195','196','200','203','204','206','207','210','213','215','217',...
%    '218','223','225','226','227','229','231','232','233','234','235','236',...
%    '240','241','242','243','244','245','246','247','251','252','255','256',...
%    '259','261','262','263','266','267'};
%PROBLEM WITH 211
numSubs=numel(subjects);

masks={'A-AD-FFA','A-TD-FFA','C-AD-FFA','C-TD-FFA'};
numMasks=numel(masks);
maskedSetfname='maskedSets/%d_%s_maskedSet';

% savename=[savename '_GxA'];
savename=[savename '_multi_area'];

offDiagIdx=find(triu(ones(18),1));

for m=1:numMasks
    subData=[];
    for s=1:numSubs
        thisSubData=[];
        load(sprintf(maskedSetfname,subjects(s),masks{m}));
        if size(maskedSet.tval_samples,1)<=6
            disp(subjects(s));
            subIdx(s,m)=0;
            continue
        else
            subIdx(s,m)=1;
        end
        tvals=maskedSet.tval_samples;
        Bvals=maskedSet.Bval_samples;
        
        r=corrcoef(tvals);
%         %make a version with r values
%         zr=r;
        zr=(1/2)*log((1+r)./(1-r));
        
        
        zrv=zr(offDiagIdx);
%         r=corrcoef(Bvals);
%         corMatsB{s,m}=r(offDiagIdx);
        mcc=mean(zrv(cc));
        mcf=mean(zrv(cf));
        mff=mean(zrv(ff));
        mffuu=mean(zrv(ffuu));
        mffaa=mean(zrv(ffaa));
        mffua=mean(zrv(ffua));
%         thisSubData(1:length(labels),1)=str2num(subjects{s});
%         thisSubData(:,2)=zr(offDiagIdx);
%         thisSubData(:,3)=labels;     

        thisSubData{1,1}=subjects(s);
        thisSubData{1,2}=maskedSet.age_group;
        thisSubData{1,3}=maskedSet.clin_group;
        thisSubData{1,4}=mcc;
        thisSubData{1,5}=mcf;
        thisSubData{1,6}=mff;
        thisSubData{1,7}=mffuu;
        thisSubData{1,8}=mffaa;
        thisSubData{1,9}=mffua;
        subData=[subData;thisSubData];
    end
    maskData{m}=[excel_headers;subData];
    ds=cell2dataset(maskData{m});
    export(ds,'file',[excelfname '_' masks{m} '.txt'],'Delimiter',',')
%     xlswrite(excelfname,maskData{m},m);
end 

save(savename,'maskData')
