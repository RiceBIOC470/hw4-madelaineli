%HW4
%% 
% Problem 1. 
% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 

int_mat = rand(1024);
ini_mat2=im2uint8(int_mat);
imwrite(ini_mat2, 'rand8bit.tif')
figure(1)
imshow(ini_mat2,'InitialMagnification','fit')
title('random intensity 8-bit image, size 1024x1024');

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations

% written in rand_binary_mask_20.m

% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).

% written in MeanIntensity.m
mean = MeanIntensity('rand8bit.tif',20)

% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 
for i = 2:2:22
    vec = MeanIntensity('rand8bit.tif',i);
    avr(i/2) = sum(vec)/20;
    total = sum(vec);
    avr(i/2) = total/20;
    SD(i/2) = sqrt(sum((vec-avr(i/2)).^2)/19);
end

xval = 2:2:22;
figure(2)
plot(xval,avr.',xval,SD.');
xlabel ('size of circle');
title ('Mean and Standard Deviation of Mean Intensity vs. Circle Size');
legend ('Mean','Standard Deviation');

% The mean appears to be quite stable, and standard deviation appears to
% drop as size of circle increases. This makes sense because as the size
% increases, the mean is still the same since we are just increasing the
% sample size. The randomly generated intensity from image1 should have the
% same average no matter how large the circle is. The standard deviation,
% however, should fall as the sample size increases (i.e. circle size
% increases), since the larger the sample size, the smaller the error. 


%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 

%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space).

% open -> select file -> image -> color -> channel tool -> select composite
% stacks -> z project -> choose max intensity
% -> save file, repeat for the second channel
% plugins -> bio-formats -> bio-formats importer -> select file -> select
% "group files with similar names" and "concatenate when series compatible"
% -> click ok -> save as .avi
% saved as MAX_nfkb_movie1.avi,MAX_nfkb_movie2.avi, Concatenated Stacks.avi

%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

%first cell

cell_1 = ('nfkb_movie1.tif');
reader = bfGetReader(cell_1);
time = reader.getSizeT;
chan = reader.getSizeC;
slice = reader.getSizeZ;

t = 1;
for c = 1:chan
        ind = reader.getIndex(0,c-1,t-1)+1;
        max_proj = bfGetPlane(reader,ind);
        for s = 2:slice
            ind = reader.getIndex(s-1,c-1,t-1)+1;
            plane = bfGetPlane(reader,ind);
            max_proj = max(max_proj,plane);
        end
        mat{c} = max_proj;
end
composite = cat(3,imadjust(mat{1}),imadjust(mat{2}),zeros(1024));
imwrite(uint16(composite),'composite.tif','Compression','None')

for t = 2:time
    for c = 1:chan
        ind = reader.getIndex(0,c-1,t-1)+1;
        max_proj = bfGetPlane(reader,ind);
        for s = 2:slice
            ind = reader.getIndex(s-1,c-1,t-1)+1;
            plane = bfGetPlane(reader,ind);
            max_proj = max(max_proj,plane);
        end
        mat{c} = max_proj;
    end
    composite = cat(3,imadjust(mat{1}),imadjust(mat{2}),zeros(1024));
    imwrite(uint16(composite),'composite.tif','Compression','None','WriteMode','append')
end

cell_2 = ('nfkb_movie2.tif');
reader_2 = bfGetReader(cell_2);
time_2 = reader_2.getSizeT;
for t = 1:time_2
    for c = 1:chan
        ind = reader_2.getIndex(0,c-1,t-1)+1;
        max_proj = bfGetPlane(reader_2, ind);
        for s = 2:slice
            ind = reader_2.getIndex(s-1,c-1,t-1)+1;
            plane = bfGetPlane(reader_2,ind);
            max_proj = max(max_proj,plane);
        end
        mat{c} = max_proj;
    end
    composite = cat(3,imadjust(mat{1}),mat{2},zeros(1024));
    imwrite(uint16(composite),'composite.tif','Compression','None','WriteMode','append')
end

%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 

mov = ('composite.tif');
reader_mov = bfGetReader(mov);
ind_proj = reader_mov.getIndex(0,0,0)+1;
proj = bfGetPlane(reader_mov, ind_proj);
imwrite(proj,'max_intensity_proj.tif')
figure(3)
imshow(proj)
title('maximum intensity projection image of channel 1, time 1, cell 1');

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

% written in sm_bgsub.m
img = imread('max_intensity_proj.tif');
img_bgsub = sm_bgsub(img,100);
imwrite(img_bgsub,'bg_sub_max.tif');
figure(4)
imshow(img_bgsub);
title(strcat('smoothed and background subtracted image, smoothing radius = ',num2str(100)));

% 3. Write a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

% written in threshold.m
[thres,mask] = threshold(img_bgsub);
imwrite(mask,'mask_max.tif');
figure(5)
imshow(mask);
title(strcat('binary mask with threshold = ',num2str(thres)));

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 

% written in cleanup.m
cleaned = cleanup(mask);
imwrite(cleaned,'cleaned_up_max.tif');
figure(6)
imshow(cleaned);
title('cleaned up binary mask');

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 

% written in cellprop.m
[num_cell,mean_area,mean_intensity] = cellprop(img_bgsub,cleaned);

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel. 
ind_proj_2 = reader_mov.getIndex(0,1,0)+1;
proj_2 = bfGetPlane(reader_mov, ind_proj_2);
img_bgsub_2 = sm_bgsub(proj_2,100);
[thres_2,mask_2] = threshold(img_bgsub_2);
cleaned_2 = cleanup(mask_2);
[num_cell_2,mean_area_2,mean_intensity_2] = cellprop(img_bgsub_2,cleaned_2);
disp('mean intensity of channel 2, time 1'); disp(mean_intensity_2)

%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.

% channel 1
ind = reader_mov.getIndex(0,0,0)+1;
proj = bfGetPlane(reader_mov, ind);
img_bgsub = sm_bgsub(proj,100);
[~,mask] = threshold(img_bgsub);
cleaned = cleanup(mask);
imwrite(cleaned,'mask_mov_chan1.tif','Compression','None')
[num_cell,~,mean_intensity] = cellprop(img_bgsub,cleaned);
num_vec1 = [];
mean_vec1 = [];
num_vec1(1,1) = num_cell;
mean_vec1(1,1) = mean_intensity;
for t = 2:37
    ind = reader_mov.getIndex(0,0,t-1)+1;
    proj = bfGetPlane(reader_mov, ind);
    img_bgsub = sm_bgsub(proj,100);
    [~,mask] = threshold(img_bgsub);
    cleaned = cleanup(mask);
    imwrite(cleaned,'mask_mov_chan1.tif','Compression','None','WriteMode','append');
    [num_cell,~,mean_intensity] = cellprop(img_bgsub,cleaned);
    num_vec1(1,t) = num_cell;
    mean_vec1(1,t) = mean_intensity;
end

%channel 2
ind = reader_mov.getIndex(0,1,0)+1;
proj = bfGetPlane(reader_mov, ind);
img_bgsub = sm_bgsub(proj,100);
[~,mask] = threshold(img_bgsub);
cleaned = cleanup(mask);
imwrite(cleaned,'mask_mov_chan2.tif','Compression','None');
[num_cell,~,mean_intensity] = cellprop(img_bgsub,cleaned);
num_vec2 = [];
mean_vec2 = [];
num_vec2(1,1) = num_cell;
mean_vec2(1,1) = mean_intensity;
for t = 2:37
    ind = reader_mov.getIndex(0,1,t-1)+1;
    proj = bfGetPlane(reader_mov, ind);
    img_bgsub = sm_bgsub(proj,100);
    [thres,mask] = threshold(img_bgsub);
    cleaned = cleanup(mask);
    imwrite(cleaned,'mask_mov_chan2.tif','Compression','None','WriteMode','append');
    [num_cell,~,mean_intensity] = cellprop(img_bgsub,cleaned);
    num_vec2(1,t) = num_cell;
    mean_vec2(1,t) = mean_intensity;
end



% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 

% functions already called in last step, mean intensity and number of cells
% already in num_vec1&2 and mean_vec1&2.
xval = 1:37;
figure(7)
plot(xval,mean_vec1,xval,mean_vec2);
xlabel('time')
ylabel('mean intensity')
title('mean intensity vs. time in channels 1 and 2')

