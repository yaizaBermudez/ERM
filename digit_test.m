test = load('mnist_test.csv');
labels = test(:,1);
y = zeros(10,10000);
for i = 1:10000
    y(labels(i)+1,i) = 1;
end

images = test(:,2:785);
images = images/255;

images = images';

model = matfile('model5.mat');
w4 = model.w34;
w3 = model.w23;
w2 = model.w12;
b4 = model.b34;
b3 = model.b23;
b2 = model.b12;
success = 0;
n = 10000;

for i = 1:n
out2 = elu(w2*images(:,i)+b2);
out3 = elu(w3*out2+b3);
out = elu(w4*out3+b4);
big = 0;
num = 0;
for k = 1:10
    if out(k) > big
        num = k-1;
        big = out(k);
    end
end

if labels(i) == num
    success = success + 1;
end

end


fprintf('Accuracy: ');
fprintf('%f',success/n*100);
disp(' %');
