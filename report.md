2/2

查找外国文献并进行翻译

2/9

了解词袋模型

Bag-of-Words模型源于文本分类技术。在信息检索中，它假定对于一个文本，忽略其词序、语法和句法，将其仅仅看作是一个词集合，或者说是词的一个组合。文本中每个词的出现都是独立的，不依赖于其他词是否出现，或者说这篇文章的作者在任意一个位置选择词汇都不受前面句子的影响而独立选择的。

Bag-of-words在CV中的应用首先出现在Andrew Zisserman中为解决对视频场景的搜索，其提出了使用Bag-of-words关键点投影的方法来表示图像信息。后续更多的研究者归结此方法为Bag-of-Features，并用于图像分类、目标识别和图像检索。Bag-of-Features模型仿照文本检索领域的Bag-of-Words方法，把每幅图像描述为一个局部区域或关键点(Patches/Key Points)特征的无序集合，这些特征点可以看成一个词。这样，就能够把文本检索及分类的方法用到图像分类及检索中去。

2/16

挑选50张图作为测试集，对图像预处理



2/23

提取图像特征

了解SIFT的基本知识

SIFT即尺度不变特征变换，是用于图像处理领域的一种描述。这种描述具有尺度不变性，可在图像中检测出关键点，是一种局部特征描述子。

SIFT算法实现特征匹配主要有以下三个流程：
1、提取关键点：关键点是一些十分突出的不会因光照、尺度、旋转等因素而消失的点，比如角点、边缘点、暗区域的亮点以及亮区域的暗点。此步骤是搜索所有尺度空间上的图像位置。通过高斯微分函数来识别潜在的具有尺度和旋转不变的兴趣点。
2、定位关键点并确定特征方向：在每个候选的位置上，通过一个拟合精细的模型来确定位置和尺度。关键点的选择依据于它们的稳定程度。然后基于图像局部的梯度方向，分配给每个关键点位置一个或多个方向。所有后面的对图像数据的操作都相对于关键点的方向、尺度和位置进行变换，从而提供对于这些变换的不变性。
3、通过各关键点的特征向量，进行两两比较找出相互匹配的若干对特征点，建立景物间的对应关系。

···········

3/1

了解K-Means聚类算法

3/8

使用现有代码完成图像分类,尝试理解SVM的使用

3/15

仔细阅读了Beyond bags of features: Spatial Pyramid Matching这篇论文，简单理解了空间金字塔概念对特征匹配的优化。

3/22

更换了测试数据集，试验代码对不同图片的检测效率。

出错
错误使用 confusionmat (line 67)
G and GHAT need to be vectors or 2D character arrays.

出错 do_p_classification_inter_svm (line 56)
confusion_matrix = confusionmat(test_labels,predict_label);

出错 main (line 53)
do_p_classification_inter_svm

4/5

使用lbp特征代替sift特征
使用原数据集结果Accuracy = 42.7778% (77/180) (classification)
混淆矩阵图

![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/lbp2.jpg)

结果准确率过低，正在寻找原因。

4/12

计算汉明距离，实现图像检索。
对于数据集内图像，能够准确检索。

![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/research1.jpg)

对于数据集外图像，无法找到最接近的图像

![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/research3.jpg)

使用空间金字塔处理后的特征计算汉明距离，依旧无法对于数据集外图像得到符合认知的近似图像

![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/research2.jpg)

4/19

下载CIFAR-10 datasets，图像大小尺寸太小，显示后效果不好

INRIA Holidays 数据集与Oxford Buildings Dataset 下载速度太慢，开vpn后依旧只有4~6k/s，还有部分数据集下载链接禁止访问。

最后选择使用Caltech101数据集，这次测试与训练都使用数据集内所有图像。
因为使用数据集外随机图像进行检索，检索后结果不能很好量化比较准确度。所以使用一定图像处理后的数据集内图像进行检索，以是否能检索到原图测试检索精度。

无法在设计好的迭代次数内收敛。

旋转45度，裁剪两侧黑框，相似的5张中无原图，无同类图片
![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/r1.jpg)

水平翻转，裁剪两侧，相似的5张中无原图，有同类图片
![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/r2.jpg)

旋转90度，相似的5张中有原图，但不是第一张
![image](https://github.com/loserwin/Graduation-project/blob/master/resultpic/r3.jpg)


4/26

图像检索的评价指标有， Precision & Recall,Precision 即查准率，Recall为查全率，前者是指检出的相关目标数占检出总数的百分比，反映了检索的准确性；后者指检索的相关目标数占系统中相关目标总数的百分比，反映检索的全面性。两者通常呈负相关。mAP，即图像平均检索精度(mean average precision)。

这里我选择用mAP值作为标准，对检索算法进行分析。经计算，当前算法20次检索的mAP为0.5130，50次检索的mAP为0.3528。尝试使用其他图像检索算法处理当前数据集，比较与用词袋模型进行图像检索的差别。

