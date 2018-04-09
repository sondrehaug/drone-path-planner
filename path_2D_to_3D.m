%***************************************************
% Purpose: Adding z-coordinates to the pathfile
% from (x,y) to (x,y,z)
%***************************************************
% Variables: 
% name         I/O   Description
% --------------------------------------------------
% mode          I    Flying mode of the path
% path_z        O    Z dimension to be added
% path          I    2D file with coordinates (x,y)
% path3D        O    3D file with coordinates (x,y,z)
%
% Constants:
% name         I/O   Description
% --------------------------------------------------
% delta         I    floor located at (x,y,z +delta)
%
%***************************************************

function path3D = path_2D_to_3D(path, mode)
delta = 0.185;

% middair, mode == 1
if mode == 1
    % Maintain vertical position z = 1;
    
    path_z = ones(1,size(path,1))';
    path_z = path_z+ delta;
    path(:,3) = path_z;
    
% landing, mode == 2 
else
    %Gradually descend from z = 1 to z = 0 +delta
    
    path_z = ones(1,size(path,1))';
    path_z(size(path,1),1) = 0;
    path_z(size(path,1)-3,1) = 0.8; 
    path_z(size(path,1)-2,1) = 0.5;
    path_z(size(path,1)-1,1) = 0.2;
    path_z = path_z+ delta;
    path(:,3) = path_z;
end

path3D = path;

end %func


