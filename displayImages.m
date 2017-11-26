function displayImages(c0, c1, c0_p, c1_p)
%Function displays the 2 images in a subplot with corresponding points
%   c0: image 1
%   c1: image 2
%   c0_p: point to plot in image 1
%   c1_p: point to plot in image 2

subplot(1, 2, 1), subimage(c0);
hold on
plot(c0_p(1), c0_p(2), 'g*'),
hold off
subplot(1, 2, 2), subimage(c1);
hold on
%Check if calculated point is located in image
if((c1_p(1) > 0 && c1_p(2) > 0) && (c1_p(1) <= size(c1, 2) && c1_p(2) <= size(c1, 1)))
    plot(c1_p(1), c1_p(2), 'g*');
else
    plot(size(c1, 2) / 2, size(c1, 1) / 2, 'rx', 'MarkerSize', 65);
end
hold off
drawnow;
end

