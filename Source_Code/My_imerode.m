%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   My_imdilate：自己实现的腐蚀算法    %
%      输入：二维矩阵image             %
%            腐蚀核 kernel            %
%      输出：腐蚀后的矩阵，大小不变    % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [output] = My_imerode(image,kernel)
    % 先求核的高和宽
    [k_height,k_width] = size(kernel);
    % 求1的个数
    sum_kernel = sum( sum(kernel) );

    % 取整
    x_center = floor(k_height/2);
    y_center = floor(k_width/2);

    % 把原图扩大，以便进行腐蚀处理
    image = padarray(image,[x_center y_center]);
    % 扩大图的高和宽
    [new_height,new_width] = size(image);

    % 进行腐蚀，遍历范围缩小一个center防止出界
    % 同时保证输出output和原矩阵image一样大小
    for i = x_center+1:new_height-x_center
        for j = y_center+1:new_width-y_center
            % 取出与核一样大小的矩阵
            samesize_block = image(i-x_center:i+x_center,j-y_center:j+y_center); 
            % 求这个矩阵的与核的逻辑与
            logicand_result = kernel&samesize_block;
            % 求和
            sum_result = sum( sum(logicand_result) );
            % 若和小于sum_result，说明原矩阵的(i,j)处不包含核
            % 腐蚀掉(i,j)
            if sum_result < sum_kernel
                output(i-x_center,j-y_center)=0;
            % 否则，说明原矩阵的(i,j)处包含核
            % 保留(i,j)
            else
                output(i-x_center,j-y_center)=1;
            end
        end
    end
end