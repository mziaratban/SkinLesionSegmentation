clc
clear

load CombDet_Layers_224x336_1

classes = [    "Backg"    "Lesion"    ];
labelIDs = [0 255];

% imgDir = fullfile('K:\ISIC 2017\448x672\Images4Segmentation\Train img aug');
imgDir = 'ResultOfDetection\DatResCat6_224x336_train';
imdsTrain = imageDatastore(imgDir,'FileExtensions','.mat','ReadFcn',@matReader2);
labelDir = 'ResultOfDetection\Train lbl aug3 224x336';
pxdsTrain = pixelLabelDatastore(labelDir,classes,labelIDs);

% imgDir = fullfile('K:\ISIC 2017\448x672\Images4Segmentation\Valid img');
% imdsValid = imageDatastore(imgDir);
% labelDir = fullfile('K:\ISIC 2017\448x672\Images4Segmentation\Valid lbl');
% pxdsValid = pixelLabelDatastore(labelDir,classes,labelIDs);
% pximdsValid = pixelLabelImageDatastore(imdsValid,pxdsValid);

pximdsTrain = pixelLabelImageDatastore(imdsTrain,pxdsTrain);


%% the distribution of class labels 
tbl = countEachLabel(pxdsTrain)
% Visualize the pixel counts by class.
frequency = tbl.PixelCount/sum(tbl.PixelCount);
imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq


numTrainingImages = numel(imdsTrain.Files)
% numValImages = numel(imdsValid.Files)

% %% Create the Network
% numClasses = numel(classes);
% 
% pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
% pxLayer.Classes=tbl.Name;


options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',6,...
    'LearnRateDropFactor',0.3,...
    'InitialLearnRate',3e-3, ...
    'L2Regularization',0.005, ...
    'MaxEpochs',30, ...  
    'MiniBatchSize',12, ...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',100,...
    'Plots','training-progress');
%     'CheckpointPath', 'Checkpoints', ...
%     'ValidationData',pximdsValid,...
%     'ValidationFrequency',6600/12,...
%     'ValidationPatience', 10,... 

lgraph = layerGraph(Layers);
[net, info] = trainNetwork(pximdsTrain,lgraph,options);

save CombDet_trainedNet_224x336_3  net  info options
