clc
clear
close all

H = 448
W = 672

imageDir0 = 'K:\ISIC 2017\448x672\Images4Detection\Test img';
imageDir1 = 'ResultOfDetection\MaskX101_test1';
imageDir2 = 'ResultOfDetection\RetinaR101_test1';
imageDir3 = 'ResultOfDetection\Yolo2_test1';
imageDir = 'ResultOfDetection\DatResCat3_test1';
imageDir6 = 'ResultOfDetection\DatResCat6_test1';
imageDir62 = 'ResultOfDetection\DatResCat6_224x336_test1';

D = dir([imageDir1,'\*.png']);


for i=1:numel(D)
    fn0 = [imageDir0,'\',D(i).name];
    I0 = imread(fn0);
    fn1 = [imageDir1,'\',D(i).name];
    I1 = imread(fn1);
    fn2 = [imageDir2,'\',D(i).name];
    I2 = imread(fn2);
    fn3 = [imageDir3,'\',D(i).name];
    I3 = imread(fn3);

    I = cat(3,I1,I2,I3)/5;
    fn = [imageDir,'\',D(i).name];
    imwrite(I,fn);
    Icat6 = cat(3,I0,I);
    fn = [imageDir6,'\',D(i).name(1:end-3),'mat'];
    save(fn,'Icat6');
    Icat62 = cat(3,imresize(I0,0.5),imresize(I,0.5,'nearest'));
    fn = [imageDir62,'\',D(i).name(1:end-3),'mat'];
    save(fn,'Icat62');
    if mod(i,100)==0
        [i numel(D)]
    end
    
end
