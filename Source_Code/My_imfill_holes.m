%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   My_imdilate：自己实现的填充算法    %
%      输入：二维矩阵image             %
%      输出：填充孔洞后的矩阵，大小不变 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output] = My_imfill_holes(image)

    
    % 在四周加一圈零像素，以便处理
    mask = padarray(image, ones(1,2), -Inf, 'both');
    
    % 求反
    mask = 1-(mask); 
    marker = mask;
    
    % 获取除去最外面一圈的索引
    iner_index = cell(1,2);
    for k = 1:2
        iner_index{k} = 2:(size(marker,k) - 1);
    end
    % 定义maker在索引范围内全0
    marker(iner_index{:}) = -Inf;

    % 形态学重构
    I2 = imreconstruct(marker, mask);
    
    % 取反
    I2 = imcomplement(I2);
    I2 = I2(iner_index{:});

    if islogical(image)
        I2 = logical(I2);
    end
    output = I2;
 end