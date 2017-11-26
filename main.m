%
% Big Brother
% Mohit Deshpande & Brad Pershon
% CSE 5524
% vid link: http://crcv.ucf.edu/projects/multipleCameras/multiple-cameras.php
% Sequence 3

c0Raw = VideoReader('campus4-c0.wmv');
c1Raw = VideoReader('campus4-c2.wmv');
vanRaw = VideoReader('van.mpg');

%Start feed at 8 seconds
start_time = 8; %62 for cross camera or 8 for start of person
c0Raw.CurrentTime = start_time;
c1Raw.CurrentTime = start_time;

%vanRaw.CurrentTime = 8;

%Homography rough estimate for campus
hc0_1 = [0.199046120558281,-0.234838536453450,18.4918054751990;0.242136439315655,1.16014640375115,-156.628129967629;0.00195851011987891,0.00689985580846464,-0.969263630906114];
%homography estimate for van
hv = [-0.0217520729234989,0.856129441419913,-102.488860336591;-0.0629133385268018,-0.547872008185205,37.6794937800455;0.000973516955072778,-0.00300901746189340,-0.0769403576320744];

%Mean-shift vars
c0_p = [161 117]; %point to track 62s = 302 100
bins = 16;
h = 25;
r = 7; %25
is_start = 1;

%van point
vanPoint1 = [47 88]; % kid 167 103 8s

while hasFrame(vanRaw) %Changed from c0Raw
    c0 = readFrame(c0Raw);
    c1 = readFrame(c1Raw);

    %Van Code
    vanFrame = readFrame(vanRaw);
    split = 192;
    vanFrame1 = vanFrame(:, 1:split, :);
    vanFrame2 = vanFrame(:, (split + 1):end, :);
    
    %SURF STUFF REMOVEME used to generate homography
    %getFeatures(vanFrame1,vanFrame2);
    
    %Mean Shift
    img_new = double(vanFrame1); %c0
    if(is_start == 1)
        is_start = 0;
        %X1 = circularNeighbors(img_new, c0_p(1), c0_p(2), r); 
        %qModel = colorHistogram(X1, bins, c0_p(1), c0_p(2), h);        
        
        X1 = circularNeighbors(img_new, vanPoint1(1), vanPoint1(2), r); 
        qModel = colorHistogram(X1, bins, vanPoint1(1), vanPoint1(2), h);
    else
        for i = 1:6 %<- Adjust for acc (was 5, set to 1 for H points)
        % construct candidate
        %X2 = circularNeighbors(img_new, c0_p(1), c0_p(2), r);
        %pTest = colorHistogram(X2, bins, c0_p(1), c0_p(2), h);
        
        X2 = circularNeighbors(img_new, vanPoint1(1), vanPoint1(2), r);%c0_p(1), c0_p(2)
        pTest = colorHistogram(X2, bins, vanPoint1(1), vanPoint1(2), h);%c0_p(1), c0_p(2)        
        % weights
        w = meanshiftWeights(X2, qModel, pTest, bins);
        % compute new value
        newX = sum([X2(:,1) X2(:,2)] .* [w w]) / sum(w);
        %c0_p = newX;
        vanPoint1 = newX;
        end
    end
  
    %Calc new pos in camera 2
    %c1_p = calcPoint(c0_p', hc0_1);
    vanPoint2 = calcPoint(vanPoint1', hv);
    %displayImages(c0, c1, c0_p, c1_p);
    displayImages(vanFrame1, vanFrame2, vanPoint1, vanPoint2);
    %break;
end