function plotTrajectory()

fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
A = fscanf(fileID,formatSpec, [11 inf])';
fclose(fileID);

figure(1)
plot(A(:,4));
hold on
plot(A(:,5));
hold on
plot(A(:,6));
title('vel')

figure(2)
plot(A(:,7));
hold on
plot(A(:,8));
hold on
plot(A(:,9));
title('acc');

end