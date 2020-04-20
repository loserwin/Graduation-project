clc; clear;

ini;

image_names=[];
labels=[];
testset=[];
trainset=[];

imgDataDir  = dir(pre_data_path); % ���������ļ�
num_imgs=0;
train_num=0;
for i = 1:length(imgDataDir)
    if(isequal(imgDataDir(i).name,'.')||... % ȥ��ϵͳ�Դ����������ļ���
       isequal(imgDataDir(i).name,'..')||...
       ~imgDataDir(i).isdir)                % ȥ�������в����ļ��е�
           continue;
    end
    imgDir = dir([pre_data_path imgDataDir(i).name '/*.jpg']); 
    for j =1:length(imgDir)                 % ��������ͼƬ
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


