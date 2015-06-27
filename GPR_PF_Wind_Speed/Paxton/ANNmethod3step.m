% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by NFTOOL
% Created Thu Jul 18 15:48:18 EDT 2013
%
% This script assumes these variables are defined:
%
%   past1 - input data.
%   future - target data.

clc;
clear;
close all;

load paxton;
paxton=paxton+5;
x1=paxton(1:800);
x2=paxton(2:801);
x3=paxton(3:802);
x4=paxton(4:803);
x5=paxton(5:804);
x6=paxton(6:805);
x7=paxton(7:806);
x8=paxton(8:807);


past1=[x7, x6, x5, x4, x3];
past3=[x5, x4, x3, x2, x1];

future=x8;
Xtrain1=past1(1:500,:);
Xtrain3=past3(1:500,:);
Ytrain=future(1:500);

Xtest1=past1(501:800,:);
Xtest3=past3(501:800,:);
Ytest=future(501:800);

inputs = past3';
targets = future';

% Create a Fitting Network
hiddenLayerSize = 25;
net = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'divideind';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainInd = 1:200;
net.divideParam.valInd = 201:500;
net.divideParam.testind = 501:800;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);
valPerformance = perform(net,valTargets,outputs);
testPerformance = perform(net,testTargets,outputs);

% View the Network
% view(net);

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotfit(net,inputs,targets)
%figure, plotregression(targets,outputs)
%figure, ploterrhist(errors)

Yhat3ANN=outputs(501:800)';

[R23ANN,RMSE3ANN]=rsquare(Ytest,Yhat3ANN);
MAPE3ANN = mean(abs(Yhat3ANN-Ytest)./Ytest);

figure
plot(Ytest,'LineWidth',3);
hold on
plot(Yhat3ANN,'--r','LineWidth',3);
legend('Actual Y','Predicted Y')
xlabel('Sample');
ylabel('Y');
