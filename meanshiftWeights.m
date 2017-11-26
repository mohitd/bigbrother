%% Problem 4
function [ w ] = meanshiftWeights( X, qModel, pTest, bins )

w = zeros(size(X, 1), 1);

for i = 1:size(X, 1)
    % figure out which bin this pixel belongs to (linear index)
    binR = floor(X(i,3) / (256 / bins)) + 1;
    binG = floor(X(i,4) / (256 / bins)) + 1;
    binB = floor(X(i,5) / (256 / bins)) + 1;
    bin = sub2ind([bins bins bins], binR, binG, binB);
    
    % Since each pixel belongs to exactly 1 bin and we know the bin,
    % we can directly compute w_i without having to loop over the entire
    % space. This is because w_i is nonzero ONLY when u = b(x_i) and we
    % know b(x_i) so we can compute w_i.
    w(i) = sqrt(qModel(bin)/pTest(bin));
end

