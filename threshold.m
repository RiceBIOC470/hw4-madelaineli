function [mean,mask] = threshold(img)
mean = sum(img(:))/((length(img))^2);
mask = img>mean;
end