function idx = LOGO(X,Y)

% ************************************************************************

% code of Locality-guided Global-preserving Optimization
%  accepted by 'IEEE Transactions on Image Processing' 
% created by Yifan Xia (xiayifan@whu.edu.cn) 07/14/2022

% Input:    X - N×2, positions of feature points in I1
%           Y - N×2, positions of feature points in I2
% Output:   idx - the index of correct matches identified by LOGO

% ************************************************************************

%% uniform data format 

if size(X,1)<4
    X=X';
end

if size(Y,1)<4
    Y=Y';
end

if size(X,2)==3
    X = X(:,1:2);
end

if size(Y,2)==3
    Y = Y(:,1:2);
end

%% mismatch removal by LOGO

[x0, A] = LOGO_LAC(X,Y);  

lambda=0.8;

x = LOGO_Gopt(x0,A,lambda);

idx = find(x);

end
