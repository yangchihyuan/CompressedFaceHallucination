%Chih-Yuan Yang
%F44 08/29/12 the two base_points are assumed horizontal
%U13 08/31/12 align and two points, no more restriction that the two eyes are horizontal
%F44a 07/24/2015 I rename U13 back to F44a to reduce the code confusion.
function transformmatrix = F44a_ComputeTransformMatrix(input_points, base_points, b_2row)
    %arguments
    %b_2row: This parameter affects the number of rows of the returned matrix
    
    if nargin <=2
        b_2row = true;
    end
    
    x1 = input_points(1,1);
    y1 = input_points(1,2);
    x2 = input_points(2,1);
    y2 = input_points(2,2);
    xb1 = base_points(1,1);
    yb1 = base_points(1,2);
    xb2 = base_points(2,1);
    yb2 = base_points(2,2);
    %compute the angle of input_points from base_points
    theta_input = atan((y2-y1)/(x2-x1));             %note there is a negative sign to rotate closewise
    theta_base = atan((yb2-yb1)/(xb2-xb1));
    theta_change = theta_base - theta_input;
    %compute the scaling factor
    db = sqrt((xb2-xb1)^2 + (yb2-yb1)^2);
    d = sqrt((x2-x1)^2 + (y2-y1)^2);
    lambda = db/d;
    
    %1: shift to origin
    %2: rotate
    %3: scaling
    %4: shift to base points
    m1 = [1 0 -x1;
          0 1 -y1;
          0 0 1];
    m2 = [cos(theta_change) -sin(theta_change) 0;
          sin(theta_change)  cos(theta_change) 0;
          0           0          1];            
    m3 = [lambda 0      0;
          0      lambda 0;
          0      0      1];
    m4 = [1 0 xb1;
          0 1 yb1;
          0 0 1];
    transformmatrix = m4*m3*m2*m1;
    if b_2row
        transformmatrix = transformmatrix(1:2,:);
    end
end