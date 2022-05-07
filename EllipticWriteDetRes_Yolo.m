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
load Yolo_vgg19_mb8_ep30_sgdm_aug6916_Learn001_3337


% imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
% imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Train img aug3';
imageDir = 'K:\ISIC 2017\448x672\Images4Detection\train_img_aug4';

% imageDir2 = 'ResultOfDetection\Yolo2_test1';
% imageDir2 = 'ResultOfDetection\Yolo2_train';
imageDir2 = 'ResultOfDetection\Yolo2_train_aug4';

D = dir([imageDir,'\*.jpg']);


Scores = zeros(numel(D),1);
BBoxes = cell(numel(D),1);

results = table('Size',[numel(D) 2],...
    'VariableTypes',{'cell','cell'},...
    'VariableNames',{'Boxes','Scores'});
tic
for i=1:numel(D)
    fni = [imageDir,'\',D(i).name];
    I = imread(fni);
 
% 1    
    [scores,bboxes] = fXYdetection2(detector2, I,H,W);
% 2    
%     [scores,bboxes] = fXYdetection2(detector2, fliplr(I),H,W);
%     bboxes(1) = W-(bboxes(1)+bboxes(3))+2;
% 3    
%     [scores,bboxes] = fXYdetection2(detector2, flipud(I),H,W);
%     bboxes(2) = H-(bboxes(2)+bboxes(4))+2;
% 4    
%     [scores,bboxes] = fXYdetection2(detector2, rot90(I,2),H,W);
%     bboxes(1) = W-(bboxes(1)+bboxes(3))+2;
%     bboxes(2) = H-(bboxes(2)+bboxes(4))+2;
% 5    
%     [scores,bboxes] = fXYdetection2(detector2, rot90(I,1),W,H);
%     b = bboxes;
%     bboxes(1) = W-(b(2)+b(4))+2;
%     bboxes(2) = b(1);
%     bboxes(3) = b(4);
%     bboxes(4) = b(3);
% 6    
%     [scores,bboxes] = fXYdetection2(detector2, rot90(I,3),W,H);
%     b = bboxes;
%     bboxes(1) = b(2);
%     bboxes(2) = H-(b(1)+b(3))+2;
%     bboxes(3) = b(4);
%     bboxes(4) = b(3);
    
    
    


    results.Boxes{i} = bboxes;
    results.Scores{i} = scores;
    Scores(i) = scores;
    BBoxes{i} = bboxes;
    
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


% save  BoxScore_trainaug3_Yolov2     ap results  Scores BBoxes
% save  BoxScore_test2_Yolov1     ap results  Scores BBoxes





