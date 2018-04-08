function isWithinConstraints = checkWithinConstraints()

isWithinConstraints = true;
fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
pathMatrix = fscanf(fileID,formatSpec, [11 inf])';
fclose(fileID);

[Nrows,~] = size(pathMatrix);

for i=1:Nrows
   
    v_s = sqrt(pathMatrix(i, 4)^2 + pathMatrix(i, 5)^2);
    if v_s > 2.8
       isWithinConstraints = false;
       fprintf('v_s');
       return 
    end
    
    if pathMatrix(i, 6) > 2.2 || pathMatrix(i, 6) < -0.55
       isWithinConstraints = false;
       fprintf('v_z')
       return 
    end
    
    a_s = sqrt(pathMatrix(i, 7)^2 + pathMatrix(i, 8)^2);
    if a_s > 2.0
       isWithinConstraints = false;
       fprintf('a_s');
       return 
    end
    
    if pathMatrix(i, 9) > 1.5 || pathMatrix(i, 9) < -0.30
       isWithinConstraints = false;
       fprintf('a_z');
       return 
    end
    
    
end %for
end