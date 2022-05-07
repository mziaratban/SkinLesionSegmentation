clc
clear
close all

H = 448
W = 672

se = fspecial('disk',340);
se(se<0.1*max(se(:))) = 0;
se(se>=0.1*max(se(:))) = 1;

% load TestDataTable4Detection_448x672
% load Train_aug3_DataTable4Detection_448x672

fn = 'detectron2 files\mask\results_5000_mask_X_101_FPN_3x_test1.json'
% fn = 'detectron2 files\mask\results_train_aug3_maskX101.json'

s = fileread(fn);
R = jsondecode(s)

id = zeros(1,numel(R));
sc = zeros(1,numel(R));
for i=1:numel(R)
    id(i) = R(i).image_id;
    sc(i) = R(i).score;
end


imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
% imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Train img aug3';

imageDir2 = 'ResultOfDetection\MaskX101_test1';
% imageDir2 = 'ResultOfDetection\MaskX101_train';

D = dir([imageDir,'\*.png']);


Scores = zeros(numel(D),1);
BBoxes = cell(numel(D),1);
SC = zeros(numel(D),1);
% BB = zeros(numel(D),4)-1;
Indx = zeros(numel(D),1)-1;

results = table('Size',[numel(D) 2],...
    'VariableTypes',{'cell','cell'},...
    'VariableNames',{'Boxes','Scores'});

tic
for i=1:numel(D)
    fni = [imageDir,'\',D(i).name];
    I = imread(fni);
    
    %     [t1,scores1,bboxes1] = fXYdetectiony3(fn,d,H,W,dh,dw);
    k = find(id==i-1);
    if numel(k)>0
        s = sc(k);
        [a,b] = max(s);
        Indx(i) = k(b);
        SC(i) = sc(k(b));
%         kb = k(b)
%         R(k(b))
        BB = floor(R(k(b)).bbox)+1;
        if BB(3)==673
            BB(3) = 672;
        end
        if BB(4)==449
            BB(4) = 448;
        end
    end
    
    
    scores = SC(i);
    bboxes = BB';
%% bboxes inverse transform

% 2
%     bboxes(1) = W-(bboxes(1)+bboxes(3))+2;
    
% % 3
%     bboxes(2) = H-(bboxes(2)+bboxes(4))+2;
%     
% % 4
%     bboxes(1) = W-(bboxes(1)+bboxes(3))+2;
%     bboxes(2) = H-(bboxes(2)+bboxes(4))+2;
%     
% %5
%     b = bboxes;
%     bboxes(1) = W-(b(2)+b(4))+2;
%     bboxes(2) = b(1);
%     bboxes(3) = b(4);
%     bboxes(4) = b(3);
%     
% % 6     
%     b = bboxes;
%     bboxes(1) = b(2);
%     bboxes(2) = H-(b(1)+b(3))+2;
%     bboxes(3) = b(4);
%     bboxes(4) = b(3);

    
    results.Boxes{i} = bboxes;
    results.Scores{i} = scores;
    Scores(i) = scores;
    BBoxes{i} = bboxes;
    
    if bboxes(1)<1
        bboxes(1) = 1;
    end
    if bboxes(2)<1
        bboxes(2) = 1;
    end
    if bboxes(3)>672
        bboxes(3) = 672;
    end
    if bboxes(4)>448
        bboxes(4) = 448;
    end
    
    %% write detection result image
    fn2 = [imageDir2,'\',D(i).name];
    Res = zeros(H,W);
    se2 = imresize(se,[bboxes(4),bboxes(3)],'nearest')*scores;
    Res(bboxes(2):bboxes(2)+bboxes(4)-1,bboxes(1):bboxes(1)+bboxes(3)-1) = se2;
%     Res(bboxes(2):bboxes(2)+bboxes(4)-1,bboxes(1):bboxes(1)+bboxes(3)-1) = scores;
    
%     ng = round((bboxes(4)+bboxes(3))/2*0.2+20);
%     gg = fspecial('gaussian',2*ng+1,ng/4);
%     Res = imfilter(Res,gg);
%     Res = Res*0.7+0.3;   
%     figure(888); imshow(Res)
    
    imwrite(Res,fn2);
    %     scores
    %     figure(8);imshow(R);
    if mod(i,100)==0
        [i numel(D)]
        toc
    end
end

% [ap,recall,precision] = evaluateDetectionPrecision(results,TestDataTable(:,2));
% ap = ap


% save  BoxScore_test1_Mask     ap results  Scores BBoxes
% save  BoxScore_trainaug3_Mask     ap results  Scores BBoxes





