function [pos] = plotNQz(h,lamb,NQz,Mm,Std,z,varargin)
     if nargin > 6
        if isa(varargin{1},'logical')
            Onstd = varargin{1};
        else
            Onstd = true;
        end
     else
        Onstd = true;
     end
    col = {[ 33,  19,  89]./255,...
           [164, 142, 246]./255,...
           [100,  16, 244]./255,...
           [196, 187, 250]./255};
    %col = {'r','b','m','g'};
    lin = {'-','--','-.',':'};
    n = length(NQz(1,:));
    set(h, 'Units', 'Inches');
    pos = get(h, 'Position');
    pos(3) = pos(3) + 1;
    set(h, 'Position', pos);

    ymin = min(NQz(:));
    if nargin > 7
        ymax = varargin{2};
    else
        ymax = max(NQz(:));
    end

    hold on;
    if (Onstd == true)
    for i=1:n
        patch([lamb fliplr(lamb)], [(NQz(:,i)-Std(i))' fliplr((NQz(:,i)+Std(i))')], ...
           col{i}, ...
           'EdgeColor','white');
        %alpha(0.2)
    end
    A = { '','','','',...
                     'Type-I ERM-RER',...
                     'Type-II ERM-RER',...
                     'Shannon-Jensen',...
                     'Hellinger'};
    else
    A = {'Type-I ERM-RER',...
         'Type-II ERM-RER',...
         'Shannon-Jensen',...
         'Hellinger'};
    end
    set(gca, 'XScale', 'log')
    for i=1:n
        % semilogx(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        plot(lamb,NQz(:,i),'color',col{i},'LineStyle',lin{i},'LineWidth',3);
        ylim([ymin,ymax]);
        if i ==1
            hold on;
        end
    end
    lgd = legend(A,'Interpreter','latex','Location','northwest','FontSize',12);
    title(lgd,['$N_{Q,\mbox{\boldmath $z$}}(\lambda)$']);
    % legend({ '','','','',...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
    %         },'Interpreter','latex','Location','northwest','FontSize',14);
    hold off;
    %grid on;
    box on
    xlabel('Parameter ($\lambda$)','Interpreter','latex')

end
