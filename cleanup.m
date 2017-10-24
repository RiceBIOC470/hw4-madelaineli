function cleaned = cleanup(img)
cleaned = imerode(img, strel('disk',10));
cleaned = imdilate(cleaned, strel('disk',10));
end