% Load face and non-face data and plot a few examples
load faces;
load nonfaces;
faces = double(faces);
nonfaces = double(nonfaces);

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

% Generate Haar feature masks
nbrHaarFeatures = 40;
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1
nbrTrainExamples = 100;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError

numClassifiers = 40;
T = xTrain;
Weight = zeros(numClassifiers,size(xTrain,2));
Weight(1,:) = 1/size(xTrain,2)*ones(1,size(xTrain,2)); %starting weigths
Classification = zeros(size(xTrain));
%Error = zeros(size(xTrain));
alpha = zeros(4,numClassifiers);

for k = 1:numClassifiers
    Error = 0; %startepsilon, eps
    minError = [inf, 0, 0, 0]; %epsmin = Error, feature, threshold, P
    Cmin = 2*ones(1,size(xTrain,2));
    P = 1;
    for feature = 1:size(xTrain, 1) %features
        for tindex = 1:size(T,2) %thresholds
            Classification(feature,:) = WeakClassifier(T(feature, tindex), P, xTrain(feature,:));
            Error = WeakClassifierError(Classification(feature,:), Weight(k,:), yTrain);
            
            if 0.5 < Error && Error < 1 %Et tu Brute?
                Error = 1 - Error;
                P = -P;
                Classification(feature,:) = -Classification(feature,:);
            end
            
            if minError(1) > Error
                minError = [Error, feature, tindex, P];
                Cmin = Classification(feature,:);
            end
            
        end 
    end
    alpha(:,k) = [1/2*log((1-minError(1))/minError(1)); minError(2); minError(3); minError(4)];
    Cmin = 2*(Cmin~=yTrain)-1;
    Weight(k+1,:) = Weight(k,:).*exp(alpha(1,k)*Cmin);
    Weight(k+1,:) = 1/sum(Weight(k+1,:))*Weight(k+1,:);
end


%% Extract test data

nbrTestExamples = 40;

testImages  = cat(3,faces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)),...
                    nonfaces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,nbrTestExamples), -ones(1,nbrTestExamples)];

%% Evaluate your strong classifier here
%  You can evaluate on the training data if you want, but you CANNOT use
%  this as a performance metric since it is biased. You MUST use the test
%  data to truly evaluate the strong classifier.

result = zeros(1,size(xTest,2));
accTest = zeros(1,numClassifiers);
score = zeros(1,numClassifiers);
for index=1:numClassifiers
    result = result + alpha(1,index)*WeakClassifier(T(alpha(2,index), alpha(3,index)), alpha(4,index), xTest(alpha(2,index),:));
    score(index) = sum(sign(result)==yTest);
    accTest(index) = score(index)/length(yTest);
end
Accuracy = sum(sign(result)==yTest)/length(yTest);
Accuracy
wrongClasses = (sign(result)~=yTest);
%% Train accuracy
result = zeros(1,size(xTrain,2));
accTrain = zeros(1,numClassifiers);
for index=1:numClassifiers
    result = result + alpha(1,index)*WeakClassifier(T(alpha(2,index), alpha(3,index)), alpha(4,index), xTrain(alpha(2,index),:));
    accTrain(index) = sum(sign(result)==yTrain)/length(yTrain);
end
Accuracy = sum(sign(result)==yTrain)/length(yTrain);
Accuracy

%% Plot the error of the strong classifier as  function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.

figure(4);
plot(1:numClassifiers, accTest)
title('Accuracy plot for test data')
xlabel('# weak classifiers')
ylabel('Accuracy')

figure(5);
plot(1:numClassifiers, accTrain)
title('Accuracy plot for training data')
xlabel('# weak classifiers')
ylabel('Accuracy')

    %subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    figIndex = 5;
for imIndex = 1:(nbrTestExamples*2)
    if (wrongClasses(imIndex) == 1)
        figIndex = figIndex + 1;
        figure(figIndex);
        colormap gray;
        imagesc(testImages(:,:,imIndex));
        axis image;
        axis off;
    end
end