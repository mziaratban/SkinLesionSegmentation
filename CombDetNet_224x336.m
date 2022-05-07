clc
clear


Layers = [imageInputLayer([224 336 6],'Normalization','none','Name','Input');
% %% conv 0
%     convolution2dLayer(3,16,'Name','conv-0-1');
%     batchNormalizationLayer('Name','Batch-conv-0-1');
%     reluLayer('Name','Relu-conv-0-1');
%     
%     convolution2dLayer(3,32,'Name','conv-0-2');
%     batchNormalizationLayer('Name','Batch-conv-0-2');
%     reluLayer('Name','Relu-conv-0-2');
%     
%     maxPooling2dLayer(2,'Stride',2,'Name','pool-0');
    
%% conv 1    
    convolution2dLayer(3,64,'Name','conv-1-1');
    batchNormalizationLayer('Name','Batch-conv-1-1');
    reluLayer('Name','Relu-conv-1-1');
    
    convolution2dLayer(3,64,'Name','conv-1-2');
    batchNormalizationLayer('Name','Batch-conv-1-2');
    reluLayer('Name','Relu-conv-1-2');
    
%     convolution2dLayer(3,64,'Name','conv-1-3');
%     batchNormalizationLayer('Name','Batch-conv-1-3');
%     reluLayer('Name','Relu-conv-1-3');
    
    maxPooling2dLayer(2,'Stride',2,'Name','pool-1');
    
%% conv 2    
    convolution2dLayer(3,128,'Name','conv-2-1');
    batchNormalizationLayer('Name','Batch-conv-2-1');
    reluLayer('Name','Relu-conv-2-1');
    
    convolution2dLayer(3,128,'Name','conv-2-2');
    batchNormalizationLayer('Name','Batch-conv-2-2');
    reluLayer('Name','Relu-conv-2-2');
    
    convolution2dLayer(3,128,'Name','conv-2-3');
    batchNormalizationLayer('Name','Batch-conv-2-3');
    reluLayer('Name','Relu-conv-2-3');
    
    maxPooling2dLayer(2,'Stride',2,'Name','pool-2');
    
%% conv 3    
    convolution2dLayer(3,256,'Name','conv-3-1');
    batchNormalizationLayer('Name','Batch-conv-3-1');
    reluLayer('Name','Relu-conv-3-1');
    
    convolution2dLayer(3,256,'Name','conv-3-2');
    batchNormalizationLayer('Name','Batch-conv-3-2');
    reluLayer('Name','Relu-conv-3-2');
    
    maxPooling2dLayer(2,'Stride',2,'Name','pool-3');
    
%% conv 40 
    convolution2dLayer(3,256,'Name','conv-40-1');
    batchNormalizationLayer('Name','Batch-conv-40-1');
    reluLayer('Name','Relu-conv-40-1');
    
    convolution2dLayer(3,256,'Name','conv-40-2');
    batchNormalizationLayer('Name','Batch-conv-40-2');
    reluLayer('Name','Relu-conv-40-2');
    
%     maxPooling2dLayer(2,'Stride',2,'Name','pool-4');
    
%% conv 4    
    convolution2dLayer(3,512,'Name','conv-4-1');
    batchNormalizationLayer('Name','Batch-conv-4-1');
    reluLayer('Name','Relu-conv-4-1');
    
    convolution2dLayer(3,512,'Name','conv-4-2');
    batchNormalizationLayer('Name','Batch-conv-4-2');
    reluLayer('Name','Relu-conv-4-2');
    
%     maxPooling2dLayer(2,'Stride',2,'Name','pool-4');
    
%% conv 5
    convolution2dLayer(3,1024,'Name','conv-5-1');
    batchNormalizationLayer('Name','Batch-conv-5-1');
    reluLayer('Name','Relu-conv-5-1');
    
%% deconv 1
    transposedConv2dLayer(3,512,'Name','decv-1');
    batchNormalizationLayer('Name','Batch-decv-1');
    reluLayer('Name','Relu-decv-1');
    
%     upSampleLayer2x('ups-1');
    
%% deconv 2
    transposedConv2dLayer(3,512,'Name','decv-20-1');
    batchNormalizationLayer('Name','Batch-decv-20-1');
    reluLayer('Name','Relu-decv-20-1');
    
    transposedConv2dLayer(3,256,'Name','decv-20-2');
    batchNormalizationLayer('Name','Batch-decv-20-2');
    reluLayer('Name','Relu-decv-20-2');
    
    transposedConv2dLayer(3,256,'Name','decv-2-1');
    batchNormalizationLayer('Name','Batch-decv-2-1');
    reluLayer('Name','Relu-decv-2-1');
    
    transposedConv2dLayer(3,256,'Name','decv-2-2');
    batchNormalizationLayer('Name','Batch-decv-2-2');
    reluLayer('Name','Relu-decv-2-2');
    
    upSampleLayer2x('ups-2');
    
%% deconv 3
    transposedConv2dLayer(3,256,'Name','decv-3-1');
    batchNormalizationLayer('Name','Batch-decv-3-1');
    reluLayer('Name','Relu-decv-3-1');
    
    transposedConv2dLayer(3,128,'Name','decv-3-2');
    batchNormalizationLayer('Name','Batch-decv-3-2');
    reluLayer('Name','Relu-decv-3-2');
    
    upSampleLayer2x('ups-3');
    
%% deconv 4
    transposedConv2dLayer(3,128,'Name','decv-4-1');
    batchNormalizationLayer('Name','Batch-decv-4-1');
    reluLayer('Name','Relu-decv-4-1');
    
    transposedConv2dLayer(3,128,'Name','decv-4-2');
    batchNormalizationLayer('Name','Batch-decv-4-2');
    reluLayer('Name','Relu-decv-4-2');
    
    transposedConv2dLayer(3,64,'Name','decv-4-3');
    batchNormalizationLayer('Name','Batch-decv-4-3');
    reluLayer('Name','Relu-decv-4-3');
    
    upSampleLayer2x('ups-4');
    
%% deconv 5
    transposedConv2dLayer(3,64,'Name','decv-5-1');
    batchNormalizationLayer('Name','Batch-decv-5-1');
    reluLayer('Name','Relu-decv-5-1');
    
%     transposedConv2dLayer(3,32,'Name','decv-5-2');
%     batchNormalizationLayer('Name','Batch-decv-5-2');
%     reluLayer('Name','Relu-decv-5-2');
%     
%     transposedConv2dLayer(3,32,'Name','decv-5-3');
%     batchNormalizationLayer('Name','Batch-decv-5-3');
%     reluLayer('Name','Relu-decv-5-3');
%     
%     upSampleLayer2x('ups-5');
% 
% %% deconv 6
%     transposedConv2dLayer(3,16,'Name','decv-6-1');
%     batchNormalizationLayer('Name','Batch-decv-6-1');
%     reluLayer('Name','Relu-decv-6-1');
    
    transposedConv2dLayer(3,2,'Name','decv-5-2');
    batchNormalizationLayer('Name','Batch-decv-5-2');
    reluLayer('Name','Relu-decv-5-2');
    
%% classification
    softmaxLayer('Name','SoftMax');    
%     dicePixelClassificationLayer('Dice-Labels');
    pixelClassificationLayer('Name','Labels');
    ];
    

save CombDet_Layers_224x336_1   Layers
    
