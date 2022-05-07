function  [t,scores,bboxes] = fXYdetection(detector2, I, d,H,W)

% [h0,w0,cc] = size(I);
% I = imresize(I,[H,W]);
h0 = H;
w0 = W;
[bboxes, scores] = detect(detector2, I);  %toc
% if size(bboxes,1)>0
%     bboxes(1) = round(bboxes(1)/W*w0);
%     bboxes(2) = round(bboxes(2)/H*h0);
%     bboxes(3) = round(bboxes(3)/W*w0);
%     bboxes(4) = round(bboxes(4)/H*h0);
% end
%     [bboxes, scores, labels] = detect(detector2, II(121:end-120,161:end-160,:));  %toc
if size(bboxes,1)==0
        x1=101;   x2=2*150+H-100;   y1=150+1;     y2=2*200+W-150;
        scores = 0;     bboxes = [1 1  W  H];
else
    if size(bboxes,1)>1
        [mm,xx] = max(scores);
        scores = scores(xx);
        bboxes = bboxes(xx,:);
    end
    %%%%%%%%%%%%%%%%%
    %         bboxes(1) = bboxes(1)-40;
    %         bboxes(2) = bboxes(2)-30;
    %%%%%%%%%%%%%%%%%
% if  bboxes(4)<360/2 && bboxes(3)<480/2
%     dx = max(d, round(0.8*bboxes(4)));
%     dy = max(d, round(0.8*bboxes(3)));
% else
%     dx = max(d, round(0.4*bboxes(4)));
%     dy = max(d, round(0.4*bboxes(3)));
% end

%     dx = round(7.5*bboxes(4)^0.5);
%     dy = round(9*bboxes(3)^0.5);

    dx = max(d, round(0.29*bboxes(4)));
    dy = max(d, round(0.29*bboxes(3)));
    
    y1 = 200+bboxes(1)-dy;
    y2 = 200+bboxes(1)+bboxes(3)+dy;
    x1 = 150+bboxes(2)-dx;
    x2 = 150+bboxes(2)+bboxes(4)+dx;
end
t = zeros(2*150+h0,2*200+w0);
% if scores<0.4
%     y1=200/2+1; x1=round(150/2)+1; y2=size(t,2)-200/2; x2=size(t,1)-round(150/2); %[x2,y2,z2]=size(II);
%     scores = 0;     bboxes = [1 1 h0 w0];
% end

t(x1:x2,y1:y2) = 1;

% bboxes
% r = 0.025;
% ht = round((x2-x1+1)*r);
% wt = round((y2-y1+1)*r);
% t = imdilate(t,ones(2*ht+1,2*wt+1));
% bboxes(1) = max(1, bboxes(1)-wt);
% bboxes(2) = max(1, bboxes(2)-ht);
% 
% bboxes(3) = bboxes(3)+2*wt;
% if bboxes(3)+bboxes(1)>W
%     db = bboxes(3)+bboxes(1)-W;
%     bboxes(3) = bboxes(3)-db;
% end
% 
% bboxes(4) = bboxes(4)+2*ht;
% if bboxes(4)+bboxes(2)>H
%     db = bboxes(4)+bboxes(2)-H;
%     bboxes(4) = bboxes(4)-db;
% end
% bboxes
% r;
% 