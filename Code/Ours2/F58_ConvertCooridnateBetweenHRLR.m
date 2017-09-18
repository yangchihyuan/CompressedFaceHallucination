%Chih-Yuan Yang
%05/28/2016 F58: I create this function to conveniently convert coordinates
%between LR and HR

%input_coodinate: [m x 2]
function [ output_coordinate ] = F58_ConvertCooridnateBetweenHRLR( input_coordinate , scalingfactor, string_of_source)
    if strcmp( string_of_source , 'HR')
        %x_lr = (x_hr-0.5)/scalingfactor+0.5
        output_coordinate = (input_coordinate - 0.5)/scalingfactor+0.5;
    elseif strcmp( string_of_source , 'LR')
        %x_hr = (x_lr-0.5)*scalingfactor+0.5
        output_coordinate = (input_coordinate - 0.5) * scalingfactor + 0.5;
    else
        error('The argument string_HRorLR does not work.' );
    end

end

