%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      My_FFT2：自己实现的2维FFT算法   %
%      输入：二维矩阵image             %
%      输出：原点在中心的FFT           % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [image_fft2_center] = My_FFT2(image)

    % 取出行数和列数
    [height_1,width_1] = size(image); 
    
    % 基2的向上取整  或使用nextpow2(height_1)
    m = ceil(log2 (height_1));    
    n = ceil(log2 (width_1));   
    
    % 创建全为零的矩阵存最后的结果
    image_fft = zeros(2.^m,2.^n);
    [height,width] = size(image_fft);
    n_height = zeros(1, height);
    n_width = zeros(1, width);
    
    % 完成序列的逆序
    for i = 1:height
        string_1 = dec2bin(i-1,m);
        string_2 = string_1(end:-1:1);
        n_height(i) = bin2dec(string_2)+1;
    end
    
    for i = 1:width
        string_1 = dec2bin(i-1,n);
        string_2 = string_1(end:-1:1);
        n_width(i) = bin2dec(string_2)+1;
    end
    
    for i = 1:height
        for j = 1:width
            if(n_height(i)<=height&&n_width(j)<=width_1)
                image_fft(i,j) = image(n_height(i),n_width(j));
            end
        end
    end
    
    % 计算每一级所用的旋转因子W
    t=0:2^(m-1)-1;
    WM(t+1)=exp(-2*pi*1i*t/2^m);
    
    t=0:2^(n-1)-1;
    WN(t+1)=exp(-2*pi*1i*t/2^n);
    
    % 先进行列运算
    % 逐级计算
    % m为蝶形运算的最大级数
    for p=1:m   
       G=2^(p-1); 
       % q控制旋转因子的系数
       for q=0:G-1
           Q=q*2^(m-p);
           % 2^p为步长
           for k=q+1:2^p:2^m 
               % 先计算每个元素的Wk*X(k)
               % 因为下一句修改了image_fft(k+G,:)的值
               temp=WM(Q+1)*(image_fft(k+G,:));
               % 计算X[k+N/2]，先减后加
               image_fft(k+G,:)=image_fft(k,:)-temp;
               % 计算X[k]
               image_fft(k,:)=image_fft(k,:)+temp;
           end
       end
    end
    
    % 再进行行运算
    % 逐级计算
    % n为蝶形运算的最大级数
    for p=1:n  
        G=2^(p-1); 
        % q控制旋转因子的系数
        for q=0:G-1
            Q=q*2^(n-p);
            % 2^p为步长
            for k=q+1:2^p:2^n 
                % 先计算每个元素的Wk*X(k)
                % 因为下一句修改了image_fft(k+G,:)的值
                temp=WN(Q+1)*image_fft(:,k+G);
                % 计算X[k+N/2]，先减后加
                image_fft(:,k+G)=image_fft(:,k)-temp;
                % 计算X[k]
                image_fft(:,k)=image_fft(:,k)+temp;
            end
       end
    end
    
    % 将中心位置从矩阵零点转移到矩阵中心
    %  1 | 2           3 | 4
    %  ———    =>    ———
    %  4 | 3           2 | 1
    % 这样就将低频分量放在了矩阵中心，方便进行滤波处理
    temp=image_fft(1:2^(m-1),1:2^(n-1));
    image_fft(1:2^(m-1),1:2^(n-1))=image_fft(2^(m-1)+1:2^m,2^(n-1)+1:2^n);
    image_fft(2^(m-1)+1:2^m,2^(n-1)+1:2^n)=temp;
    temp=image_fft(1:2^(m-1),2^(n-1)+1:2^n);
    image_fft(1:2^(m-1),2^(n-1)+1:2^n)=image_fft(2^(m-1)+1:2^m,1:2^(n-1));
    image_fft(2^(m-1)+1:2^m,1:2^(n-1))=temp;
    
    % 输出原点在中心的FFT
    image_fft2_center = image_fft;
end