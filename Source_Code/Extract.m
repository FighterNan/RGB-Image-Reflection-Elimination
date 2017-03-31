function [K mask_inter] = Extract(Origin_image,eliminate_image)
    J = rgb2gray(Origin_image);
    % 二值化,值越小，图黑的越多
    I = My_im2bw(J,0.362);
    I = 1-I;
    I = My_imfill_holes(I);

    % 用 11*11的全1核去腐蚀;
    imrode_kernel = ones([19 19]);
    I = My_imerode(I,imrode_kernel);
    I = My_imfill_holes(I);


    % 用 11*11的全1核去膨胀; 
    imdilate_kernel = imrode_kernel;
    I = My_imdilate(I,imrode_kernel);    %膨胀
    mask_inter = I;

    mask = I;
    for i = 1:3
        K(:,:,i)=eliminate_image(:,:,i).*uint8(mask);
    end

end
