%
% Big Brother
% Mohit Deshpande & Brad Pershon
% CSE 5524
% vid link: http://crcv.ucf.edu/projects/multipleCameras/multiple-cameras.php
% Sequence 3

vanRaw = VideoReader('van.mpg');

%vanRaw.CurrentTime = 8;

%homography estimate for van
hv = [-0.0217520729234989,0.856129441419913,-102.488860336591;-0.0629133385268018,-0.547872008185205,37.6794937800455;0.000973516955072778,-0.00300901746189340,-0.0769403576320744];

%Mean-shift vars
bins = 16;
h = 25;
r = 7; %25
is_start = 1;

%van point
vanPoint1 = [47 88]; % kid 167 103 8s

while hasFrame(vanRaw)
    %Van Code
    vanFrame = readFrame(vanRaw);
    split = 192;
    vanFrame1 = vanFrame(:, 1:split, :);
    vanFrame2 = vanFrame(:, (split + 1):end, :);
    
    %SURF STUFF REMOVEME used to generate homography
    %getFeatures(vanFrame1,vanFrame2);
    
    %Mean Shift
    img_new = double(vanFrame1);
    if(is_start == 1)
        is_start = 0;
        
        X1 = circularNeighbors(img_new, vanPoint1(1), vanPoint1(2), r); 
        qModel = colorHistogram(X1, bins, vanPoint1(1), vanPoint1(2), h);
    else
        for i = 1:6 %<- Adjust for acc (was 5, set to 1 for H points)
        % construct candidate
        X2 = circularNeighbors(img_new, vanPoint1(1), vanPoint1(2), r);
        pTest = colorHistogram(X2, bins, vanPoint1(1), vanPoint1(2), h);
        % weights
        w = meanshiftWeights(X2, qModel, pTest, bins);
        % compute new value
        newX = sum([X2(:,1) X2(:,2)] .* [w w]) / sum(w);

        vanPoint1 = newX;
        end
    end
  
    %Calc new pos in camera 2
    vanPoint2 = calcPoint(vanPoint1', hv);
    displayImages(vanFrame1, vanFrame2, vanPoint1, vanPoint2);
    %break;
end