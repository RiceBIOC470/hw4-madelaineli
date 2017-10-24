function img_sm_bgsub = sm_bgsub(img,r)
img_sm = imfilter(img,fspecial('gaussian',4,2));
img_bg = imopen(img_sm,strel('disk',r));
img_sm_bgsub = imsubtract(img_sm,img_bg);
end
