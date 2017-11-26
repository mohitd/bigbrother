%% Problem 3
function [ hist ] = colorHistogram( X, bins, x, y, h )

hist = zeros(bins, bins, bins);

% Since each pixel can only belong to one bin, we can 
% simply loop over each pixel in the region and directly figure out
% which bin it belongs to and update that bin's count.
% This prevents us from having to loop over the entire color cube.
for i = 1:size(X, 1)
    % figure out which bin this pixel belongs to
    binR = floor(X(i,3) / (256 / bins)) + 1;
    binG = floor(X(i,4) / (256 / bins)) + 1;
    binB = floor(X(i,5) / (256 / bins)) + 1;

    % epanechnikov kernel
    r = norm(([x y] - [X(i, 1) X(i, 2)]) / h) ^ 2;
    epanechnikov = (1 - r)*(r < 1);
    
    % accumulate bins in histogram
    hist(binR, binG, binB) = hist(binR, binG, binB) + epanechnikov;
end

% flatten and normalize
hist = reshape(hist, [bins*bins*bins, 1]);
hist = hist ./ sum(hist);
end
