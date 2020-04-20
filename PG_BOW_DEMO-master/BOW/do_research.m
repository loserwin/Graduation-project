function []=do_research(opts,research_opts)

maxImageSize = research_opts.maxImageSize;
gridSpacing = research_opts.gridSpacing;
patchSize = research_opts.patchSize;
% dictionarySize = research_opts.dictionarySize;
% pyramidLevels = research_opts.pyramidLevels;


vocabulary=getfield(load([opts.globaldatapath,'\',research_opts.dictionary_type]),'dictionary');
vocabulary_size=size(vocabulary,1);
load(opts.image_names);
nimages=opts.nimages;
load([opts.globaldatapath,'\BOW_sift']);
load([opts.globaldatapath,'\spatial_pyramid']);

I=load_image([opts.imgpath,'\testing\', research_opts.name]);
[hgt wid] = size(I);
if min(hgt,wid) > maxImageSize
    I = imresize(I, maxImageSize/min(hgt,wid), 'bicubic');
    fprintf('Loaded test_pic %s: original size %d x %d, resizing to %d x %d\n', ...
        research_opts.name, wid, hgt, size(I,2), size(I,1));
    [hgt wid] = size(I);
end
        
%% make grid (coordinates of upper left patch corners)
remX = mod(wid-patchSize,gridSpacing);% the right edge
offsetX = floor(remX/2)+1;
remY = mod(hgt-patchSize,gridSpacing);
offsetY = floor(remY/2)+1;
[gridX,gridY] = meshgrid(offsetX:gridSpacing:wid-patchSize+1, offsetY:gridSpacing:hgt-patchSize+1);
fprintf('Processing %s: wid %d, hgt %d, grid size: %d x %d, %d patches\n', ...
    research_opts.name, wid, hgt, size(gridX,2), size(gridX,1), numel(gridX));
        
%% find SIFT descriptors
siftArr = find_sift_grid(I, gridX, gridY, patchSize, 0.8);
siftArr = normalize_sift(siftArr);
        
features.data = siftArr;
features.x = gridX(:) + patchSize/2 - 0.5;
features.y = gridY(:) + patchSize/2 - 0.5;
features.wid = wid;
features.hgt = hgt;
features.patchSize=patchSize;

points = features.data;
texton_ind.x = features.x;
texton_ind.y = features.y;
texton_ind.wid = features.wid;
texton_ind.hgt = features.hgt;
        
        
 
D=[];
d2 = EuclideanDistance(points, vocabulary);
[minz, index] = min(d2', [], 1);
                
test_BOW(:,1)=hist(index,(1:vocabulary_size));
texton_ind.data = index;

%% parameters
% binsHigh = 2^(pyramidLevels-1);
% test_pyramid_all = [];

%% get width and height of input image
% wid = texton_ind.wid;
% hgt = texton_ind.hgt;

%% compute histogram at the finest level
% pyramid_cell = cell(pyramidLevels,1);
% pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);
% for i=1:binsHigh
%     for j=1:binsHigh
%         % find the coordinates of the current bin
%          
%         x_lo = floor(wid/binsHigh * (i-1));
%         x_hi = floor(wid/binsHigh * i);
%         y_lo = floor(hgt/binsHigh * (j-1));
%         y_hi = floor(hgt/binsHigh * j);
%                 
%         texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...                  
%             (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
%                 
%                 
%         % make histogram of features in bin
%         pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);            
%     end   
% end

%% compute histograms at the coarser levels
        
% num_bins = binsHigh/2;
%         
% for l = 2:pyramidLevels
%             
%     pyramid_cell{l} = zeros(num_bins, num_bins, dictionarySize);
%             
%     for i=1:num_bins               
%         for j=1:num_bins                  
%             pyramid_cell{l}(i,j,:) = ...
%                         pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
%                         pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
%                
%         end        
%     end
%             num_bins = num_bins/2;     
% end

%% stack all the histograms with appropriate weights
        
% pyramid = [];       
% for l = 1:pyramidLevels-1
%             
%     pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
%         
% end
% pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];       
% test_pyramid_all = [test_pyramid_all; pyramid];             
% fprintf('Pyramid: the test images.\n');




%比较bow后的图像特征距离
for i=1:nimages
    preBOW=BOW(:,i);
    d = pdist2(test_BOW,preBOW,'hamming');
    D(i)=sum(diag(d));
end
%比较pyramid后的图像特征距离
% for i=1:nimages
%     d = pdist2(test_pyramid_all',pyramid_all(:,i),'hamming');
%     D(i)=sum(diag(d));
% end
[x,y] = sort(D);


s=imread([opts.imgpath,'\testing\', research_opts.name]); 

subplot(2,3,1);
imshow(s);
title('原图');


s=imread([opts.imgpath, image_names{y(1)}]);
subplot(2,3,2);
imshow(s);
title('最相似检索');

s=imread([opts.imgpath,'\', image_names{y(2)}]);
subplot(2,3,3);
imshow(s);
title('第二相似图像');

s=imread([opts.imgpath,'\', image_names{y(3)}]);
subplot(2,3,4);
imshow(s);
title('第三相似图像');

s=imread([opts.imgpath,'\', image_names{y(4)}]);
subplot(2,3,5);
imshow(s);
title('第四相似图像');

s=imread([opts.imgpath,'\', image_names{y(5)}]);
subplot(2,3,6);
imshow(s);
title('第五相似图像');


end
