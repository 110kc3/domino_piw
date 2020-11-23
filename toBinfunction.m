function conv = toBinfunction(conv,gray_levels)
[row,col,rgb] = size(conv);
for i = 1:row
for j = 1:col
for k = 1:rgb
if conv(i,j, k) > gray_levels*255
conv(i,j,k) = 255;
else conv(i,j,k) = 0;
end
end
end
end
end