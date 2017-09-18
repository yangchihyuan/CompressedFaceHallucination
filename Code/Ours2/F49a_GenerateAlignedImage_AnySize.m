%Chih-Yuan Yang
%7/7/15
%F49: This function is separated from F18b because we want to reduce the
%computational load in our PAMI paper
%5/24/2016 F49a: Now we have a new assumption that the size of test images
%are different from exemplar images.

%outputsize: [1x2], the image size (height, width) of the output image.
function [alignedexampleimage] = F49a_GenerateAlignedImage_AnySize(exampleimage, transformmatrix, outputsize)
    %take two points on the image to generate input points
    [h, w, ~] = size(exampleimage);
    inputpoint1 = [w/2-10; h/2];   %[x; y]
    inputpoint2 = [w/2+10; h/2];   %[x; y]
    inputpoints_2points = cat(1, inputpoint1',inputpoint2');
    basepoint1 = transformmatrix * cat(1,inputpoint1,1);
    basepoint2 = transformmatrix * cat(1,inputpoint2,1);
    basepoints_2points = cat(1, basepoint1', basepoint2');
    
    tform = fitgeotrans(inputpoints_2points, basepoints_2points,'nonreflectivesimilarity');
    %generated the transform images
    %alignedexampleimage = imwarp(exampleimage,tform);
    R = imref2d(outputsize);
    alignedexampleimage = imwarp(exampleimage,tform, 'OutputView', R);
end
