function [pos] = plotNQz(h,alpha,NQz,Mm,Std,z,varargin)
     if nargin > 6
        if isa(varargin{1},'logical')
            Onstd = varargin{1};
        else
            Onstd = true;
        end
    else
        Onstd = true;
    end
    col = {'r','b','m','g'};
    lin = {'-','--','-.',':'};
    n = length(NQz(1,:));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    h.Position = [pos(1) pos(2) pos(3)+1 pos(4)];
    ymin = min(NQz,[],'all');
    ymax = max(NQz,[],'all');
    hold on;
    if (Onstd == true)
    for i=1:n
        patch([alpha fliplr(alpha)], [(NQz(:,i)-Std(i))' fliplr((NQz(:,i)+Std(i))')], ...
           col{i}, ...
           'EdgeColor','white');
        alpha(0.2)
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
    %set(gca, 'XScale', 'log', 'YScale','log')
    for i=1:n
        % semilogx(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        plot(alpha,NQz(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        ylim([ymin,ymax]);
        if i ==1
            hold on;
        end
    end
    lgd = legend(A,'Interpreter','latex','Location','Best','FontSize',12);
    title(lgd,['$N_{Q,\mbox{\boldmath $z$}}(\lambda)$']);
    % legend({ '','','','',...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
    %         },'Interpreter','latex','Location','northwest','FontSize',14);
    hold off;
    grid on;
    box on
    xlabel(['$Q(\{L_{\mbox{\boldmath $z$}}(\mbox{\boldmath $\theta$})<0.5\})$'],'Interpreter','latex')

end