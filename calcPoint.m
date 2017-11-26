function [ p1 ] = calcPoint( p0, H )
%Function calculates a point from one camera to another
%   p0: point in the original camera
%   H: Homography between camera 1 and camera 2

%Make homogeneous
p0 = [p0; 1];
p1 = H * p0;
%Scale by w
p1 = p1 ./ p1(3);
%Remove w
p1 = [p1(1) p1(2)];
end

