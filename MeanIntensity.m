function mean = MeanIntensity(origin,size)
bw = imread(strcat('mask_',num2str(size),'.tif'));
origin = imread(origin);
stat = regionprops(bw,origin,'MeanIntensity');
mean = cat(1,stat.MeanIntensity);
end
