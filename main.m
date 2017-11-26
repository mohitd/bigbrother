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

%Ground plane homography (From calibration file)
HC0 = [-0.211332 -0.405226 70.781223;-0.019746 -1.564936 226.377280;-0.000025 -0.001961 0.160791];
HC1 = [0.089976 1.066795 -152.055667;-0.116343 0.861342 -75.122116;0.000015 0.001442 -0.064065];


%Homography rough estimate
% 4 pt hc0_1 = [-0.327379908082222,1.11478166817204,-152.641311793470;-1.08014830456342,0.995915355213101,-88.5064419544471;-0.00645393204593071,0.00609937654079285,-0.612771140135200];
% 5 pt hc0_1 = [-0.0451873010294810,-1.83264263745982,328.288033979193;-0.149065766615734,-0.721597970032843,155.109334443749;-0.00107041340945945,-0.00826762603346663,1.65142992094329];
hc0_1 = [0.199046120558281,-0.234838536453450,18.4918054751990;0.242136439315655,1.16014640375115,-156.628129967629;0.00195851011987891,0.00689985580846464,-0.969263630906114];


%Mean-shift vars
c0_p = [161 101]; %point to track 62s = 302 100
bins = 16;
h = 25;
r = 8; %25
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
        X1 = circularNeighbors(img_old, c0_p(1), c0_p(2), r);
        qModel = colorHistogram(X1, bins, c0_p(1), c0_p(2), h);
    else
        %X1 = circularNeighbors(img_old, c0_p(1), c0_p(2), r);
        %qModel = colorHistogram(X1, bins, c0_p(1), c0_p(2), h);
        for i = 1:6 %<- Adjust for acc (was 5, set to 1 for H points)
        % construct candidate
        X2 = circularNeighbors(img_new, c0_p(1), c0_p(2), r);
        pTest = colorHistogram(X2, bins, c0_p(1), c0_p(2), h);
        % weights
        w = meanshiftWeights(X2, qModel, pTest, bins);
        % compute new value
        newX = sum([X2(:,1) X2(:,2)] .* [w w]) / sum(w);
        if(isnan(newX))
            break;
        end
        c0_p = newX;
        end
    end
    
    
    img_old = img_new;
   
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
    %pause;
    %break;
end