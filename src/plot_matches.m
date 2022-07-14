function [precise,recall,f1_score] = plot_matches(dataname,I1, I2, X, Y, Index, CorrectIndex)
%  
% *************************************************************************
% 
% PLOT_MATCHES(I1, I2, X, Y, VFCINDEX, CORRECTINDEX) considers correct 
%   indexes and indexes reserved by VFC, and then only plots the ture 
%   positive with blue lines, false positive with red lines For visibility, 
%   it plots at most NUMPLOT (Default value is 100) matches proportionately.
%   
% Input:    I1              - source image
%           I2              - target image
%           X               - N×2, positions of feature points in I1
%           Y               - N×2, positions of feature points in I2
%           Index           - Indexes reserved by mismatch removal method
%           CorrectIndex:   - ground-truth Correct indexes.
% Output:   precise         - precision of reserved feature matches
%           recall          - ratio of reserved correct matches and all
%                           correct matches
%           f1_score        - 2*precise*recall/(precise+recall)
% 
% Last updated by Yifan Xia, 07/14/2022
%
% *************************************************************************

NumPlot = 100;

n = size(X,1);
tmp=zeros(1, n);
tmp(Index) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)+1;
Correct = find(tmp == 2);
TruePos = Correct;   
TrueNeg = find(tmp==0);
tmp=zeros(1, n);
tmp(Index) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)-1;
FalsePos = find(tmp == 1); 
tmp=zeros(1, n);
tmp(CorrectIndex) = 1;
tmp(Index) = tmp(Index)-1;
FalseNeg = find(tmp == 1); 

TP = TruePos;
TN = TrueNeg;
FP = FalsePos;
FN = FalseNeg;

precise = length(TP)/(length(TP)+length(FP));
recall = length(TP)/(length(TP) + length(FN));
f1_score = 2*precise*recall/(precise+recall);

NumPos = length(TruePos)+length(FalsePos)+length(FalseNeg);

if NumPos > NumPlot
    t_p = length(TruePos)/NumPos;
    n1 = round(t_p*NumPlot);
    f_p = length(FalsePos)/NumPos;
    n2 = round(f_p*NumPlot);
    f_n = length(FalseNeg)/NumPos;
    n3 = round(f_n*NumPlot);
else
    n1 = length(TruePos);
    n2 = length(FalsePos);
    n3 = length(FalseNeg);
end

per = randperm(length(TruePos));
TruePos = TruePos(per(1:n1));
per = randperm(length(FalsePos));
FalsePos = FalsePos(per(1:n2));
per = randperm(length(FalseNeg));
FalseNeg = FalseNeg(per(1:n3));

figure;
interval = 5;
WhiteInterval = 255*ones(size(I1,1), interval, 3);
C = cat(2, I1, WhiteInterval, I2);
C = C(1:min(size(I1,1),size(I2,1)),1:size(I1,2)+size(I2,2)+3,:);
imagesc(C) ;
hold on ;

line([X(TruePos,1)'; Y(TruePos,1)'+size(I1,2)+interval], [X(TruePos,2)' ;  Y(TruePos,2)'],'linewidth', 1, 'color','b' ) ;%

line([X(FalsePos,1)'; Y(FalsePos,1)'+size(I1,2)+interval], [X(FalsePos,2)' ;  Y(FalsePos,2)'],'linewidth', 1, 'color','r') ;% 

msg = sprintf('%s - precision: %.2f%%  recall: %.2f%%', dataname,100*precise,100*recall);

text(10, 70, msg, 'FontUnits', 'pixels', 'FontSize', 10, 'Color', [0.99,0.99,0.99], 'BackgroundColor', [0.2,0.2,0.2]);

axis equal; axis off; 
hold off
drawnow;