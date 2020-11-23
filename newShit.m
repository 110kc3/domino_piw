clear all 
clc 
close all


classes_url = 'https://blogs.mathworks.com/images/steve/2011/classes.png';
classes = imread(classes_url);
imshow(label2rgb(classes, 'jet', [.5 .5 .5]))



RGB = imread('domino_10.jpg');
% figure,
% imshow(RGB),
% title('Original Image');

% GRAY = rgb2gray(RGB);
% % figure,
% % imshow(GRAY),
% % title('Gray Image');
% % 
% threshold = graythresh(GRAY);
% % threshold = 0.8;
% 
% BW = im2bw(GRAY, threshold);

BW = RGB;

cc = bwconncomp(BW);
s = regionprops(cc, 'PixelIdxList', 'Centroid');

for k = 1:cc.NumObjects
    s(k).ClassNumber = classes(s(k).PixelIdxList(1));
end

imshow(BW)
hold on
for k = 1:numel(s)
    x = s(k).Centroid(1);
    y = s(k).Centroid(2);
    text(x, y, sprintf('%d', s(k).ClassNumber), 'Color', 'r', ...
        'FontWeight', 'bold');
end
hold off
title('Class number of each object')