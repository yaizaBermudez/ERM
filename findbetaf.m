% findbetaf  Example function
% This function is called with any of these syntaxes:
%
%   myFunc(in1, in2) accepts 2 required arguments.
%   myFunc(in1, in2, in3) also accepts an optional 3rd argument.
%   myFunc(___, NAME, VALUE) accepts one or more of the following name-value
%       arguments. This syntax can be used in any of the previous syntaxes.
%           * 'NAME1' with logical value
%           * 'NAME2' with 'Default', 'Choice1', or 'Choice2'
function beta = findbetaf(Lz,Integral,lambda,dP,Name)
% The following function finds the value of beta such that the integral for
% a given lambda is equal to one.
    supp= Integral==0; % Check the support
    minlz = min(min((Lz .* ~supp) + supp));

 %   minlz  = min((Lz.*~supp)+supp,[],'all');
    lgm    = 0;
    ibeta  = 0;
    minl   = 0;
    maxl   = 0;

    switch Name
        case 'Type1'
            disp('No need for findbeta')
        case 'Type2'
            if (minlz == 0)
                minlz=-10^-8;
            else
            end
            r  = (floor(log10(abs(minlz))));
            res    = r-2;
            mnbeta = -minlz;
            mxbeta = lambda;
        case 'JSerm'
            b  = -minlz + lambda*log(0.5);
            r  = (floor(log10(abs(b))));
            bv = b-10^(r-1):10^(r-6):b+10^(r-1);
            [~,id]=max(dP(minlz,lambda,bv));
            res    = r-4;
            mnbeta = bv(id);
            mxbeta = lambda;
        case 'Hell'
            r  = (floor(log10(abs(-minlz - lambda))));
            res    = r-4;
            mnbeta = -minlz - lambda;
            mxbeta = lambda;
    end

    if ~exist('n','var')
        n = 10;
    end
    val    = sum(sum(dP(Lz,lambda,mnbeta+10^res).*Integral));
    while (isnan(val) || (val <= 1)||(val==inf))
        mxbeta = mnbeta+10^res;
        val = sum(sum(dP(Lz,lambda,mnbeta+10^(res-1)).*Integral));
        if (val==inf)
            res = res+0.6;
        elseif (res <-1000)
            mnbeta=mnbeta./10;
        else
            res = res-1;
        end
        if (res == -inf)
            disp('WarningSomething is wrong')
            pause
        end
   end
   val    = sum(sum(dP(Lz,lambda,mxbeta).*Integral));
   while val > 1
            mxbeta=mxbeta+10^r;
            val = sum(sum(dP(Lz,lambda,mxbeta).*Integral));
            if mxbeta>1000
            disp('WarningSomething is wrong')
            pause
            end
   end

    iter = 1;
    while abs(1-ibeta)> 1e-5%for j=1:1:2
    iter = iter+1;
        lgm = linspace(mnbeta,mxbeta,n);
        tt = zeros(length(lgm),1);
        for i = 1:length(lgm)
          tt(i)  = sum(sum(dP(Lz,lambda,lgm(i)).*Integral));
        end
        [~,indx_beta] = min(abs(tt-1));
        if (indx_beta == 1 && tt(1)<1)|| (indx_beta ==n && tt(end)>1)
            disp('Warning: Error on findining beta')
            beta = nan;
            return
        else
            if (indx_beta == 1)
                indx_beta = 2;
            elseif (indx_beta == n)
                indx_beta = n-1;
            end
            mxbeta = lgm(indx_beta+1);
            mnbeta = lgm(indx_beta-1);
        end
        ibeta = tt(indx_beta);
    end

    beta = lgm(indx_beta);
%   check = min((dP(Lz, lambda, lgm(i)) .* ~supp)(:));
    check = min(min(dP(Lz, lambda, lgm(i)) .* ~supp));
%    check = min(dP(Lz,lambda,lgm(i)).*~supp,[],'all');
    if iter>1000000
        disp('Warning: Error on findining beta loop was forced out')
        pause;
    elseif check < 0
        disp('Warning: Error on findining dP is not a probability measure')
        pause;
    else
    end
    return
end

% myfit1 = fittype('-2^(a.*x+b)+c','coefficients',{'a','b','c'});
% [fit1,gof1] = fit(scantimes,data,myfit1,'StartPoint',[0.005,-2,0.4]);
% myfit2 = fittype('exp(-d.*x+f)+g','coefficients',{'d','f','g'});
% [fit2,gof2] = fit(scantimes,data,myfit2,'StartPoint',[0.04,1,0]);
function bout=choseAction(int1,int2,bin)
action = abs(int2-int1)/abs(1-int2);
if (action <= 0.05) && (action >= 0)
    bout = bin -0.0001;
else
    bout = bin -0.00001;
end

end
