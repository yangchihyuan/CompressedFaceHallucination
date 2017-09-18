%Chih-Yuan Yang
%2016/6/14 F63 I need a function to compute the brightness mean and std of
%a masked facial components
function [mean_value, std_value] = F63_ComputeMaskedMeanStd(img, mask)
    masked_img = img .* mask;
    mean_value = sum(masked_img(:)) / sum(mask(:));
    diff = masked_img - mean_value;
    weighted_square = diff.^2 .* mask;
    std_value = sqrt(sum(weighted_square(:)));
end