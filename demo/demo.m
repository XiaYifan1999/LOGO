
% demo for mismatch removal on an image pair 
% Author:   Yifan Xia (xiayifan@whu.edu.cn)
% Date:     07/13/2022

clc; clear; close all;

addpath('../src');
addpath('../data');

%% Load Data - single image pair

dataname = 'biscuit';

load([dataname,'.mat']);


%% Mismatch Removal

tic;

idx = LOGO(X,Y);

toc;

%% Result Display

[Iusl,Iusr] = uniform_size(I1,I2);
[precise,recall,f1_score] = plot_matches(dataname, Iusl, Iusr, X, Y, idx, CorrectIndex);