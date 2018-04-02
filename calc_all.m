% This code will generate path7.txt 

clear all;
clc;
close all;
delete('path7.txt');

fileID = fopen('coordinates.txt','r');
%fileID = fopen('coordinates_task1_03ms.txt','r');
formatSpec = "%f %f";
delta = 0.185;
A = fscanf(fileID, formatSpec, [2 inf])';
fclose(fileID);

%Take-off
path_takeoff= [A(1,1), A(1,2),delta;
                A(1,1), A(1,2), 0.5 + delta;
                A(1,1), A(1,2),1+delta];
avg_v_takeoff = 0.3;
ts_takeoff = time_planning(path_takeoff, avg_v_takeoff);
X_takeoff = traj_opt7(path_takeoff, ts_takeoff);
[x_takeoff, y_takeoff, z_takeoff] = write_trajectory7(X_takeoff, ts_takeoff, path_takeoff);

% Hover for 10 seconds at (x0, y0, 1):
for i = 1:200
    fprintf(fileID,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
             A(1,1),A(1,2), 1 + delta, 0, 0, 0, 0, 0, 0);
end

%Mid-air until point C. Generating smooth landing
path_z = ones(1, size(A,1))';
path_z(size(A,1)) = 0;
path_z(size(A,1)-3) = 0.8;
path_z(size(A,1)-2) = 0.5;
path_z(size(A,1)-1) = 0.2;
path_z = path_z + delta;

path_mid_air(:,1) = A(:, 1);
path_mid_air(:,2) = A(:, 2);
path_mid_air(:,3) = path_z;

%Mid-air & landing
avg_v_mid_air = 0.4;
ts_mid_air = time_planning(path_mid_air, avg_v_mid_air);
X_mid_air = traj_opt7(path_mid_air, ts_mid_air);
[x_mid_air, y_mid_air, z_mid_air] = write_trajectory7(X_mid_air, ts_mid_air, path_mid_air);

plot3(x_takeoff,y_takeoff,z_takeoff,'g');
hold on;
plot3(x_mid_air, y_mid_air, z_mid_air,'g');

