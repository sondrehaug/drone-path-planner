function ts = time_planning(path, avg_v,mode)

% mode = 0 (take off), mode = 1 (middair), mode = 2 (landing)


a = 0;
ts = zeros(1,size(path,1));
dist = path(2:size(path,1),:)-path(1:size(path,1)-1,:);
dist2 = sqrt(dist(:,1).^2 +dist(:,2).^2 +dist(:,3).^2 );

if (mode == 0)
    dt_start = 0;
    dt_stop = 0;
elseif(mode == 1)
    dt_start = 2.5;
    dt_stop = 0;
else
    dt_start = 0;
    dt_stop = 0;
end
        for i  = 2:size(path,1)
            ts(i) = dist2(i-1)/avg_v + ts(i-1);
            
            if i == 2
                ts(i) = ts(i)+dt_start;
            elseif i == size(path,1)
                ts(i) = ts(i)+dt_stop;
            end
            
            % Check if last element in path is point B
            % Meaning we want to stop in point B
            if(path(size(path,1),1)== -1.500 && path(size(path,1),2) == -1.500 && path(1,1)== -1.500 && path(1,2) == 1.500)        
                    
                if (path(i,1) == 2 && path(i,2) == 0)
                
                ts(i) = dist2(i-1)/0.40 + ts(i-1);
                a = a+1;
                elseif (a == 1) 
        
                ts(i) = dist2(i-1)/0.40 + ts(i-1);
                a = a+1;
                end %if

            end %if
            
        end %for
        ts = round(ts,1);
end %func
    
    
  
        
   
        
        
 

