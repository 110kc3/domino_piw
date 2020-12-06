clear all 
clc 
close all
%RGB = imread('domino_4.jpg');
[fn,pn]=uigetfile({'*.png'}, 'Wybierz obraz');
RGB = imread([pn,fn]);
figure,
imshow(RGB),
title('Original Image');

GRAY = rgb2gray(RGB);

threshold = graythresh(GRAY);


BW = im2bw(GRAY, threshold);


[B,L] = bwboundaries(BW, 'noholes');

STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'

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
        imshow(STATS(i).ConvexImage)
        centroid = STATS(i).Centroid;
        plot(centroid(1),centroid(2),'w+');
        text(centroid(1),centroid(2),num2str(i),'Color','y');
    end 
end

vertical=0;
a = tand(lineSTAT.Orientation);
if (lineSTAT.Orientation>=88)
    vertical=1
end
a=a*(-1);
b = lineSTAT.Centroid(2) - (a*lineSTAT.Centroid(1));

x=0:1:length(BW)-1;

y=a*x+b;
plot(x,y)

if (isstruct(lineSTAT))
    for i = 1 : length(STATS)
        centroid = STATS(i).Centroid;
       if(STATS(i).Circularity>=0.76 && STATS(i).Circularity<= 1.1 )
            if(vertical)
                if(STATS(i).Centroid(1)<(lineSTAT.Centroid(1)))
                    circles_1= circles_1 +1;
                else
                    circles_2 = circles_2 +1;
                end
            else
                if(STATS(i).Centroid(2)<(a*STATS(i).Centroid(1)+b))
                    circles_1= circles_1 +1;
                else
                    circles_2 = circles_2 +1;
                end
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


title("Czêœæ górna: " + circles_1 + " czêœæ dolna: " +  circles_2);