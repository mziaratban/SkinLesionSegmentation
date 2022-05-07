clc
clear

H = 448
W = 672

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

    
% imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Valid lbl';

D = dir([imageDir,'\*.png']);

tic

for i=1:numel(D)
    
    fni = [imageDir,'\',D(i).name];
    masks = imread(fni);
    
    Rs = MaskApi.encode( masks );
    i;
    
end
