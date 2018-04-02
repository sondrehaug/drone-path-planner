function [x, y, z] = write_trajectory7( X,ts, path )
fileID = fopen('path7.txt','a');
%fprintf(fileID,'-1.500 1.500 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000\n');
count = 0;
for k = 1:size(path,1)-1
    subPath = X(8*(k-1)+1:8*k,1:3);
    t = ts(k) + 0.05:0.05:ts(k+1);
    vec1 = subPath(:,1);
    vec2 = subPath(:,2);
    vec3 = subPath(:,3);
    for i = 1:length(t)
         pol = [t(i)^7,t(i)^6,t(i)^5,t(i)^4,t(i)^3,t(i)^2,t(i),1]';
         d_pol = [7*t(i)^6,6*t(i)^5,5*t(i)^4,4*t(i)^3,3*t(i)^2,2*t(i),1,0]';
         dd_pol = [42*t(i)^5,30*t(i)^4,20*t(i)^3,12*t(i)^2,6*t(i),2,0,0]';
         x(i+count) = sum(vec1.*pol);
         y(i+count) = sum(vec2.*pol);
         z(i+count) = sum(vec3.*pol);
         v_x(i+count) = sum(vec1.*d_pol);
         v_y(i+count) = sum(vec2.*d_pol);
         v_z(i+count) = sum(vec2.*d_pol);
         a_x(i+count) = sum(vec1.*dd_pol);
         a_y(i+count) = sum(vec2.*dd_pol);
         a_z(i+count) = sum(vec1.*dd_pol);
             
         fprintf(fileID,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f 0.000 0.000\n',...
             x(i+count),y(i+count),z(i+count), v_x(i+count),v_y(i+count),v_z(i+count),a_x(i+count),a_y(i+count),a_z(i+count));

     
    end
    
    count = count + length(t);
end
%fprintf(fileID,'-1.500 -1.500 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000\n');
%fclose(fileID);

end


