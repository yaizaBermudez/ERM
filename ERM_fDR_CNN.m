%% ERM-fDR CNN
clc;
clear;
close all;

PathData = '/Users/ybermude/Documents/Documents-MAC-07006074/Code/ERM_fDR_ANN/Simulation/';
PathFigures = '/Users/ybermude/Documents/Documents-MAC-07006074/Code/ERM_fDR_ANN/Plots';

%%
function [x,y] = formatdata(data)
n_samples = size(data,1);   % Number of samples use
labels = data(1:n_samples,1);
y = zeros(10,n_samples); % Correct outputs  to vector
for i = 1:n_samples
    y(labels(i)+1,i) = 1;
end
x = data(1:n_samples,2:785);
x = x/255;
end

function Lzbis = empiricalrisk(model,x,y)
n = length(y);
x = x';
w4 = model{5}; w3 = model{3}; w2 = model{1};
b4 = model{6}; b3 = model{4}; b2 = model{2};

out2 = elu_fast(w2*x+b2);
out3 = elu_fast(w3*out2+b3);
out = elu_fast(w4*out3+b4);

[~,ind] = max(out);
num = ind-1;

%acc  = sum((0==(y'-num)));  % This is accuracy
loss = sum(~(0==(y'-num))); % This is the loss

Lz = loss/n;
end

function Lz = empiricalrisk(model, x, y)
    x = x';  % size: [784 × n]
    n = size(x, 2);

    w2 = model{1}; b2 = model{2};
    w3 = model{3}; b3 = model{4};
    w4 = model{5}; b4 = model{6};

    out2 = elu_fast(w2 * x + b2);
    out3 = elu_fast(w3 * out2 + b3);
    out  = elu_fast(w4 * out3 + b4);  % size: [10 × n]

    [~, pred] = max(out, [], 1);  % returns indices 1-based
    pred = pred - 1;              % convert to 0-based labels

    % Compare directly
    loss = sum(pred(:) ~= y(:));
    Lz = loss / n;
end

function m = cnvxmodels(m1,m2,m3,m4,Cx)

m{1} = Cx(1).*m1{1} + Cx(2).*m2{1} +...
       Cx(3).*m3{1} + Cx(4).*m4{1};
m{2} = Cx(1).*m1{2} + Cx(2).*m2{2} +...
       Cx(3).*m3{2} + Cx(4).*m4{2};
m{3} = Cx(1).*m1{3} + Cx(2).*m2{3} +...
       Cx(3).*m3{3} + Cx(4).*m4{3};
m{4} = Cx(1).*m1{4} + Cx(2).*m2{4} +...
       Cx(3).*m3{4} + Cx(4).*m4{4};
m{5} = Cx(1).*m1{5} + Cx(2).*m2{5} +...
       Cx(3).*m3{5} + Cx(4).*m4{5};
m{6} = Cx(1).*m1{6} + Cx(2).*m2{6} +...
       Cx(3).*m3{6} + Cx(4).*m4{6};

end

% Settings
batch   = 1;   % Number of times Expected Lz is computed (batch)
n_sampl = 100;   % Number of Priors to be ploted
per     = 2/3;   % Percentage of training data set used for each iteration
perts   = 2/3;   % Percentage of test data set used for each iteration

% Select Data Set
DataSet = 'MNIST'; % Data set options 'MNIST' or 'Digits'

% Load Data
data_tr = load('mnist_train.csv');
data_ts = load('mnist_test.csv');
[Xtr,~]=formatdata(data_tr);
[Xts,~]=formatdata(data_ts);
Ytr = data_tr(:,1);
Yts = data_ts(:,1);

[n_samples,n_features] = size(Xtr);
[n_smap_ts,n_feat_ts]  = size(Xts);


% Load models
m1 = load('Models/model2.mat');
m2 = load('Models/model3.mat');
m3 = load('Models/model4.mat');
m4 = load('Models/model5.mat');

load('Models/convex_short_220.mat'); % load support of Q

% Convert Models To Cells
M1 = {m1.w12,m1.b12,m1.w23,m1.b23,m1.w34,m1.b34};
M2 = {m2.w12,m2.b12,m2.w23,m2.b23,m2.w34,m2.b34};
M3 = {m3.w12,m3.b12,m3.w23,m3.b23,m3.w34,m3.b34};
M4 = {m4.w12,m4.b12,m4.w23,m4.b23,m4.w34,m4.b34};

% Parameter from Models
k  = length(Cx);  % Number of Models
sz = [k,1];    % Size of Model Matrix


% f-divergences dP/dQ
ermT1 = @(Risk,lamb,dQx) exp(-Risk./lamb)./sum(sum(exp(-Risk./lamb).*dQx));
ermT2 = @(Risk,lamb,bet) lamb./(bet + Risk);
jserm = @(Risk,lamb,bet) 1./(2.*exp((bet+Risk)./lamb)-1);
heerm = @(Risk,lamb,bet) (lamb./(lamb+bet+Risk)).^2;

%% Generate Different Training Sets

% Create a seed
%---------------------------------
rng(1)

% Allocate Memory
%---------------------------------
GpT1_all   = cell(batch,1);
%GpT2_all   = cell(batch,1);
%GpT3_all   = cell(batch,1);
%GpT4_all   = cell(batch,1);

RzT1_all  = cell(batch,1);
%RzT2_all  = cell(batch,1);
%RzT3_all  = cell(batch,1);
%RzT4_all  = cell(batch,1);

NQzT1_all  = cell(batch,1);
%NQzT2_all  = cell(batch,1);
%NQzT3_all  = cell(batch,1);
%NQzT4_all  = cell(batch,1);

per_tr_all = cell(batch,1);
per_ts_all = cell(batch,1);


for j=1:1:batch
disp(['iteration number is = ',num2str(j)]);
% Create Training Data Sets
%----------------------------------
per_tr_all{j} = per;       % Store percentage of training
indx = randperm(n_samples,round(n_samples.*per)); % Generete index vector
ind  = false(1,n_samples); % Alocate memory of logic vector
ind(indx) = true(1);       % Generate index logic vector

% Create Test Data Sets
%----------------------------------
per_ts_all{j} = perts;       % Store percentage of test
indxts = randperm(n_smap_ts,round(n_smap_ts.*perts)); % Generete index vector
indts  = false(1,n_smap_ts); % Alocate memory of logic vector
indts(indxts) = true(1);     % Generate index logic vector


Z1x = Xtr(ind,:);
Z1y = Ytr(ind);

Z2x = Xts(indts,:);
Z2y = Yts(indts);

n_subsample = length(indx);


%% ---------------------------------
%      Computing The Risk
%---------------------------------
Lz1 = zeros(k,1);
Lz2 = zeros(k,1);
disp('computing Lz1 and Lz2 ');
tic
for i= 1:k
    if exist('Cell_m','var')
        m = Cell_m(i,:); % if the set M < 2GB for storage
    else
        m = cnvxmodels(M1,M2,M3,M4,Cx(i,:)); % if the set M > 2GB for storage
    end
    Lz1(i) = empiricalrisk(m,Z1x,Z1y);
    Lz2(i) = empiricalrisk(m,Z2x,Z2y);
end
toc

% Prior
% ---------------------------------
Qpdf = ones(sz).*(1/(sz(1)*sz(2)));
%Qcdf = pdf2cdf(Qpdf).*dx1.*dx2;
dQ   = Qpdf;

%%  MAIN LOOP

lamb = logspace(-3,2,n_sampl);

bt1z1 = zeros(n_sampl,1);
bt2z1 = zeros(n_sampl,1);
bt3z1 = zeros(n_sampl,1);
bt4z1 = zeros(n_sampl,1);

Rz1p1z1 = zeros(n_sampl,1);
Rz1p2z1 = zeros(n_sampl,1);
Rz1p3z1 = zeros(n_sampl,1);
Rz1p4z1 = zeros(n_sampl,1);

Rz2p1z1 = zeros(n_sampl,1);
Rz2p2z1 = zeros(n_sampl,1);
Rz2p3z1 = zeros(n_sampl,1);
Rz2p4z1 = zeros(n_sampl,1);



for i=1:n_sampl
    disp(['Computing ERM for lambda point ',num2str(i),'/',num2str(n_sampl)]);
    tic
% ---------------------------------
lambda = lamb(i);

% ---------------------------------
%      Compute ERM-RER Type-1
%---------------------------------
% Compute the Type-1 set Z1
%---------------------------------
bt1z1(i) = -lambda+lambda*log(sum(sum(exp(-Lz1./lambda).*dQ)));
P1_z1 = ermT1(Lz1,lambda,dQ);
%P1cdf_z1 = pdf2cdf(P1_z1.*Qpdf.*dx1.*dx2);


% ---------------------------------
%      Compute ERM-RER Type-2
%---------------------------------
% Compute the Type-2 set Z1
%---------------------------------
%bt2z1(i) = findbetaf(Lz1,dQ,lambda,ermT2,'Type2');
%P2_z1 = ermT2(Lz1,lambda,bt2z1(i));
%P2cdf_z1   = pdf2cdf(P2_z1.*Qpdf.*dx1.*dx2);


% ---------------------------------
%      Compute ERM-RER Jensen Shannon
%---------------------------------
% Compute the Jensen-Shannon set Z1
%---------------------------------
%bt3z1(i) = findbetaf(Lz1,dQ,lambda,jserm,'JSerm');
%P3_z1 = jserm(Lz1,lambda,bt3z1(i));

%---------------------------------
%      Compute ERM-RER Hellinger
%---------------------------------
% Compute the Hellinger set Z1
%---------------------------------
%bt4z1(i) = findbetaf(Lz1,dQ,lambda,heerm,'Hell');
%P4_z1 = heerm(Lz1,lambda,bt4z1(i));

% Pre Compute Expected ER
%---------------------------------
% This is done to improve speed of code
Lz1dQ = Lz1.*dQ;
Lz2dQ = Lz2.*dQ;


% Compute Expected empirical Risks
%---------------------------------

Rz1p1z1(i) = sum(sum(Lz1dQ.*P1_z1));
%Rz1p2z1(i) = sum(sum(Lz1dQ.*P2_z1));
%Rz1p3z1(i) = sum(sum(Lz1dQ.*P3_z1));
%Rz1p4z1(i) = sum(sum(Lz1dQ.*P4_z1));

Rz2p1z1(i) = sum(sum(Lz2dQ.*P1_z1));
%Rz2p2z1(i) = sum(sum(Lz2dQ.*P2_z1));
%Rz2p3z1(i) = sum(sum(Lz2dQ.*P3_z1));
%Rz2p4z1(i) = sum(sum(Lz2dQ.*P4_z1));

toc
end

%% Plots

% Plots Settings
%-----------------------
mk_size = 5;
fid = '_Lamb1';

% Training Error
zte    = {'0','1','2'};

% Training Error VS Generalization

RzT1  = [Rz1p1z1,Rz2p1z1];
%RzT2  = [Rz1p2z1,Rz2p2z1];
%RzT3  = [Rz1p3z1,Rz2p3z1];
%RzT4  = [Rz1p4z1,Rz2p4z1];

% Sensitivity
GpT1   = abs(Rz2p1z1 - Rz1p1z1);
%GpT2   = abs(Rz2p2z1 - Rz1p2z1);
%GpT3   = abs(Rz2p3z1 - Rz1p3z1);
%GpT4   = abs(Rz2p4z1 - Rz1p4z1);

%% Save Data From Run
GpT1_all{j} = GpT1;
%GpT2_all{j} = GpT2;
%GpT3_all{j} = GpT3;
%GpT4_all{j} = GpT4;

RzT1_all{j} = RzT1;
%RzT2_all{j} = RzT2;
%RzT3_all{j} = RzT3;
%RzT4_all{j} = RzT4;

NQzT1_all{j}  = bt1z1;
%NQzT2_all{j}  = bt2z1;
%NQzT3_all{j}  = bt3z1;
%NQzT4_all{j}  = bt4z1;
end

FileName=['Proj',datestr(now, '_yyyy-mmm-dd_HH-MM_'),DataSet];
save([PathData, FileName],"GpT1_all",...
                     "GpT2_all",...
                     "GpT3_all",...
                     "GpT4_all",...
                     "RzT1_all",...
                     "RzT2_all",...
                     "RzT3_all",...
                     "RzT4_all",...
                     "per_tr_all",...
                     "per_ts_all",...
                     "NQzT1_all",...
                     "NQzT2_all",...
                     "NQzT3_all",...
                     "NQzT4_all",...
                     "lamb");
save([PathData, FileName,'_all']);

