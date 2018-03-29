function X = trajectory_optimization(path, ts)
   path0 = path;
   
   [m,n] = size(path0);
   
   m = m-1;
  

   
   % X contains the coefficients for all sub paths in all dimensions
   X = zeros(4*m,n);
   A = zeros(4*m, 4*m, n);
   Y = zeros(4*m,n);

   for i = 1:n
       A(:,:,i) = eye(4*m)*eps;
       idx = 1;
       for k = 1:(m-1)
           A(idx, 4*(k-1)+1:4*k, i) = [ts(k+1)^3, ts(k+1)^2, ts(k+1), 1];
           Y(idx,i) = path0(k+1,i);
           idx = idx + 1;
           A(idx, 4*(k)+1:4*(k+1), i) = [ts(k+1)^3, ts(k+1)^2, ts(k+1), 1];
           Y(idx,i) = path0(k+1,i);
           idx = idx + 1;
       end
       
       for k = 1:(m-1)
           A(idx, 4*(k-1)+1:4*k, i) = [3*ts(k+1)^2, 2*ts(k+1), 1, 0];
           A(idx, 4*(k)+1:4*(k+1), i) = -[3*ts(k+1)^2, 2*ts(k+1), 1, 0];
           Y(idx,i) = 0;
           idx = idx + 1;
       end
       
       for k = 1:(m-1)
           A(idx, 4*(k-1)+1:4*k, i) = [6*ts(k+1), 2, 0, 0];
           A(idx, 4*(k)+1:4*(k+1), i) = -[6*ts(k+1), 2, 0, 0];
           Y(idx,i) = 0;
           idx = idx + 1;
       end
       
       k = 1;
       A(idx, 4*(k-1)+1:4*k, i) = [ts(k)^3, ts(k)^2, ts(k), 1];
       Y(idx,i) = path0(k,i);
       idx = idx + 1;
       A(idx, 4*(k-1)+1:4*k, i) = [3*ts(k)^2, 2*ts(k), 1, 0];
       Y(idx,i) = 0;
       idx = idx + 1;
       k = m;
       A(idx, 4*(k-1)+1:4*k, i) = [ts(k+1)^3, ts(k+1)^2, ts(k+1), 1];
       Y(idx,i) = path0(k+1,i);
       idx = idx + 1;
       A(idx, 4*(k-1)+1:4*k, i) = [3*ts(k+1)^2, 2*ts(k+1), 1, 0];
       Y(idx,i) = 0;
       %Solve linear equations
       A(:,:,i) = A(:,:,i)+eye(4*m)*eps;
       X(:,i) = A(:,:,i)\Y(:,i);
   end

end