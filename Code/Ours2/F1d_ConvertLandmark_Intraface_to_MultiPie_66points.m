%Chih-Yuan Yang
%03/20/14 F1a: Convert the landmark format from intraface to multipie
%06/04/16 F1d: same as F1a, but the multipie format is 66 points
% Landmarks of Multi-PIE: 66 points; 
% 1-17: cheeks and jaw, 
% 18-22: left eyebrow, 
% 23-27: right eyebrow, 
% 28-31: bridge of a nose, top to center
% 32-36: wing of a nose, left to right
% 37-42: left eye,
% 43-48: right eye, 
% 49-66 (18 pts): mouth, 49-55 (7 pts): upper bound of a upper lip, 56-60 (5 pts): lower bound of a lower lip, 
%                        61-63 (3 pts): lower bound of a upper lip, 64-66 (3 pts): upper bound of a lower lip
% Landmarks of IntraFace: 49 points;
% 1-5: left eyebrow, from left to right
% 6-10: right eyebrow, from left to right
% 11-14: bridge of a nose, top to center
% 15-19: wing of a nose, left to right
% 20-24: left eye, starts from 9 o’clock, clockwise
% 26-31: right eye, starts from 9 o’clock, clockwise
% 32-49 (18 pts): mouth, 32-38 (7pts): upper bound of a upper lip, 39-43 (5 pts): lower bound of a lower lip, 
%                        44-46 (3 pts): lower bound of a upper lip, 47-49 (3 pts): upper bound of a lower lip

function landmark_multipie = F1d_ConvertLandmark_Intraface_to_MultiPie_66points(landmark_intraface)
    landmark_multipie = zeros(66,2);
    landmark_multipie(18:66, :) = landmark_intraface;

end