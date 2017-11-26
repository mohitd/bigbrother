%% Problem 2
function [ X ] = circularNeighbors( img, x, y, radius )

X = [];

for r = 1:size(img, 1)
    for c = 1:size(img, 2)
        if (r-y) ^ 2 + (c-x) ^ 2 < radius^2
            % don't re-center the indices since we use x, y later
            % (functions are generic enough to take any center point x, y)
            X = [X; [c r img(r,c,1) img(r,c,2) img(r,c,3) ]];
        end
    end
end
    
end
