clc
clear

fn = 'detectron2 files\balloon_test_coco_format.json'
s = fileread(fn);
F = jsondecode(s)

d = 50
H = 448
W = 672
dh = 150
dw = 200
H2 = 224

% se = fspecial('disk',20);% , sp=500 => J= 83.49
se = fspecial('disk',20);%
m = max(se(:));
se(se>0.1*m) = 1;
se(se<=0.1*m) = 0;

fn1 = 'detectron2 files\mask\results of mask\results_5000_mask_X_101_FPN_3x_test1.json';
fn2 = 'detectron2 files\mask\results of mask\results_5000_mask_X_101_FPN_3x_test2.json';
fn3 = 'detectron2 files\mask\results of mask\results_5000_mask_X_101_FPN_3x_test3.json';
fn4 = 'detectron2 files\mask\results of mask\results_5000_mask_X_101_FPN_3x_test4.json';

% fn = 'detectron2 files\retina\results_5000_retinanet_R_101_FPN_3x_test1.json'

% fn = 'detectron2 files\mask\results_retinacat_test1.json'


s = fileread(fn1);      R1 = jsondecode(s);
s = fileread(fn2);      R2 = jsondecode(s);
s = fileread(fn3);      R3 = jsondecode(s);
s = fileread(fn4);      R4 = jsondecode(s);

% first set the current path to: 'K:\ISIC 2017\448x672\Detectron2\cocoapi-master\MatlabAPI'
% then run :
% mex('CFLAGS=\$CFLAGS -Wall -std=c99','-largeArrayDims',...
%       'private/maskApiMex.c','../common/maskApi.c',...
%       '-I../common/','-outdir','private');

  %  Rs     = MaskApi.encode( masks )
%    masks  = MaskApi.decode( R(1).segmentation );
  %  R      = MaskApi.merge( Rs, [intersect=false] )
  %  o      = MaskApi.iou( dt, gt, [iscrowd=false] )
  %  keep   = MaskApi.nms( dt, thr )
  %  a      = MaskApi.area( Rs )
  %  bbs    = MaskApi.toBbox( Rs )
  %  Rs     = MaskApi.frBbox( bbs, h, w )
  %  R      = MaskApi.frPoly( poly, h, w )

    
imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';

D = dir([imageDir,'\*.png']);

tic

IOU = zeros(numel(D),1);
TP = zeros(numel(D),1);
TN = zeros(numel(D),1);
FP = zeros(numel(D),1);
FN = zeros(numel(D),1);
    
ss1 = zeros(numel(R1),1);   iid1 = ss1;
ss2 = zeros(numel(R2),1);   iid2 = ss2;
ss3 = zeros(numel(R3),1);   iid3 = ss3;
ss4 = zeros(numel(R4),1);   iid4 = ss4;
for i=1:numel(R1)
    ss1(i) = R1(i).score;    iid1(i) = R1(i).image_id;
    ss2(i) = R2(i).score;    iid2(i) = R2(i).image_id;
    ss3(i) = R3(i).score;    iid3(i) = R3(i).image_id;
    ss4(i) = R4(i).score;    iid4(i) = R4(i).image_id;
end

for i=1:numel(D)
    
    fni = [imageDir,'\',D(i).name];
    I0 = imread(fni);
    imOrig = double(imread(['K:\ISIC 2017\448x672\Images4Detection\Test lbl\',D(i).name]));

    %% 1
    k = find(iid1==i-1);
    if numel(k)>0
        sc = ss1(k);
        [m,n] = max(sc);
        imRes1  = double(MaskApi.decode( R1(k(n)).segmentation ))*255;
    else
        imRes1 = zeros(H,W);
    end
    i;
    %% 2
    k = find(iid2==i-1);
    if numel(k)>0
        sc = ss2(k);
        [m,n] = max(sc);
        imRes1  = double(MaskApi.decode( R2(k(n)).segmentation ))*255;
        imRes2 = fliplr(imRes1);
    else
        imRes2 = zeros(H,W);
    end
    i;
    %% 3
    k = find(iid3==i-1);
    if numel(k)>0
        sc = ss3(k);
        [m,n] = max(sc);
        imRes1  = double(MaskApi.decode( R3(k(n)).segmentation ))*255;
        imRes3 = flipud(imRes1);
    else
        imRes3 = zeros(H,W);
    end
    i;
    %% 4
    k = find(iid4==i-1);
    if numel(k)>0
        sc = ss4(k);
        [m,n] = max(sc);
        imRes1  = double(MaskApi.decode( R4(k(n)).segmentation ))*255;
        imRes4 = rot90(imRes1,2);
    else
        imRes4 = zeros(H,W);
    end
    i;
%% 1234
    imRes = (imRes1+imRes2+imRes3+imRes4)/4;
    th = 65;
    imRes(imRes>th) = 255;
    imRes(imRes<=th) = 0;
    
    iou1 = jaccard(imRes/255+1,double(uint8((imOrig/255)+1)));
    
    ROI1 = logical(imRes);
    ROI = imdilate(ROI1,se);
    %% Grabcut
    
    L = superpixels(imOrig,400,'NumIterations',50);
    imRes = grabcut(imOrig,L,ROI,'MaximumIterations',50)*255;
    
    

%% Jaccard    
    iou = jaccard(imRes/255+1,double(uint8((imOrig/255)+1)));
    k = find(imRes==255 & imOrig==255);    TP(i) = numel(k)/numel(imRes);
    k = find(imRes==000 & imOrig==000);    TN(i) = numel(k)/numel(imRes);
    k = find(imRes==000 & imOrig==255);    FN(i) = numel(k)/numel(imRes);
    k = find(imRes==255 & imOrig==000);    FP(i) = numel(k)/numel(imRes);
    
%     figure(90); 
%     subplot(321);  imshow(mod(L,100)/100);
%     subplot(322);  imshow((imOrig));
%     subplot(323);  imshow(ROI1*0.5+ROI*0.5);    xlabel(num2str(iou1(2)));
%     subplot(324);  imshow(imRes);           xlabel(num2str(iou(2)));
%     subplot(325);  imshow(I0);           xlabel(num2str(iou(2)));
    
    
    IOU(i) = iou(2);
    if mod(i,100)==0
        [i numel(D) mean(IOU(1:i))]
        toc
    end
    i;
end




% pp = sum(Pos)
% nn = sum(Neg)


meanIOU = mean(IOU);
IOU65 = IOU;
IOU65(IOU<=0.65) = 0;
meanIOU65 = mean(IOU65);

tp = sum(TP);
tn = sum(TN);
fp = sum(FP);
fn = sum(FN);
[tp tn fp fn];

TPR1 = mean(TP./(TP+FN));
FPR1 = mean(FP./(FP+TN));
tpr = [0 TPR1 1];
fpr = [0 FPR1 1];

% figure(11); plot(fpr,``tpr)

AUC = 0.5*TPR1*FPR1 + TPR1*(1-FPR1) + 0.5*(1-TPR1)*(1-FPR1)
SPC = 1-FPR1
SEN = TPR1
DIC = mean(2*TP./(2*TP+FP+FN))
ACC = mean((TP+TN)./(TP+TN+FP+FN))
JAC = mean(TP./(TP+FP+FN))
% MCC = mean((TP.*TN-FP.*FN)./((TP+FP).*(TP+FN).*(TN+FP).*(TN+FN)).^0.5)


% save IOU_Final_Mask_test1     IOU  meanIOU  meanIOU65  TP TN FP FN AUC SPC SEN DIC ACC JAC MCC
% save IOU_Final_Retina_test1     IOU  meanIOU  meanIOU65  TP TN FP FN AUC SPC SEN DIC ACC JAC MCC

