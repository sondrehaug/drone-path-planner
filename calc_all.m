clear;
clc;
path =    [-1.5000,    1.5000,         0;
   -0.5,    0.5,    1.0000;
         0.25,    0,    1.0000;
    0,    -1,    1.0000;
   -0.7500,   -1.7500,    1.0000;
   -1.5000,   -1.5000,    0.0000];

avg_v = 0.4;

ts = time_planning(path,avg_v);

X = trajectory_optimization(path, ts);

write_trajectory( X,ts,path );