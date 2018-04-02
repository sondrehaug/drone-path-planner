clear;
clc;
delete('path7.txt');
% path =    [-1.5000,    1.5000,         0;
%    -0.5,    0.5,    1.0000;
%          0.25,    0,    1.0000;
%     0,    -1,    1.0000;
%    -0.7500,   -1.7500,    1.0000;
%    -1.5000,   -1.5000,    0.0000];
fileID = fopen('coordinates.txt','r');
formatSpec = "%f %f";

delta = 0.185;
A = fscanf(fileID,formatSpec, [2 inf])';

fileID_path = fopen('path7.txt','a');


%Take-off
path_takeoff= [A(1,1), A(1,2),delta;
                A(1,1), A(1,2), 0.5 + delta;
                A(1,1), A(1,2),1+delta];
avg_v_takeoff = 0.4;
ts_takeoff = time_planning(path_takeoff, avg_v_takeoff);
X_takeoff = traj_opt7(path_takeoff, ts_takeoff);
[x_takeoff, y_takeoff, z_takeoff] = write_trajectory7(X_takeoff, ts_takeoff, path_takeoff);

% Hover for 10 seconds at (x0, y0, 1):
for i = 1:200
    fprintf(fileID_path,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
             A(1,1),A(1,2), 1 + delta, 0, 0, 0, 0, 0, 0);
end

%point A to B with stop
point_b = 1;
for i = 1:size(A,1)    
        %point B
    if (A(i,1) == 2 && A(i,2) == 0)
    
        point_b = i;
    
    end
    
end

path_A_to_B = [A(1:point_b,1),A(1:point_b,2)];

%adding third dim
path0 = ones(1,size(path_A_to_B,1))';
path0 = path0+ delta;
path_A_to_B(:,3) = path0;

avg_v = 0.4;
ts_A_to_B = time_planning(path_A_to_B,avg_v);
X_A_to_B = traj_opt7(path_A_to_B, ts_A_to_B);

write_trajectory7(X_A_to_B,ts_A_to_B,path_A_to_B);
hold on;

%%%%%%%%%% STAY IN POINT B %%%%%%%%%%%

for i = 1:60

fprintf(fileID_path,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
         A(point_b,1),A(point_b,2),1+delta,0,0,0,0,0,0);

end

fclose(fileID);

path_B_to_C = [A(point_b:size(A,1),1),A(point_b:size(A,1),2)];
path0 = ones(1,size(path_B_to_C,1))';
path0(size(path_B_to_C,1),1) = 0;
path0(size(path_B_to_C,1)-3,1) = 0.8;
path0(size(path_B_to_C,1)-2,1) = 0.5;
path0(size(path_B_to_C,1)-1,1) = 0.2;
path0 = path0+ delta;
path_B_to_C(:,3) = path0;

avg_v = 0.4;
ts_B_to_C = time_planning(path_B_to_C,avg_v);
X_B_to_C = traj_opt7(path_B_to_C, ts_B_to_C);

write_trajectory7(X_B_to_C,ts_B_to_C,path_B_to_C);

fclose(fileID_path);