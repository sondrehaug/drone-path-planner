%***************************************************
% Purpose: Checks if all values for velocity, 
% acceleration and Jerk are within the constraints
%***************************************************
% Variables: 
% name         I/O   Description
% --------------------------------------------------
% pathMatrix    O    Points, velocities and accl
% JsMatrix      O    Constains all jerk-values
% v_s           O    Absolute value of velocities
% a_s           O    Absolute value of acceleration
% j_s           O    Absolute value of jerk
% 
% Bool:
% name                   I/O   Description
% --------------------------------------------------
% isWithinConstraints     O    if saturated or not
%
%***************************************************

function isWithinConstraints = checkWithinConstraints()

% Initialize return value
isWithinConstraints = true;

% Read from generated path file
fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";

% Write all values to matrix
pathMatrix = fscanf(fileID,formatSpec, [11 inf])';

% Close file
fclose(fileID);

% Read from generated file with Jerk-values
fileID_Js = fopen('Js.txt','r');
formatSpec_Js = "%f %f %f";

% Write all values to matrix
JsMatrix = fscanf(fileID_Js,formatSpec_Js, [3 inf])';

% Close file
fclose(fileID_Js);

% Determine number
[Nrows,~] = size(pathMatrix);
[Nrows_Js,~] = size(JsMatrix);


% Constraints
% Vs = [Vh_max, Vv_min, Vv_max]
% Vs = [3.1, -0.55, 2.2]
% as = [2.8, -0.5, 2.0]
% Js = [7.1, -5, 5]


% Velocity and Acceleration constraints
for i=1:Nrows

    v_s = sqrt(pathMatrix(i, 4)^2 + pathMatrix(i, 5)^2);
    if v_s > 2.5
       isWithinConstraints = false;
       fprintf('v_s');
       return 
    end
    
    if pathMatrix(i, 6) > 2.2 || pathMatrix(i, 6) < -0.55
       isWithinConstraints = false;
       fprintf('v_z')
       return 
    end
    
    a_s = sqrt(pathMatrix(i, 7)^2 + pathMatrix(i, 8)^2);
    if a_s > 2.0
       isWithinConstraints = false;
       fprintf('a_s');
       return 
    end
    
    if pathMatrix(i, 9) > 1.5 || pathMatrix(i, 9) < -0.30
       isWithinConstraints = false;
       fprintf('a_z');
       return 
    end
    
    
end %for

% Jerk constraints
for i = 1:Nrows_Js
    
j_h = sqrt(JsMatrix(i, 1)^2 + JsMatrix(i, 2)^2);
    if j_h > 7.1
       isWithinConstraints = false;
       fprintf('j_s');
       return 
    end
    
    if JsMatrix(i, 3) > 5 || JsMatrix(i, 3) < -5
       isWithinConstraints = false;
       fprintf('J_z')
       return 
    end
end %for

end