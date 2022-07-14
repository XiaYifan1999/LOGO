function [x0, A] = LOGO_LAC(X,Y)

% *********************************************************************

% Author: Yifan Xia, xiayifan@whu.edu.cn  07/14/2022
% details refer to Locality-guided Global-preserving Optimization
%  accepted by 'IEEE Transactions on Image Processing' 

% Input:    X   - N×2, positions of feature points in I1
%           Y   - N×2, positions of feature points in I2
% Output:   x0  - the initialization of integer quadratic programming
%           A   - Affinity matrix containing geometric topology

% *********************************************************************

%% Local_KNN_neighbors

% parameters setting

K = 6; tau = 0.5; 

% select neighbors

Xt = X';    Yt = Y';    N = size(Xt,2);

kdtreeX = vl_kdtreebuild(Xt);
kdtreeY = vl_kdtreebuild(Yt);

[neighborX, ~] = vl_kdtreequery(kdtreeX,Xt,Xt, 'NumNeighbors',K+1);
[neighborY, ~] = vl_kdtreequery(kdtreeY,Yt,Yt,'NumNeighbors', K+1);

neighborIndex = [neighborX; neighborY];
index = sort(neighborIndex);

temp1 = diff(index);
temp2 = (temp1 == zeros(size(temp1, 1),size(temp1, 2)));
ni = sum(temp2);

set0 = find(((ni./K)>=tau)'==1);
if length(set0)<4
    error('Reference point set too small, try lowering parameter-tau.');
end

kdtreeX2 = vl_kdtreebuild(Xt(:,set0));
[neighbors,~] = vl_kdtreequery(kdtreeX2, Xt(:,set0), Xt, 'NumNeighbors',5);
neighbors = neighbors(2:5,:);
neighbors = set0(neighbors);

%% Calculate Local Affine

% parameters

delta = 1e-2; 
epsilon = 0.4; 

% calculate affines

Affine=cell(1,N);
dia = zeros(1,N);
for i=1:N
    A_T = [Xt(:,neighbors(:,i)); ones(1,size(neighbors,1))];
    B_T = Yt(:,neighbors(:,i));
    x = pinv(A_T*A_T')*(A_T*B_T');
    s = sum(([X(i,:),1]*x-Y(i,:)).^2); 
    dia(i) = 2/(1+exp(delta*s));
    Affine{i}=x;
end
x0 = (dia>epsilon)';

%% Construct Affinity

zeta=0.9; 

% preserve global structure

Xaa=[X';ones(1,N)]';
Ya = zeros(N,2);
for i=1:N
    Ya(i,:) = Xaa(i,:)*Affine{i};
end

W_mol_X=(repmat(X(:,1),1,N)-repmat(X(:,1),1,N)').^2+(repmat(X(:,2),1,N)-repmat(X(:,2),1,N)').^2;
W_mol_Y=(repmat(Y(:,1),1,N)-repmat(Y(:,1),1,N)').^2+(repmat(Y(:,2),1,N)-repmat(Y(:,2),1,N)').^2;
distance=W_mol_X/(sum(max(X)-min(X)).^2)+W_mol_Y/(sum(max(Y)-min(Y)).^2);

W = 2./(1+exp(distance))-eye(N);

d1=sqrt(repmat(Y(:,1), 1, N)-repmat(Y(:,1), 1, N)').^2+(repmat(Y(:,2), 1, N)-repmat(Y(:,2), 1, N)').^2;
d2=sqrt(repmat(Ya(:,1), 1, N)-repmat(Ya(:,1), 1, N)').^2+(repmat(Y(:,2), 1, N)-repmat(Y(:,2), 1, N)').^2;
S=2./(1+exp(delta.*abs(d1-d2)));
S=S>zeta;

A=W.*S/1000+diag(dia);

end