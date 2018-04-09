function plotTrajectory()

fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
A = fscanf(fileID,formatSpec, [11 inf])';
fclose(fileID);
N_datapoints = size(A,1);
time_vec = 0.05:0.05:(N_datapoints * 0.05);

figure()
subplot(3,1,1);
plot(time_vec, A(:,1));
hold on
plot(time_vec, A(:,2));
hold on
plot(time_vec, A(:,3));
title('Position')
xlabel('Time[s]')
ylabel('Position[m]')
legend('x','y','z')


subplot(3,1,2);
plot(time_vec, A(:,4));
hold on
plot(time_vec, A(:,5));
hold on
plot(time_vec, A(:,6));
title('Velocities')
xlabel('Time[s]')
ylabel('Velocity[m/s]')
legend('v_x','v_y','v_z')

subplot(3,1,3);
plot(time_vec, A(:,7));
hold on
plot(time_vec, A(:,8));
hold on
plot(time_vec, A(:,9));
title('Acceleration');
xlabel('Time[s]')
ylabel('Acceleration[m/s^2]')
legend('a_x','a_y','a_z')

end