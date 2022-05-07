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

fn = 'detectron2 files\mask\results_5000_mask_X_101_FPN_3x_test1.json'
% fn = 'detectron2 files\results_5000_faster_rcnn_X_101_32x8d_FPN_3x.json'
% fn = 'detectron2 files\results_5000_faster_rcnn_X_101_32x8d_FPN_3x.json'
s = fileread(fn);
R = jsondecode(s)


mex('CFLAGS=\$CFLAGS -Wall -std=c99','-largeArrayDims',...
      'private/maskApiMex.c','../common/maskApi.c',...
      '-I../common/','-outdir','private');

  %  Rs     = MaskApi.encode( masks )
%    masks  = MaskApi.decode( R(1).segmentation );
  %  R      = MaskApi.merge( Rs, [intersect=false] )
  %  o      = MaskApi.iou( dt, gt, [iscrowd=false] )
  %  keep   = MaskApi.nms( dt, thr )
  %  a      = MaskApi.area( Rs )
  %  bbs    = MaskApi.toBbox( Rs )
  %  Rs     = MaskApi.frBbox( bbs, h, w )
  %  R      = MaskApi.frPoly( poly, h, w )

for i=1:600
    
   masks  = MaskApi.decode( R(i).segmentation );
    figure(90); imshow(masks*255);
    
end


id = zeros(1,numel(R));
sc = zeros(1,numel(R));
for i=1:numel(R)
    id(i) = R(i).image_id;
    sc(i) = R(i).score;
end

load TestDataTable4Detection_448x672

imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
labelDir = 'K:\ISIC 2017\448x672\Images4Detection\Test lbl';
% imageDir2 = 'Images4Segmentation\Test img hair removed';
imageDir2 = 'Images4Segmentation\Test img';
labelDir2 = 'Images4Segmentation\Test lbl';
D = dir([imageDir,'\*.png']);



results = table('Size',[numel(D) 2],...
    'VariableTypes',{'cell','cell'},...
    'VariableNames',{'Boxes','Scores'});
Indx = zeros(600,1)-1;
ID = zeros(600,1)-1;
SC = zeros(600,1);
BB = zeros(600,4)-1;
XY = zeros(600,4);


for i=1:numel(D)
    fni = [imageDir,'\',D(i).name];
    fng = [labelDir,'\',D(i).name];
    I = imread(fni);
    g = imread(fng);
    
    [II,gg] = fExtendImage(I,g,H,W);
    
    
    k = find(id==i-1);
    if numel(k)>0
        s = sc(k);
        %         ks = find(s>0.0.5);
        %         if numel(ks)<=1
        [a,b] = max(s);
        Indx(i) = k(b);
        ID(i) = id(k(b))+1;
        SC(i) = sc(k(b));
        BB(i,:) = floor(R(k(b)).bbox)+1;
        %         else
        %             bb = R(k(ks)).bbox;
        %             BB(i,:) = floor(mean(bb))+1;
        %             ss = sc(k(ks));
        %             SC(i) = mean(ss);
        %         end
        if BB(i,3)==673
            BB(i,3) = 672;
        end
        if BB(i,4)==449
            BB(i,4) = 448;
        end
        dx = max(d, round(0.29*BB(i,4)));
        dy = max(d, round(0.29*BB(i,3)));
        
        y1 = dw+BB(i,1)-dy;
        y2 = dw+BB(i,1)+BB(i,3)+dy;
        x1 = dh+BB(i,2)-dx;
        x2 = dh+BB(i,2)+BB(i,4)+dx;
    else
        ID(i) = i;
        BB(i,:) = [1 1 672 448];
        x1=dh-50+1;   x2=2*dh+H-(dh-50);   y1=dw-50+1;     y2=2*dw+W-(dw-50);
    end
    
    
    %     h0 = H;
    % w0 = W;
    
    % t = zeros(2*dh+h0,2*dw+w0);
    % t(x1:x2,y1:y2) = 1;
    % [x1,x2,y1,y2] = fBox(t);
    
    
    
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
    
    
    results.Boxes{i} = BB(i,:);
    results.Scores{i} = SC(i);
    
end


[ap,recall,precision] = evaluateDetectionPrecision(results,TestDataTable(:,2));
ap

save  BoxXY_faster_rcnn_X_101_32x8d_FPN_3x_5000ep   XY SC ap recall precision results

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