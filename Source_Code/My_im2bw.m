%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   My_imdilate：自己实现的二值化算法  %
%      输入：二维矩阵image            %
%            二值化阈值threshhold     %
%      输出：二值化的矩阵，大小不变    % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output] = My_im2bw(image,threshhold)
    % 转化成double才能进行运算
    image_double = double(image);
    
    output = zeros(size(image));
    [height width] = size(image);
    
    % 求最大像素值
    maxmum_pixel = max( max(image_double) );
    for i = 1:height
        for j = 1:width
            % 遍历，若大于 阈值*最大像素值，则设为1
            if(image(i,j) > threshhold*maxmum_pixel)
                output(i,j) = 1;   
            % 否则设为0
            else
                output(i,j) = 0;
            end
        end
    end

end