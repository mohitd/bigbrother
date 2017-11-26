function getFeatures(c0,c1)
%Function is used to show SURF feature points
%   c0: image 1
%   c1: image 2
i_0 = rgb2gray(c0);
i_1 = rgb2gray(c1);
p_0 = detectSURFFeatures(i_0);
p_1 = detectSURFFeatures(i_1);
s_0 = p_0.selectStrongest(p_0.length);
s_1 = p_1.selectStrongest(p_1.length);
c0_loc = s_0.Location;
c1_loc = s_1.Location;
subplot(1, 2, 1), subimage(c0); 
hold on;
%Point display
r = 9;
r2 = 1;
%plot(c0_loc(r,1), c0_loc(r,2), 'g*');
plot(c0_loc(:,1), c0_loc(:,2), 'g*');
hold off
subplot(1, 2, 2), subimage(c1); 
hold on;
%plot(c1_loc(r2,1), c1_loc(r2,2), 'g*');
plot(c1_loc(:,1), c1_loc(:,2), 'g*');
hold off
pause;
end

