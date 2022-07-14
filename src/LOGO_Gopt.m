function [x, i] = LOGO_Gopt(x0,A0,lambda)

% Fixed Progressive Optimization
% Author: Yifan Xia, 07/23/2022

maxIter = 10;   A =A0-lambda*eye(length(x0));

x_star=x0;      x_now=x0;   S=x0'*A*x0;

for i=0:maxIter-1

    b=(A*x_now)>0; 
    C=x_now'*A*(b-x_now);
    D=(b-x_now)'*A*(b-x_now);
    if D>=0
        x_new=b;
    else
        r=min(-C/D,1);
        x_new=x_now+r*(b-x_now);
    end
    if b'*A*b>=S
        S=b'*A*b;
        x_star=b;
    end
    if sum(abs(x_new-x_now))/(sum(abs(x_now)))<1e-4|| i==maxIter-1
        break;
    end
    x_now=x_new;
end

x=x_star;

end