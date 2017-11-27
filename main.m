%
% Big Brother
% Mohit Deshpande & Brad Pershon
% CSE 5524
% vid link: http://crcv.ucf.edu/projects/multipleCameras/multiple-cameras.php
% Sequence 3

vanRaw = VideoReader('van.mpg');

split = 192;
frameCounter = 1;

%vanRaw.CurrentTime = 8;

%homography estimate for van
hv = [-0.0217520729234989,0.856129441419913,-102.488860336591;-0.0629133385268018,-0.547872008185205,37.6794937800455;0.000973516955072778,-0.00300901746189340,-0.0769403576320744];

%Mean-shift vars
bins = 16;
h = 25;
r = 7; %25
is_start = 1;
buffer = 5;
K = [0.5 1]';

%van point
vanRoi = [34 81; 52 81; 52 93; 34 93];
roiSize = max(vanRoi, [], 1) - min(vanRoi,[],1);
extents = floor(roiSize / 2);

% track center point of ROI
vanPoint1 = min(vanRoi,[],1) + extents;

while hasFrame(vanRaw)
    %Van Code
    vanFrame = readFrame(vanRaw);    
    vanFrame1 = vanFrame(:, 1:split, :);
    vanFrame2 = vanFrame(:, (split + 1):end, :);
    
    %SURF STUFF REMOVEME used to generate homography
    %getFeatures(vanFrame1,vanFrame2);
    
    img_new = double(vanFrame1);
    if is_start == 1
        % initialize model and covariance matrix
        is_start = 0;
        
        minPt = vanPoint1 - extents;
        maxPt = vanPoint1 + extents;
        
        roi = img_new(minPt(2):maxPt(2), minPt(1):maxPt(1), :);
        covMatrix = computeCovMatrix(roi);
        
        X1 = circularNeighbors(img_new, vanPoint1(1), vanPoint1(2), r); 
        qModel = colorHistogram(X1, bins, vanPoint1(1), vanPoint1(2), h);
    else
        vanPoint1 = meanShift(img_new, qModel, vanPoint1, r, h, bins);
    end
    
    % reorganize points
    searchRegion = calcPoint([vanPoint1 - extents; vanPoint1 + extents], hv);
    
    minPt = min(searchRegion, [], 1) - buffer;
    maxPt = max(searchRegion, [], 1) + buffer;
    
    searchRegion(1,:) = floor(minPt);
    searchRegion(2,:) = floor(maxPt);
    
    searchRoi = vanFrame2(searchRegion(1,2):searchRegion(1,1),... 
        searchRegion(2,2):searchRegion(2,1), :);
    searchRoi = double(searchRoi);
    
    match = covTracking(searchRoi, covMatrix, roiSize, K);
    match(1) = match(1) + minPt(1);
    match(2) = match(2) + minPt(2);
    
    match = floor(match);
  
    %Calc new pos in camera 2
    vanPoint2 = calcPoint(vanPoint1, hv);
    displayImages(vanFrame1, vanFrame2, vanPoint1, extents, vanPoint2, match, searchRegion);
    
    if frameCounter == 2
        break;
    end
    
    frameCounter = frameCounter + 1;
end