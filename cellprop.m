function [num,mean_area,mean_intensity] = cellprop(bg_sub,clean_mask)
% a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 
stat = regionprops(clean_mask,'Centroid');
center = cat(1,stat.Centroid);
num = size(center,1);
binary = clean_mask==1;
mean_area = sum(sum(binary))/num;
stat = regionprops(clean_mask,bg_sub,'MeanIntensity');
intensity_vec = cat(1,stat.MeanIntensity);
mean_intensity = sum(intensity_vec)/length(intensity_vec);
end
