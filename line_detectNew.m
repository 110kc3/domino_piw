clear all 
clc 
close all
RGB = imread('domino_10.jpg');
figure,
imshow(RGB),
title('Original Image');

GRAY = rgb2gray(RGB);
% figure,
% imshow(GRAY),
% title('Gray Image');

threshold = graythresh(GRAY);
% threshold = 0.8;

BW = im2bw(GRAY, threshold);

% figure,
% imshow(BW),
% title('Binary Image');

% BW = ~ BW;

% figure,
% imshow(BW),
% title('Inverted Binary Image');

[B,L] = bwboundaries(BW, 'noholes');

STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'

% Step 7: Classify Shapes according to properties
% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
% UNKNOWN = 0



% imshow(STATS(12).ConvexImage)
figure,
imshow(RGB),
title('Results');
hold on

circles_1 = 0;
circles_2 = 0;
random_1 = 0;
is_line = 0;
lineSTAT=0;
%bounding box defined for each shapes as [x_cordinate,y_cordinate,x_width,y_width]
for i = 1 : length(STATS)
    
    %for rectangles, we have x_width != y_width,extent =1
    if(((STATS(i).BoundingBox(3)~=STATS(i).BoundingBox(4)) && (STATS(i).Extent>=0.9)) || (STATS(i).MajorAxisLength>4*STATS(i).MinorAxisLength))
        is_line = is_line + 1;
        lineSTAT = STATS(i);
    end
    
end


if (isstruct(lineSTAT))
    for i = 1 : length(STATS)
        centroid = STATS(i).Centroid;
       if(STATS(i).Circularity>=0.76 && STATS(i).Circularity<= 1.1 )
            if(STATS(i).BoundingBox(2)<lineSTAT.BoundingBox(2))
                circles_1= circles_1 +1;
            else
                circles_2 = circles_2 +1;
            end

            plot(centroid(1),centroid(2),'w+');
            text(centroid(1),centroid(2),num2str(i),'Color','y');

       elseif((STATS(i).BoundingBox(3)==STATS(i).BoundingBox(4)) && (STATS(i).Extent > 0.76 && STATS(i).Extent < .795))

            plot(centroid(1),centroid(2),'wO');
            text(centroid(1),centroid(2),num2str(i),'Color','y');


        elseif((STATS(i).BoundingBox(3)~=STATS(i).BoundingBox(4)) && (STATS(i).Extent > 0.76 && STATS(i).Extent < .795))

            plot(centroid(1),centroid(2),'w*');
            text(centroid(1),centroid(2),num2str(i),'Color','y');
        end

    end
end