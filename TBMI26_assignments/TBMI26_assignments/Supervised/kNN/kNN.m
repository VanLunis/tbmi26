function [ labelsOut ] = kNN(X, k, Xt, Lt)
%KNN Your implementation of the kNN algorithm
%   Inputs:
%               X  - Features to be classified
%               k  - Number of neighbors
%               Xt - Training features
%               LT - Correct labels of each feature vector [1 2 ...]'
%
%   Output:
%               LabelsOut = Vector with the classified labels

labelsOut  = zeros(size(X,2),1);
classes = unique(Lt);
class = classes;
numClasses = length(classes);
[numFeatures,numToTrain] = size(Xt);
distance = zeros(numToTrain,1);


for currFeat = 1:length(X)
    List = [Xt' Lt distance];
    for currDist = 1:numToTrain
        distAcc = 0;
        for featureIndex = 1:numFeatures
            distAcc = distAcc + (X(featureIndex,currFeat)-Xt(featureIndex,currDist))^2;
        end
        List(currDist,numFeatures+2) = sqrt(distAcc);
    end
    sortedList = sortrows(List,numFeatures+2);
    classCounter = zeros(1,numClasses);
    for currNeigh = 1:k
        classCounter(1,sortedList(currNeigh,numFeatures+1)) = classCounter(1,sortedList(currNeigh,numFeatures+1)) + 1;
    end
    [voteNumber, maxClass] = max(classCounter);
    labelsOut(currFeat) = maxClass;
end

