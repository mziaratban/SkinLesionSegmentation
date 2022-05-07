clc
clear


% imageDir = 'K:\ISIC 2017\448x672\Images4Detection\train_img_aug4';
% detDir = 'ResultOfDetection\YoloRetinaR101_train_aug4';
% imageDir2 = 'ResultOfDetection\train_img4mask';

imageDir = 'K:\test_image2';
detDir = 'ResultOfDetection\retina_test2';
imageDir2 = 'ResultOfDetection\retinacat_test2';

% D = dir([imageDir,'\*.jpg']);
D = dir([imageDir,'\*.png']);

tic


for i=1:numel(D)
    
    fni = [imageDir,'\',D(i).name];
    I = imread(fni);

    fnd = [detDir,'\',D(i).name];
    d = imread(fnd);

    I2 = cat(3,I(:,:,1),I(:,:,2),d);
    fni2 = [imageDir2,'\',D(i).name(1:end-3),'jpg'];
    imwrite(I2,fni2)
    
    if mod(i,100)==0
        [i numel(D)]
        toc
    end
    i;

end