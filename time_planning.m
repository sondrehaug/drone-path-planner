function ts = time_planning(path, avg_v)
ts = zeros(1,size(path,1));
dist = path(2:size(path,1),:)-path(1:size(path,1)-1,:);
dist2 = sqrt(dist(:,1).^2 +dist(:,2).^2 +dist(:,3).^2 );
for i  = 2:size(path,1)
    ts(i) = dist2(i-1)/avg_v + ts(i-1);
    if i == 2
        ts(i) = ts(i)+2;
    elseif i == size(path,1)
        ts(i) = ts(i)+2;
    end
end
ts = round(ts,1);
end


