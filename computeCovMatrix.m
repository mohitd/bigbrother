function [covMatrix] = computeCovMatrix(roi)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

width = size(roi, 2);
height = size(roi, 1);

center = floor([height width] / 2);
featureMatrix = zeros(width * height, 4);

for row = 1:size(roi, 1)
    for col = 1:size(roi, 2)
        idx = sub2ind([height width], row, col);
        coord = [row col];
        radialDistance = sqrt(sum((coord - center) .^ 2));
        featureMatrix(idx, 1) = radialDistance;
        featureMatrix(idx, 2) = roi(row, col, 1);
        featureMatrix(idx, 3) = roi(row, col, 2);
        featureMatrix(idx, 4) = roi(row, col, 3);
    end
end

covMatrix = cov(featureMatrix, 1);

end

