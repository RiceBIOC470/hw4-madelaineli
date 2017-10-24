function rand_binary_mask_20(int)
centers = randi([0,1024],[20,2]);
radii = int;
xDim = 1024;
yDim = 1024;
[xx,yy] = meshgrid(1:yDim,1:xDim);
mask = false(xDim,yDim);
for i = 1:20
    xc = centers(i,1);
    yc = centers(i,2);
    for ii = 1:numel(radii)
        mask = mask | hypot(xx - xc(ii), yy - yc(ii)) <= radii(ii);
    end
end
imshow(mask)
imwrite(mask,strcat('mask_',num2str(int),'.tif'))
end