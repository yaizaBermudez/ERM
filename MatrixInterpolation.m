% Load models
m1 = matfile('model2.mat');
m2 = matfile('model3.mat');
m3 = matfile('model4.mat');
m4 = matfile('model5.mat');

n = 4;
res = 10;
rows = res^n;
tolerance = 1e-10;
inter = linspace(0,1,res); % Number of Points between interpolation

[A, B, C, D] = ndgrid(inter, inter, inter, inter);
A = reshape(A, [], 1);
B = reshape(B, [], 1);
C = reshape(C, [], 1);
D = reshape(D, [], 1);

Cone = [A B C D];
Cx = Cone(abs(sum(Cone, 2)-1)<tolerance,:);

k = size(Cx,1);


%%
Cell_m = cell(k,6);


for i = 1:k
Cell_m{i,1} = Cx(i,1).*m1.w12 + Cx(i,2).*m2.w12 +...
              Cx(i,3).*m3.w12 + Cx(i,4).*m4.w12;
Cell_m{i,3} = Cx(i,1).*m1.w23 + Cx(i,2).*m2.w23 +...
              Cx(i,3).*m3.w23 + Cx(i,4).*m4.w23;
Cell_m{i,5} = Cx(i,1).*m1.w34 + Cx(i,2).*m2.w34 +...
              Cx(i,3).*m3.w34 + Cx(i,4).*m4.w34;
Cell_m{i,2} = Cx(i,1).*m1.b12 + Cx(i,2).*m2.b12 +...
              Cx(i,3).*m3.b12 + Cx(i,4).*m4.b12;
Cell_m{i,4} = Cx(i,1).*m1.b23 + Cx(i,2).*m2.b23 +...
              Cx(i,3).*m3.b23 + Cx(i,4).*m4.b23;
Cell_m{i,6} = Cx(i,1).*m1.b34 + Cx(i,2).*m2.b34 +...
              Cx(i,3).*m3.b34 + Cx(i,4).*m4.b34;
end