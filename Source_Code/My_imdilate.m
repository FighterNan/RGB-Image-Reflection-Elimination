%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   My_imdilate：自己实现的膨胀算法    %
%      输入：二维矩阵image             %
%            膨胀核 kernel            %
%      输出：膨胀后的矩阵，大小不变    % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [output] = My_imdilate(image,kernel)
    % 先求核的高和宽    
    [k_height,k_width] = size(kernel);
    
    % 取整
    x_center = floor(k_height/2);
    y_center = floor(k_width/2);
    % 扩大图的高和宽
    image = padarray(image,[x_center y_center]);
 
    [new_height,new_widt] = size(image);

    % 进行膨胀，遍历范围缩小一个center防止出界
    % 同时保证输出output和原矩阵image一样大小
    for i = x_center+1:new_height-x_center
        for j = y_center+1:new_widt-y_center
            % 取出与核一样大小的矩阵
            samesize_bloc = image(i-x_center:i+x_center,j-y_center:j+y_center);
            % 求这个矩阵的与核的逻辑与
            andresult = kernel&samesize_bloc;
            % 求和
            sum_result=sum( sum(andresult) );
            % 若和大于sum_result，说明原矩阵的(i,j)与核至少有一个交点
            % 膨胀(i,j)
            if sum_result>0
                output(i-x_center,j-y_center) = 1;
            % 否则，此点不纳入膨胀范围
            else
                output(i-x_center,j-y_center) = 0;
            end
        end
    end
end