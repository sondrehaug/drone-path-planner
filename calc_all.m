clear;
clc;
delete('path7.txt');
fileID = fopen('coordinates.txt','r');
formatSpec = "%f %f";
A = fscanf(fileID,formatSpec, [2 inf])';
fclose(fileID);
fileID_path = fopen('path7.txt','a');


%----------------- takeoff from A --------------------%
delta = 0.185;
mode = 0;
avg_v_takeoff = 0.4;
path_takeoff= [A(1,1), A(1,2),delta;
                A(1,1), A(1,2), 0.5 + delta;
                A(1,1), A(1,2),1+delta];
ts_takeoff = time_planning(path_takeoff, avg_v_takeoff,mode);
X_takeoff = traj_opt7(path_takeoff, ts_takeoff);
[x_takeoff, y_takeoff, z_takeoff] = write_trajectory7(X_takeoff, ts_takeoff, path_takeoff);
hold on;

%------------------ Stay in point B -----------------%
for i = 1:200
    fprintf(fileID_path,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
             A(1,1),A(1,2), 1 + delta, 0, 0, 0, 0, 0, 0);
end

%------------------ point A to B --------------------%
mode = 1;
avg_v = 0.4;
point_b = 1;
for i = 1:size(A,1)    
        %point B
    if (A(i,1) == 2 && A(i,2) == 0)
    
        point_b = i;
    
    end
    
end

path_A_to_B = [A(1:point_b,1),A(1:point_b,2)];
path_A_to_B = path_2D_to_3D(path_A_to_B, mode);
ts_A_to_B = time_planning(path_A_to_B,avg_v,mode);
X_A_to_B = traj_opt7(path_A_to_B, ts_A_to_B);
write_trajectory7(X_A_to_B,ts_A_to_B,path_A_to_B);

%------------------ Stay in point B -----------------%

for i = 1:60

fprintf(fileID_path,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
         A(point_b,1),A(point_b,2),1+delta,0,0,0,0,0,0);

end

%------------------ point A to B --------------------%
mode = 2;
avg_v = 0.4;

path_B_to_C = [A(point_b:size(A,1),1),A(point_b:size(A,1),2)];
path_B_to_C = path_2D_to_3D(path_B_to_C, mode);
ts_B_to_C = time_planning(path_B_to_C,avg_v,mode);
X_B_to_C = traj_opt7(path_B_to_C, ts_B_to_C);
write_trajectory7(X_B_to_C,ts_B_to_C,path_B_to_C);

fclose(fileID_path);