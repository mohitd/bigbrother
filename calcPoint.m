function [ transformedPoints ] = calcPoint( pts, H )
%Function calculates a point from one camera to another
%   p0: M x 2 matrix of M points
%   H: Homography to apply

%Make homogeneous
pts(:,3) = 1;
transformedPoints =  (H * pts')';
%Scale by w
transformedPoints = transformedPoints ./ transformedPoints(:, 3);
%Remove w
transformedPoints(:, 3) = [];
end

