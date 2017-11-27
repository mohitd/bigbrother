function [metric] = covMetric(cov1,cov2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

generalizedEig = eig(cov1, cov2);
metric = sqrt(sum(log(generalizedEig) .^ 2));

end

