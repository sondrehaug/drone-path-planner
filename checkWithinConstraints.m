function isWithinConstraints = checkWithinConstraints()

isWithinConstraints = true;
fileID = fopen('path7.txt','r');
formatSpec = "%f %f %f %f %f %f %f %f %f %f %f";
pathMatrix = fscanf(fileID,formatSpec, [11 inf])';
fclose(fileID);

fileID_Js = fopen('Js.txt','r');
formatSpec_Js = "%f %f %f";
JsMatrix = fscanf(fileID_Js,formatSpec_Js, [3 inf])';
fclose(fileID_Js);

[Nrows,~] = size(pathMatrix);
[Nrows_Js,~] = size(JsMatrix);

for i=1:Nrows
   % v_s = 3.1
    v_s = sqrt(pathMatrix(i, 4)^2 + pathMatrix(i, 5)^2);
    if v_s > 2.5
       isWithinConstraints = false;
       fprintf('v_s');
       return 
    end
    
    if pathMatrix(i, 6) > 2.2 || pathMatrix(i, 6) < -0.55
       isWithinConstraints = false;
       fprintf('v_z')
       return 
    end
    
    %a_s
    a_s = sqrt(pathMatrix(i, 7)^2 + pathMatrix(i, 8)^2);
    if a_s > 2.0
       isWithinConstraints = false;
       fprintf('a_s');
       return 
    end
    
    % a_z = -0.55,2.2
    if pathMatrix(i, 9) > 1.5 || pathMatrix(i, 9) < -0.30
       isWithinConstraints = false;
       fprintf('a_z');
       return 
    end
    
    
end %for

for i = 1:Nrows_Js
j_h = sqrt(JsMatrix(i, 1)^2 + JsMatrix(i, 2)^2);
    if j_h > 7.1
       isWithinConstraints = false;
       fprintf('j_s');
       return 
    end
    
    if JsMatrix(i, 3) > 5 || JsMatrix(i, 3) < -5
       isWithinConstraints = false;
       fprintf('J_z')
       return 
    end
end %for

end