function displayImages(c0, c1, c0_p, extents, c1_p, match, searchRegion, dir, fn)
%Function displays the 2 images in a subplot with corresponding points
%   c0: image 1
%   c1: image 2
%   c0_p: point to plot in image 1
%   c1_p: point to plot in image 2

h = figure;

subplot(1, 2, 1), subimage(c0);
hold on
plot(c0_p(1), c0_p(2), 'g*'),
rectangle('Position',[c0_p-extents 2.*extents],...
          'EdgeColor', 'r',...
          'LineWidth',1);
hold off
subplot(1, 2, 2), subimage(c1);
hold on
%Check if calculated point is located in image
if((c1_p(1) > 0 && c1_p(2) > 0) && (c1_p(1) <= size(c1, 2) && c1_p(2) <= size(c1, 1)))
    %plot(c1_p(1), c1_p(2), 'g*');
    rectangle('Position',[searchRegion(1,:) searchRegion(2,:) - searchRegion(1,:)],...
          'EdgeColor', 'b',...
          'LineWidth',1);
    rectangle('Position',match,...
          'EdgeColor', 'r',...
          'LineWidth',1);
else
    plot(size(c1, 2) / 2, size(c1, 1) / 2, 'rx', 'MarkerSize', 65);
end
hold off

filename = [sprintf('%03d',fn) '.jpg'];
fullname = fullfile(dir,'images',filename);
saveas(h, fullname);
close(h);

drawnow;
end

