function path3D = path_2D_to_3D(path, mode)
delta = 0.185;

% middair
if mode == 1
    path_z = ones(1,size(path,1))';
    path_z = path_z+ delta;
    path(:,3) = path_z;
% landing    
else
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


