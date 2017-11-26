%
% Big Brother
% Mohit Deshpande & Brad Pershon
% CSE 5524
%

c0Raw = VideoReader('campus4-c0.wmv');
c1Raw = VideoReader('campus4-c2.wmv');
%Start feed at 8 seconds
start_time = 8; %62 for cross camera
c0Raw.CurrentTime = start_time;
c1Raw.CurrentTime = start_time;

%Homography rough estimate
hc0_1 = [0.199046120558281,-0.234838536453450,18.4918054751990;0.242136439315655,1.16014640375115,-156.628129967629;0.00195851011987891,0.00689985580846464,-0.969263630906114];

%Mean-shift vars
c0_p = [161 117]; %point to track 62s = 302 100
bins = 16;
h = 25;
r = 7; %25
is_start = 1;

while hasFrame(c0Raw)
    c0 = readFrame(c0Raw);
    c1 = readFrame(c1Raw);
    c1_p = calcPoint(c0_p', hc0_1);
    
    %SURF STUFF REMOVEME used to generate homography
    %getFeatures(c0,c1)
    
    %Mean Shift
    img_new = double(c0);
    if(is_start == 1)
        is_start = 0;
        X1 = circularNeighbors(img_new, c0_p(1), c0_p(2), r);
        qModel = colorHistogram(X1, bins, c0_p(1), c0_p(2), h);
    else
        for i = 1:6 %<- Adjust for acc (was 5, set to 1 for H points)
        % construct candidate
        X2 = circularNeighbors(img_new, c0_p(1), c0_p(2), r);
        pTest = colorHistogram(X2, bins, c0_p(1), c0_p(2), h);
        % weights
        w = meanshiftWeights(X2, qModel, pTest, bins);
        % compute new value
        newX = sum([X2(:,1) X2(:,2)] .* [w w]) / sum(w);
        c0_p = newX;
        end
    end
    
    displayImages(c0, c1, c0_p, c1_p);
end