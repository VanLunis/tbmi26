function [ optimalK ] = crossValidation( dataSetNr,numBins, maxK)
% This script will help you test out your kNN code

% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

[X, D, L] = loadDataSet( dataSetNr );

% You can plot and study dataset 1 to 3 by running:
% plotCase(X,D)

% Select a subset of the training features

numSamplesPerLabelPerBin = inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
% XBin1 = Xt{1};

% Use kNN to classify data
% Note: you have to modify the kNN() function yourselfs.

accuracy = zeros(1,maxK);


for k =1:maxK
    accCum = 0;
    
    for currValidator = 1:numBins
        Xtrain = [];
    Ltrain = [];
        for currBin = 1:numBins
            if (currBin ~= currValidator)
                Xtrain = [Xtrain Xt{currBin}];
                Ltrain = [Ltrain; Lt{currBin}];
            end
        end
        % Now we have a block of training data!
        LkNN = kNN(Xt{currValidator}, k, Xtrain, Ltrain);
        cM = calcConfusionMatrix(LkNN,Lt{currValidator});
        accCum = accCum + calcAccuracy(cM);
    end
    accuracy(1,k) = accCum/numBins;
end

[kBestNum, kBest] = max(accuracy);

optimalK = kBest;
end