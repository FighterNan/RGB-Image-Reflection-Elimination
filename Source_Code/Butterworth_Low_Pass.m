function Output_image = Butterworth_Low_Pass(Input_image,cut_off,height,width,n)
    % 巴特沃思低通滤波器 
    temp_mask = zeros(height,width);
    for i = 1:height
        for j=1:width
            % 根据距离中心的距离来
            temp_mask(i,j) = (((i-height/2).^2+(j-width/2).^2)).^(.5);
            mask(i,j) = 1/(1+((cut_off/temp_mask(i,j))^(2*n)));
        end
    end
    % 设置参数高频和低频值
    alphaL = 0.0999;
    alphaH = 1.01;

    % 使用公式
    mask = ((alphaH-alphaL).*mask)+alphaL;

    % 转化为低通滤波器
    mask = 1-mask;

    % 对图像I取对数
    Input_log = log2(1+Input_image);

    % 对对数图像作傅里叶变换
    Input_fft = My_FFT2(Input_log);   

    % 对幅值做对数变换，压缩动态范围,自动映射到灰度空间
    temp = log(1+abs(Input_fft));     

    % 对傅里叶变换后的图像进行低通巴特沃斯滤波
    % 低通滤波之后取出了变化频率小的部分
    % 即光照I(u,v)
    illumination_fft= mask.*Input_fft;

    % 对幅值做对数变换，压缩动态范围,自动映射到灰度空间
    temp = log(1+abs(illumination_fft));      


    % 傅里叶逆变换
    illumination = My_IFFT2(illumination_fft);
    % 取实部
    illumination = real(illumination);
   
    % 取指数
    Output_image = exp(illumination);
end 
