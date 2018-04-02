clear;
clc;
% path =    [-1.5000,    1.5000,         0;
%    -0.5,    0.5,    1.0000;
%          0.25,    0,    1.0000;
%     0,    -1,    1.0000;
%    -0.7500,   -1.7500,    1.0000;
%    -1.5000,   -1.5000,    0.0000];
fileID = fopen('coordinates.txt','r');
formatSpec = "%f %f";

A = fscanf(fileID,formatSpec, [2 inf])';

path0 = ones(1, size(A,1))';
path0(1) = 0;
path0(size(A,1)) = 0;

path(1:size(A,1),1:2) = A;
path(:,3) = path0;


avg_v = 0.4;
fclose(fileID);
ts = time_planning(path,avg_v);

X = trajectory_optimization(path, ts);
X2 = traj_opt7(path, ts);

write_trajectory( X,ts,path );
hold on
write_trajectory7( X2,ts,path );