clc
clear


d = 50
H = 448
W = 672
dh = 150
dw = 200
H2 = 224

load  TestDataTable4Detection_448x672
load  BoxScore_test_Yolov2

imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
labelDir = 'K:\ISIC 2017\448x672\Images4Detection\Test lbl';

imageDir2 = 'Images4Segmentation\Test img';
labelDir2 = 'Images4Segmentation\Test lbl';

D = dir([imageDir,'\*.png']);



results = table('Size',[numel(D) 2],...
    'VariableTypes',{'cell','cell'},...
    'VariableNames',{'Boxes','Scores'});

XY = zeros(numel(D),4);


for i=1:numel(D)
    fni = [imageDir,'\',D(i).name];
    fng = [labelDir,'\',D(i).name];
    I = imread(fni);
    g = imread(fng);
    
    
    
    
    [II,gg] = fExtendImage(I,g,H,W);
    
    
    BBox = BBoxes{i};
    dx = max(d, round(0.29*BBox(4)));
    dy = max(d, round(0.29*BBox(3)));
    
    y1 = dw+BBox(1)-dy;
    y2 = dw+BBox(1)+BBox(3)+dy;
    x1 = dh+BBox(2)-dx;
    x2 = dh+BBox(2)+BBox(4)+dx;
    
    
    
    
    
    
    I2 = II(x1:x2,y1:y2,:);
    I3 = imresize(I2,[H2 H2]);
    %     figure(10);
    %     subplot(221); imshow(I);
    %     subplot(222); imshow(II);
    %     subplot(223); imshow(I2);
    %     subplot(224); imshow(I3);
    
    fni = [imageDir2,'\',D(i).name];
    fng = [labelDir2,'\',D(i).name];
    imwrite(I3,fni);
    
    g2 = gg(x1:x2,y1:y2);
    g3 = imresize(g2,[H2 H2],'nearest');
    imwrite(g3,fng);
    
    [i numel(D)]
    
    XY(i,:) = [x1,x2,y1,y2];
    
    
    results.Boxes{i} = BBox;
    results.Scores{i} =1;
    
end


[ap,recall,precision] = evaluateDetectionPrecision(results,TestDataTable(:,2));
ap

save  BoxXY_Yolo_224x336_1   XY  ap recall precision results

function  [x1,x2,y1,y2] = fBox(t)
[x,y] = find(t>0.5);
x1=max(1,min(x));  x2=max(x);
y1=max(1,min(y));  y2=max(y);
end

function [II,gg] = fExtendImage(I,g,H,W)

gg = padarray(g,[150 200],0,'both');
ii1 = [I(1:5,:,:) I(end-4:end,:,:)];    ii1 = reshape(ii1,[5*2*W 3]);
ii2 = [I(:,1:5,:); I(:,end-4:end,:)];   ii2 = reshape(ii2,[5*2*H 3]);
ii = [ii1 ; ii2];
v3 = round(mean(ii));

I1 = padarray(I(:,:,1),[150 200],v3(1),'both');
I2 = padarray(I(:,:,2),[150 200],v3(2),'both');
I3 = padarray(I(:,:,3),[150 200],v3(3),'both');
II = uint8(zeros(2*150+H,2*200+W,3));
II(:,:,1) = I1;
II(:,:,2) = I2;
II(:,:,3) = I3;
II(151,:,:) = II(1,:,:);
II(150+H,:,:) = II(1,:,:);
II(:,201,:) = II(:,1,:);
II(:,200+W,:) = II(:,1,:);
%figure(1); imshow(II,[])
end
