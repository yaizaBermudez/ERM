function fr = elu_fast(x)
    f = zeros(size(x));
    f(x>=0)=x(x>=0);
    f(x<0) = 0.2.*(exp(x(x<0))-1);
    fr = f;
end