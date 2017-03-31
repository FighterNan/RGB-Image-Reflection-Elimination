% 测试算法时间
tic
% 读取10个文件
for image_number=1:10
    imageName=strcat(num2str(image_number),'.jpg');
    Original_image_square = imread(imageName);
    Original_image_real = imread(imageName);
    % square为补零后的原图

    [height_1 width_1 color_n] = size(Original_image_square);

    % 补零操作，方便二维FFT
    if height_1>width_1
        Original_image_square(:,width_1+1:height_1,:)=0;
    elseif height_1<width_1
        Original_image_square(height_1+1:width_1,:)=0;
    else
        ;
    end


    figure;
    imshow(Original_image_real);
    title(['第',num2str(image_number),'个工件RGB原图']);
    impixelinfo;
    % 转为灰度图
    Gray_image = rgb2gray(Original_image_square);

    Gray_image = double(Gray_image);
    [height width] = size(Gray_image);

    % d为截止频率
    % height,width分别为输入图像的高度和宽度
    % n为巴特沃斯滤波器的阶数
    cut_off = 52;  %52
    n = 2;
    Illumination = Butterworth_Low_Pass(Gray_image,cut_off,height,width,n);

    % 把照度的动态范围等比例地转化为0-255
    max = max( max(Illumination));
    min = min( min(Illumination));
    for i = 1:height
        for j = 1:width
            Illumination(i,j) =  255*(Illumination(i,j)-min)/(max-min);
        end
    end
    Illumination = uint8(Illumination);
    Illumination_real(1:height_1,1:width_1) = Illumination(1:height_1,1:width_1); 

    % 相减，去除反光
    Eliminate_reflection = uint8 (double(Gray_image)-double(Illumination));
    Eliminate_reflection_real(1:height_1,1:width_1) = Eliminate_reflection(1:height_1,1:width_1); 

    % 根据照度生成二值化的mask
    mask = uint8(Illumination_real);
    treshhold = 0.45;
    mask = im2bw(mask,treshhold);   %二值化


    % 填充背景的蓝色
    for i = 1:height_1
        for j = 1:width_1
            m = randi(10);
            n = randi(50);
            % 在背景图上随机取样
            Eliminate_reflection_RGB(i,j,:) = Original_image_real(19+m,505+n,:);
        end
    end

    for i = 1:3
        Eliminate_reflection_RGB(:,:,i) = Eliminate_reflection_RGB(:,:,i).*uint8(mask);
    end


    [K mask_inter] = Extract(Original_image_real,Original_image_real);
    for i = 1:3
        Eliminate_reflection_RGB_1(:,:,i) = Eliminate_reflection_RGB(:,:,i).*uint8(1-mask_inter);
    end

    % 填充工件的蓝色
    for i = 1:height_1
        for j = 1:width_1
            m = randi(50);
            n = randi(30);
            % 在工件图上随机取样
            Eliminate_reflection_RGB(i,j,:) = Original_image_real(289+m,688+n,:);
        end
    end


    for i = 1:3
        Eliminate_reflection_RGB_2(:,:,i) = Eliminate_reflection_RGB(:,:,i).*uint8(mask_inter).*uint8(mask)+18;
    end

    Eliminate_reflection_RGB = Eliminate_reflection_RGB_1+Eliminate_reflection_RGB_2;
    for i = 1:3
        Output_image_1(:,:,i)= double(Original_image_real(:,:,i)).*double(1-mask);
    end
    Output_image_1 = uint8(Output_image_1);

    Output_image = Output_image_1.*0.8+Eliminate_reflection_RGB;
    figure;
    imshow(Output_image);
     title(['第',num2str(image_number),'个工件去反光的图像']);
    impixelinfo;

    K = Extract(Original_image_real,Output_image);
    figure;
    imshow(K);
    title(['第',num2str(image_number),'个工件提取的图像']);
    clc;
    clear ;
end
toc

