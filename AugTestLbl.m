clc
clear

H = 448
W = 672

imageDir = 'K:\ISIC 2017\448x672\Images4Detection\Test lbl';
imageDir2 = 'K:\test_lbl';
D = dir([imageDir,'\*.png']);

tic
for i=1:numel(D)
    fn = [imageDir,'\',D(i).name];
    g = imread(fn);
    fn2 = [imageDir2,'2\',D(i).name];
    fn3 = [imageDir2,'3\',D(i).name];
    fn4 = [imageDir2,'4\',D(i).name];
    fn5 = [imageDir2,'5\',D(i).name];
    fn6 = [imageDir2,'6\',D(i).name];
    imwrite(fliplr(g),fn2);
    imwrite(flipud(g),fn3);
    imwrite(rot90(g,2),fn4);
    imwrite(rot90(g,1),fn5);
    imwrite(rot90(g,3),fn6);
   i 
end
    
    
