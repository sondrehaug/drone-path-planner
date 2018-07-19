clear;    
clc;

fprintf('This is a simulation for a drone path planner. Please select the desired option:\n');
disp('1: Task 1 - Path from A-B-C navigating around 3 obstacles with a stop in B\n');
disp('2: Task 2 - Path from A-B-C navigating around 3 obstacles with 0.3m/s through B\n');
disp('3: Task 3 - Path from A-B-C navigating around 4 obstacles with a stop in B\n');
taskChoice = input('Choice: ');


% Setting some initial variables:
isWithinConstraints = false;
avg_v = 1.0;
iterations = 0;
delta = 0.185;
avg_v_takeoff = 0.2;
avg_v_straight_down = 0.1;
formatSpec = "%f %f";
B = [2, 0]; % Point B
RADIUS_OBSTACLE = 0.4;


while ~isWithinConstraints
iterations = iterations + 1;
close all;
delete('path7.txt');
delete('Js.txt');

if(taskChoice == 1)
    fileID = fopen('coordinates.txt','r');

elseif(taskChoice == 2)
    fileID = fopen('coordinates_task1_03ms2.txt','r');

elseif(taskChoice == 3)
    fileID = fopen('coordinates_task3.txt','r');
end

WayPoints = fscanf(fileID,formatSpec, [2 inf])';
fclose(fileID);
fileID_path = fopen('path7.txt','a');
fileID_Js = fopen('Js.txt', 'a');

%----------------- Takeoff from A --------------------%
mode = 0;
path_takeoff= [WayPoints(1,1), WayPoints(1,2), delta;
                WayPoints(1,1), WayPoints(1,2), 0.5 + delta;
                WayPoints(1,1), WayPoints(1,2),1 + delta];
ts_takeoff = time_planning(path_takeoff, avg_v_takeoff,mode);
X_takeoff = traj_opt7(path_takeoff, ts_takeoff);
[x_takeoff, y_takeoff, z_takeoff] = write_trajectory7(X_takeoff, ts_takeoff, path_takeoff);
hold on;

%------------------ Stay in point A -----------------%
for i = 1:200
    fprintf(fileID_path,'%.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f 0.000 0.000\n',...
             WayPoints(1,1),WayPoints(1,2), 1 + delta, 0, 0, 0, 0, 0, 0);
    fprintf(fileID_Js,'%.3f %.3f %.3f\n', 0, 0, 0);
end

if (taskChoice == 1 || taskChoice == 3)
    %------------------ point A to B --------------------%
    mode = 1; % Constant altitude
    point_B_index = find(WayPoints(:,1) == B(1) & WayPoints(:,2) == B(2)); 
    path_A_to_B_2D = WayPoints(1:point_B_index, :);
    path_A_to_B = path_2D_to_3D(path_A_to_B_2D, mode);
    ts_A_to_B = time_planning(path_A_to_B, avg_v, mode);
    X_A_to_B = traj_opt7(path_A_to_B, ts_A_to_B);
    write_trajectory7(X_A_to_B, ts_A_to_B, path_A_to_B);
    hold on;
    %------------------ Stay in point B -----------------%

    for i = 1:60
    fprintf(fileID_path,'%.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f 0.000 0.000\n',...
             WayPoints(point_B_index,1), WayPoints(point_B_index,2), 1+delta,0,0,0,0,0,0);
    fprintf(fileID_Js,'%.3f %.3f %.3f\n', 0, 0, 0);
    end

    %------------------ point B to C --------------------%
    mode = 2; % Decending in the last 4 waypoints

    path_B_to_C = WayPoints(point_B_index:end,:);
    path_B_to_C = path_2D_to_3D(path_B_to_C, mode);
    ts_B_to_C = time_planning(path_B_to_C, avg_v, mode);
    X_B_to_C = traj_opt7(path_B_to_C, ts_B_to_C);
    write_trajectory7(X_B_to_C,ts_B_to_C,path_B_to_C);

elseif (taskChoice == 2)
    %------------------ point A to C --------------------%
    mode = 2;
    path_A_to_C = WayPoints;
    path_A_to_C = path_2D_to_3D(path_A_to_C, mode);
    ts_A_to_C = time_planning(path_A_to_C,avg_v,mode);
    X_A_to_C = traj_opt7(path_A_to_C, ts_A_to_C);
    write_trajectory7(X_A_to_C,ts_A_to_C,path_A_to_C);
    hold on;
end

%------------------ Landing at point C --------------------%
mode = 2;
path_C_to_ground = [WayPoints(end,1),WayPoints(end,2), delta;
                    WayPoints(end,1),WayPoints(end,2), -0.5];
ts_C_to_ground = time_planning(path_C_to_ground, avg_v_straight_down, mode);
X_C_to_ground = traj_opt7(path_C_to_ground, ts_C_to_ground);
write_trajectory7(X_C_to_ground, ts_C_to_ground, path_C_to_ground);

fclose(fileID_path);
fclose(fileID_Js);

isWithinConstraints = checkWithinConstraints();
avg_v = avg_v * 0.95;

end %while

if(taskChoice == 1 || taskChoice == 3)
    tot_time = ts_A_to_B(end) + 3 + ts_B_to_C(end);
elseif(taskChoice == 2)
    tot_time = ts_A_to_C(end);
end

%% Plotting the obstacles: 
if (taskChoice == 1 || taskChoice == 2)
    fileID_obstacles = fopen('obstacles.txt','r');
elseif (taskChoice == 3)
    fileID_obstacles = fopen('obstacles_task3.txt','r');
end

ObstaclesMatrix = fscanf(fileID_obstacles, formatSpec, [2 inf])';
n_obstacles = size(ObstaclesMatrix, 1);
% Generate cylinder
[X_obs, Y_obs, Z_obs] = cylinder(RADIUS_OBSTACLE);

for i_obs = 1:n_obstacles
    x_shift = ObstaclesMatrix(i_obs,1);
    y_shift = ObstaclesMatrix(i_obs,2);
    surf(X_obs + x_shift, Y_obs + y_shift, Z_obs.*2);
    hold on
end
hold off;

fprintf('Total time: %.1f seconds\n', tot_time);
fprintf('Average velocity: %.3f m/s\n', avg_v);

if (taskChoice == 2)
    fileID = fopen('path7.txt','r');
    formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
    Generated_path = fscanf(fileID,formatSpec, [11 inf])';
    fclose(fileID);
    point_B_index_GP = find(Generated_path(:,1) == B(1) & Generated_path(:,2) == B(2));
    v_x_B = Generated_path(point_B_index_GP, 4);
    v_y_B = Generated_path(point_B_index_GP, 5);
    v_B = sqrt(v_x_B^2 + v_y_B^2);
    fprintf('Velocity through B: v_x = %.3f, v_y = %.3f, v_B = %.3f\n',v_x_B, v_y_B, v_B);
end

plotTrajectory();