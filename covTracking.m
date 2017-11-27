function [box] = covTracking(searchRegion,  cov, initialSize, K)
%UNTITLED Summary of this function goes here
%   searchRegion: MxNx3 region to search for best cov matching
%   cov: model covariance matrix
%   initialSize: [height width] of window
%   K: Qx1 scale initial size

boxes = [];
scores = [];
[height, width, ~] = size(searchRegion);

for i = 1:2
    for k = 1:size(K,1)
        windowSize = floor(K(k) .* initialSize);
        bestDistance = Inf;
        bestMatch = zeros(4);

        for r = 1:(height - windowSize(1) + 1)
            for c = 1:(width - windowSize(2) + 1)
                roi = searchRegion(r:(r+windowSize(1)-1), c:(c+windowSize(2)-1), :);
                roiCov = computeCovMatrix(roi);
                distance = covMetric(cov, roiCov);

                if distance < bestDistance
                    bestDistance = distance;
                    bestMatch = [c r windowSize(2) windowSize(1)];
                end

            end
        end
        
        if bestDistance == Inf
            continue
        end
        
        scores = [scores; bestDistance];
        boxes = [boxes; bestMatch];
    end
    
    % flip aspect ratio for next iteration
    initialSize = [initialSize(2) initialSize(1)];
end

% flip for NMS
scores = scores .* -1;

if size(boxes, 1) > 0
    [box,scores] = selectStrongestBbox(boxes, scores, 'OverlapThreshold', 0.05);
    
    % select box with largest score (smallest distance)
    [~, idx] = max(scores);
    box = box(idx, :);
    
else
    box = [0 0 0 0];
end

end

