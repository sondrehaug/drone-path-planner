%***************************************************
% Purpose: Calculate and return a set of time
% intervals between each point in all subpaths
%***************************************************
% Variables: 
% name         I/O   Description
% --------------------------------------------------
% path          I    3D file with coordinates (x,y,z)
% avg_v         I    Average velocity
% mode          I    Flying mode of the path
% ts            O    Z dimension to be added
% dist1         I    2D file with coordinates (x,y)
% dist2         O    3D file with coordinates (x,y,z)
% count         I    Counter
%
% Constants:
% name         I/O   Description
% --------------------------------------------------
% dt_start      I    Used for smoothening trajectory
% dt_stop       I    Used for smoothening trajectory
%***************************************************

function ts = time_planning(path, avg_v,mode)

% mode = 0 (take off), mode = 1 (middair), mode = 2 (descend), mode = 3
% (landing)

% Initialization
count = 0;
dt_start = 0;
dt_stop = 0;
ts = zeros(1,size(path,1));

% Position coordinates in 3-dimensions
dist = path(2:size(path,1),:)-path(1:size(path,1)-1,:);

% 3D-vector between points
dist2 = sqrt(dist(:,1).^2 +dist(:,2).^2 +dist(:,3).^2 );


% adding time for larger curved path
% mode = 0 (take off), mode = 1 (middair), mode = 2 (descend), mode = 3
% (landing)
if (mode == 0)
    dt_start = 0;
    dt_stop = 0;
elseif(mode == 1)
    dt_start = 1.0;
    dt_stop = 1.0;
elseif(mode == 2)
    dt_start = 0;
    dt_stop = 0;
elseif(mode == 3)
    dt_start = 0;
    dt_stop = 0;
end
        
        % Calculates time interval for each subpath
        for i  = 2:size(path,1)
            ts(i) = dist2(i-1)/avg_v + ts(i-1);
            
            if i == 2
                ts(i) = ts(i)+dt_start; %Add dt for first subpath
            elseif i == size(path,1)
                ts(i) = ts(i)+dt_stop; %Add dt for last subpath
            end
            
            % Check if last element in path is point B
            % Make sure that the velocities in subpath before and after
            % point B has an average speed of 0.3-0.4 [m/s]
            if(path(size(path,1),1)== -1.500 && path(size(path,1),2)...
                    == -1.500 && path(1,1)== -1.500 && path(1,2) == 1.500)        
                
                % If current coordinate is point B (x,y) = (2,0)
                if (path(i,1) == 2 && path(i,2) == 0)
                
                % Average speed for subpath before point B
                ts(i) = dist2(i-1)/0.40 + ts(i-1);
                count = count+1;
                elseif (count == 1) 
                
                % Average speed for subpath after point B
                ts(i) = dist2(i-1)/0.40 + ts(i-1);
                count = count+1;
                end %if

            end %if
            
        end %for
        
        ts = round(ts,1);
end %func
    
    
  
        
   
        
        
 

