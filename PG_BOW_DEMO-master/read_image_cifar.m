% read images cifar

load('D:\Program Files\MATLAB\matlab_study\PG_BOW_RES\data\cifar-10-batches-mat\data_batch_1.mat');
imData = uint8(zeros(10000, 32, 32, 3));
dataColor = uint8(zeros(32, 32, 3));
hwait=waitbar(0,'计算中...');
for i = 1:10000
    value = 100 * i / 10000;
    waitbar(i/10000, hwait, sprintf('计算中:%3.2f%%',value));
    data1 = data(i,:);
    data1 = data1';
    dataColor = reshape(data1, [32, 32, 3]);
    imData(i,:,:,:) = dataColor;
end

close(hwait);
save (['D:\Program Files\MATLAB\matlab_study\PG_BOW_RES\data\imData'],'imData');
