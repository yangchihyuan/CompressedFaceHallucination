%Chih-Yuan Yang
%F48 7/7/15 This function is separated from F18b because we want to reduce the
%computational load in our PAMI paper.
%F48a 7/20/2015 This function uses only 2 points to align landmarks.
function [transformmatrix, difference, landmarks_aligned] = F48a_ComputeAlignedLandmarks(landmarks_example,landmarks_test, index_alignpoint)
    %outputs:
    %difference is defined as the sum of squared distances of all landmark pairs.
    %arguments:
    %index_alignpoint is a [2 x 1] array indicating the two points of the landmarks_example
    %and the landmarks_test to be aligned.
    
    twopoints_test = landmarks_test(index_alignpoint,:);
    twopoints_example = landmarks_example(index_alignpoint,:);
    transformmatrix_plus1 = F44a_ComputeTransformMatrix(twopoints_example, twopoints_test);
    transformmatrix = transformmatrix_plus1(1:2,:);
    
    %compute landmarks_aligned
    landmarks_example_rowvector = landmarks_example;
    landmarks_example_colvector = landmarks_example_rowvector';
    num_landmarks = size(landmarks_example_colvector,2);
    landmarks_example_plus1 = cat(1,landmarks_example_colvector,ones(1,num_landmarks));
    landmarks_aligned = transpose(transformmatrix * landmarks_example_plus1);
    
    %compute difference
    difference = sum((landmarks_aligned(:) - landmarks_test(:)).^2);
end
