clc
clear
% close all

load CombDet_trainedNet_224x336_3
% load CombDet_trainedNet_224x336_GaussianOval

imgDir = ('ResultOfDetection\DatResCat6_224x336_test1');
labelDir = ('k:\ISIC 2017\448x672\Images4Detection\Test lbl');

D = dir([imgDir,'\*.mat']);

BBox = zeros(numel(D),4);
IOU = zeros(1,numel(D));
IOU3 = zeros(1,numel(D));
for i=1:numel(D)
    fn = [imgDir,'\',D(i).name];
    fn1 = [labelDir,'\',D(i).name(1:end-3),'png'];
    %     Ireference = im2double(imread(fn));
    g = (imread(fn1));
%     I = (imread(fn));
    load(fn);
    I = Icat62;
    
%     Iresult = activations(net,I,'Labels');
%     %     Iresult = activations(net,Ireference,'ReLU2');
%     %     Iresult = double(Iresult);
%     Ires = Iresult(:,:,2);
    Iresult = semanticseg(I,net);
    Ires = imresize(double(Iresult),[448 672],'nearest');
    Ires2 = logical(Ires-1);
    
    B = bwconncomp(Ires2);
    if B.NumObjects>1
        n = zeros(B.NumObjects,1);
        for j=1:B.NumObjects
            n(j) = numel(B.PixelIdxList{j});
        end
        [m,k] = max(n);
        p = B.PixelIdxList{k};
        Ires3 = false(size(Ires2));
        Ires3(p) = 1;
    else
        Ires3 = Ires2;
    end
    
    [xx,yy] = find(Ires3>0);
    if numel(xx)==0
        Ires3 = true(size(Ires3));
        [xx,yy] = find(Ires3>0);
    end
    x1 = min(xx);   x2 = max(xx);
    y1 = min(yy);   y2 = max(yy);
    
    BBox(i,:) = [y1 x1  y2-y1+1 x2-x1+1];
    
    iou = jaccard(Ires,double(uint8((g/255)+1)));
    iou3 = jaccard(double(Ires3)+1,double(uint8((g/255)+1)));
    
%     figure(5);
%     subplot(221);  imshow(I(:,:,1:3))
%     subplot(222);  imshow(Ires2,[]); xlabel(num2str(iou(2)));
%     subplot(223);  imshow(Ires3,[]); xlabel(num2str(iou3(2)));
%     subplot(224);  imshow(g)

    IOU(i) = iou(2);
    IOU3(i) = iou3(2);

    if mod(i,10)==0
        clc
        [i numel(D)]
        mean(IOU(1:i))
        mean(IOU3(1:i))
        
    end
    
    
end
meanIOU = mean(IOU)
meanIOU3 = mean(IOU3)
save  result_CombDet_test1_224x336_3    BBox IOU meanIOU  IOU3 meanIOU3 






