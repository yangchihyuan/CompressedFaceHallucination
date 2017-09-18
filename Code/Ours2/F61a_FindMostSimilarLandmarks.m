%Chih-Yuan Yang
%06/02/2016, F61 In order to load landmarks and exemplar images on the go,
%I separate F6m into two functions. This is the first function to find the
%most similar K landmarks
%06/23/2016 F61a I change the input arguments

%Input
%basepoints: [m x 2], the landmarks of a test image.
%inputpoints: [m x 2 x n], the landmarks of numerous exemplar images.
%index_two_points_for_alignment: [2], the two points to be alinged.
%K:[1], the number of K most similar landmarks
%glasslist: [n], a list whether the subject wearing a pair of glasses
%bglassavoid: boolean, whether the K returned set containing subjects
%wearing glasses.
%Output:
%list_K_most_similar: [K], the set of K most similar landmarks, sorted by
%similarity.
%transformmatrix: [2 x 3 x K], the transformmatrix used for alignment.
function [list_K_most_similar, transformmatrix] = F61a_FindMostSimilarLandmarks(basepoints, example, set, index_two_points_for_alignment, K, bglassavoid)
    exampleimagenumber = length(example);
    
    %compute the sum of differences of aligned landmarks.
    array_difference = zeros(exampleimagenumber,1);
    stored_transformmatrix = zeros(2,3, exampleimagenumber);
    %landmarks_aligned = zeros(size(inputpoints)); no longer used
    for i=1:exampleimagenumber
        if bglassavoid && example(i).bglass == 1
            array_difference(i) = inf;
        else
            %[transformmatrlist_sorted_in_candidates, difference, landmarks_aligned_one] = F48a_ComputeAlignedLandmarks(inputpoints(:,:,i),basepoints, index_two_points_for_alignment);
            [transformmatrlist_sorted_in_candidates, difference, ~] = F48a_ComputeAlignedLandmarks(example(i).landmark(set,:),basepoints, index_two_points_for_alignment);
            array_difference(i) = difference;
            stored_transformmatrix(:,:,i) = transformmatrlist_sorted_in_candidates;
            %landmarks_aligned(:,:,i) = landmarks_aligned_one;
        end
    end
    %return the K most similar landmark sets.
    [~, list_sorted_by_landmarks] = sort(array_difference);
    list_K_most_similar = list_sorted_by_landmarks(1:K);
    transformmatrix = stored_transformmatrix(:,:,list_K_most_similar);
end
