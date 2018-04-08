%function calc_all()
clear;    
clc;
isWithinConstraints = false;
avg_v = 1;
iterations = 0;

while ~isWithinConstraints
iterations = iterations + 1;
close all;
delete('path7.txt');
fileID = fopen('coordinates_task1_03ms.txt','r');
formatSpec = "%f %f";
A = fscanf(fileID,formatSpec, [2 inf])';
fclose(fileID);
fileID_path = fopen('path7.txt','a');


%----------------- takeoff from A --------------------%
delta = 0.185;
%delta = -0.1
mode = 0;
avg_v_takeoff = 0.2;
path_takeoff= [A(1,1), A(1,2),delta;
                A(1,1), A(1,2), 0.5 + delta;
                A(1,1), A(1,2),1+delta];
ts_takeoff = time_planning(path_takeoff, avg_v_takeoff,mode);
X_takeoff = traj_opt7(path_takeoff, ts_takeoff);
[x_takeoff, y_takeoff, z_takeoff] = write_trajectory7(X_takeoff, ts_takeoff, path_takeoff);
hold on;

%------------------ Stay in point A -----------------%
for i = 1:200
    fprintf(fileID_path,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
             A(1,1),A(1,2), 1 + delta, 0, 0, 0, 0, 0, 0);
end

%------------------ point A to B --------------------%

mode = 1;
point_b = 1;
for i = 1:size(A,1)    
        %point B
    if (A(i,1) == 2 && A(i,2) == 0)
    
        point_b = i;
    
    end
    
end

point_before_b = point_b - 1;
point_after_b = point_b + 1;

path_A_to_before_B = [A(1:point_before_b,1),A(1:point_before_b,2)];
path_A_to_before_B = path_2D_to_3D(path_A_to_before_B, mode);
ts_A_to_before_B = time_planning(path_A_to_before_B,avg_v,mode);
X_A_to_before_B = traj_opt7(path_A_to_before_B, ts_A_to_before_B);
write_trajectory7(X_A_to_before_B,ts_A_to_before_B,path_A_to_before_B);
hold on;
%---------------- Travel for point before B to after B ---------------%
avg_v_B = 0.10;
path_BB = [A(point_before_b:point_after_b,1),A(point_before_b:point_after_b,2)];
path_BB = path_2D_to_3D(path_BB, mode);
ts_BB = time_planning(path_BB,avg_v_B,mode);
X_BB = traj_opt7(path_BB, ts_BB);
write_trajectory7(X_BB,ts_BB,path_BB);
hold on;

%---------------- Travel from point after B to C ---------------%
mode = 2;
path_B_to_C = [A(point_after_b:size(A,1),1),A(point_after_b:size(A,1),2)];
path_B_to_C = path_2D_to_3D(path_B_to_C, mode);
ts_B_to_C = time_planning(path_B_to_C,avg_v,mode);
X_B_to_C = traj_opt7(path_B_to_C, ts_B_to_C);
write_trajectory7(X_B_to_C,ts_B_to_C,path_B_to_C);
hold on

%------------------ landing at point C --------------------%
mode = 2;
path_C_to_ground = [A(end,1),A(end,2), delta;
                    A(end,1),A(end,2), -0.5];
ts_C_to_ground = time_planning(path_C_to_ground, 0.1 ,mode);
X_C_to_ground = traj_opt7(path_C_to_ground, ts_C_to_ground);
write_trajectory7(X_C_to_ground, ts_C_to_ground, path_C_to_ground);

fclose(fileID_path);

% 
%     path_midair(:,1) = A(:, 1);
%     path_midair(:,2) = A(:, 2);
%     
%     path_z = ones(1,size(path_midair,1))';
%     path_z = path_z + delta;
%     path_midair(:,3) = path_z;
%     path_z = ones(1,size(path_midair,1))';
%     path_z(size(path_midair,1),1) = 0;
%     path_z(size(path_midair,1)-3,1) = 0.8;
%     path_z(size(path_midair,1)-2,1) = 0.5;
%     path_z(size(path_midair,1)-1,1) = 0.2;
%     path_z = path_z + delta;
%    
%     mode = 2;
% 
%     path_midair(:,3) = path_z;
% 
%     ts_midair = time_planning(path_midair,avg_v,mode);
%     X_midair = traj_opt7(path_midair, ts_midair);
%     write_trajectory7(X_midair,ts_midair,path_midair);

%     fclose(fileID_path);

    isWithinConstraints = checkWithinConstraints();
    avg_v = avg_v * 0.95;

end

tot_time = ts_takeoff(end) + ts_A_to_before_B(end) + ts_B_to_C(end)


% Plotting the obstacles: 
fileID_obstacles = fopen('obstacles.txt','r');
ObstaclesMatrix = fscanf(fileID_obstacles, formatSpec, [2 inf])';
[n_obstacles, ~] = size(ObstaclesMatrix);
% Generate cylinder with radius = 0.2m
[X_obs, Y_obs, Z_obs] = cylinder(0.2);


for i_obs = 1:n_obstacles
    x_shift = ObstaclesMatrix(i_obs,1);
    y_shift = ObstaclesMatrix(i_obs,2);
    surf(X_obs + x_shift, Y_obs + y_shift, Z_obs.*2);
    hold on
end
hold off;
avg_v
iterations
%end