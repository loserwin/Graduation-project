clc; clear;

ini;

image_names=[];
labels=[];
testset=[];
trainset=[];

imgDataDir  = dir(pre_data_path); % 遍历所有文件
num_imgs=0;
train_num=0;
for i = 1:length(imgDataDir)
    if(isequal(imgDataDir(i).name,'.')||... % 去除系统自带的两个隐文件夹
       isequal(imgDataDir(i).name,'..')||...
       ~imgDataDir(i).isdir)                % 去除遍历中不是文件夹的
           continue;
    end
    imgDir = dir([pre_data_path imgDataDir(i).name '/*.jpg']); 
    for j =1:length(imgDir)                 % 遍历所有图片
        num_imgs = num_imgs + 1;
        labels(num_imgs, 1) = i;
        image_names{num_imgs} = [ '\training\',imgDataDir(i).name '\' imgDir(j).name];
        if j<5
            train_num=train_num+1;
            trainset(train_num, 1) = num_imgs;
        end
        
        
    end
end

    

save('labels','labels');
save('image_names','image_names');
save('trainset','trainset');


