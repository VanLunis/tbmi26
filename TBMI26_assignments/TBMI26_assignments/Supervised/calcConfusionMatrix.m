function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )
classes = unique(Ltrue);
numClasses = length(classes);
cM = zeros(numClasses);

% Add your own code here
for currObject = 1:length(Lclass)
    cM(Ltrue(currObject),Lclass(currObject)) = cM(Ltrue(currObject),Lclass(currObject)) + 1;
end

end

