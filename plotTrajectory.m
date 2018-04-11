function plotTrajectory()

fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
A = fscanf(fileID,formatSpec, [11 inf])';
fclose(fileID);
N_datapoints = size(A,1);
time_vec = 0.05:0.05:(N_datapoints * 0.05);
v_h = sqrt(A(:,4).^2 + A(:,5).^2);
a_h = sqrt(A(:,7).^2 + A(:,8).^2);

fileID_Js = fopen('Js.txt','r');
formatSpec = "%f %f %f";
JsMatrix = fscanf(fileID, formatSpec, [3 inf])';
fclose(fileID_Js);
N_datapoints_Js = size(JsMatrix,1);
time_vec_Js = 0.05:0.05:(N_datapoints_Js * 0.05);

Js_h = sqrt(JsMatrix(:,1).^2 + JsMatrix(:,2).^2);

figure()
subplot(4,1,1);
plot(time_vec, A(:,1));
hold on
plot(time_vec, A(:,2));
hold on
plot(time_vec, A(:,3));
title('Position')
xlabel('Time[s]')
ylabel('Position[m]')
legend('x','y','z')

subplot(4,1,2);
plot(time_vec, v_h);
hold on
plot(time_vec, A(:,6));
title('Velocities')
xlabel('Time[s]')
ylabel('Velocity[m/s]')
legend('v_h','v_z')

subplot(4,1,3);
plot(time_vec, a_h);
hold on
plot(time_vec, A(:,9));
title('Acceleration');
xlabel('Time[s]')
ylabel('Acceleration[m/s^2]')
legend('a_h','a_z')

subplot(4,1,4);
plot(time_vec_Js, Js_h);
hold on
plot(time_vec_Js, A(:,9));
title('Jerk');
xlabel('Time[s]')
ylabel('Jerk[m/s^3]')
legend('Js_h','Js_z')

end