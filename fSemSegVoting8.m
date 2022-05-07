function  [c3,imAct] = fSemSegVoting8(I,net)

% imAct = [];
    C0 = semanticseg(I, net);
    I2 = imrotate(I,90);        C1 = semanticseg(I2, net);
    I2 = imrotate(I,-90);       C2 = semanticseg(I2, net);
    I2 = fliplr(I);             C3 = semanticseg(I2, net);
    I2 = flipud(I);             C4 = semanticseg(I2, net);
    I2 = imrotate(I,180);       C5 = semanticseg(I2, net);
    I2 = imrotate(I,45,'crop');        C6 = semanticseg(I2, net);
    I2 = imrotate(I,-45,'crop');       C7 = semanticseg(I2, net);
%     I2 = imrotate(I,22,'crop');        C7 = semanticseg(I2, net);
%     I2 = imrotate(I,-22,'crop');       C8 = semanticseg(I2, net);
    
    
    c1 = uint8(C0);    c2 = double(c1);                  c30 = ((c2-1)*255);
    c1 = uint8(C1);    c2 = double(imrotate(c1,-90));    c31 = ((c2-1)*255);
    c1 = uint8(C2);    c2 = double(imrotate(c1, 90));    c32 = ((c2-1)*255);
    c1 = uint8(C3);    c2 = double(fliplr(c1));          c33 = ((c2-1)*255);
    c1 = uint8(C4);    c2 = double(flipud(c1));          c34 = ((c2-1)*255);
    c1 = uint8(C5);    c2 = double(imrotate(c1,-180));   c35 = ((c2-1)*255);
    c1 = uint8(C6);    c2 = double(imrotate(c1,-45,'crop'));    c36 = ((c2-1)*255);
    c1 = uint8(C7);    c2 = double(imrotate(c1, 45,'crop'));    c37 = ((c2-1)*255);
%     c1 = uint8(C7);    c2 = double(imrotate(c1,-22,'crop'));    c37 = ((c2-1)*255);
%     c1 = uint8(C8);    c2 = double(imrotate(c1, 22,'crop'));    c38 = ((c2-1)*255);
    
% c3 = c30;
%     c3 = (c30+c31+c32)/3;
%     c3 = (c30+c33+c34)/3;
%     c3 = (c30+c31+c32+c33+c34)/5;
%     c3 = (c30+c31+c32+c33+c34+c35+c36)/7;
    c3 = (c30+c31+c32+c33+c34+c35+c36+c37)/8;
%     c3 = (c30+c31+c32+c33+c34+c35+c36)/9;

im1 = activations(net,I,'softmax-out');
imAct = im1(:,:,2);

% imMarker = single(im2bw(imAct,0.7));
% imMask = single(im2bw(imAct,0.3));
% % imMask = imAct;
% % imMask(imAct<0.65) = 0;
% % imMask(imAct>=0.65) = 0.65;
% im2 = imreconstruct(imMarker,imMask);
% 
% figure(51); 
% subplot(231); imshow(c30);
% subplot(232); imshow(imAct);
% subplot(233); imshow(I);
% subplot(234); imshow(imMarker);
% subplot(235); imshow(imMask);
% subplot(236); imshow(im2,[]);


