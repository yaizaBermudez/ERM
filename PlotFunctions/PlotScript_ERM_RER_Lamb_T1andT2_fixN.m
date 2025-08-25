%%  MAIN LOOP

clear;
%load('longRun_v5.mat');
load('PropLambda_v2.mat');
fid = ['_UniQ'];
SaveFigure = true;
%%
% n_sampl = 100;
% lamb = logspace(-3,2,n_sampl);
n = 100;
z = 2; %1,2,3 (1 is all, 2 is z1 and 3 is z2)
GpT1_all   = cell(1000,1);
GpT2_all   = cell(1000,1);
GpT3_all   = cell(1000,1);
GpT4_all   = cell(1000,1);

RzT1e_all = cell(1000,1);
RzT2e_all = cell(1000,1);
RzT3e_all = cell(1000,1);
RzT4e_all = cell(1000,1);

RzT1t_all = cell(1000,1);
RzT2t_all = cell(1000,1);
RzT3t_all = cell(1000,1);
RzT4t_all = cell(1000,1);

for i=1:n
Rz0p1z0 = Rz0T1_all{i}(:,1);
Rz3p1z0 = Rz0T1_all{i}(:,2);
Rz1p1z1 = Rz1T1_all{i}(:,1);
Rz3p1z1 = Rz1T1_all{i}(:,2);
Rz2p1z2 = Rz2T1_all{i}(:,1);
Rz3p1z2 = Rz2T1_all{i}(:,2);

Rz0p2z0 = Rz0T2_all{i}(:,1);
Rz3p2z0 = Rz0T2_all{i}(:,2);
Rz1p2z1 = Rz1T2_all{i}(:,1);
Rz3p2z1 = Rz1T2_all{i}(:,2);
Rz2p2z2 = Rz2T2_all{i}(:,1);
Rz3p2z2 = Rz2T2_all{i}(:,2);

Rz0p3z0 = Rz0T3_all{i}(:,1);
Rz3p3z0 = Rz0T3_all{i}(:,2);
Rz1p3z1 = Rz1T3_all{i}(:,1);
Rz3p3z1 = Rz1T3_all{i}(:,2);
Rz2p3z2 = Rz2T3_all{i}(:,1);
Rz3p3z2 = Rz2T3_all{i}(:,2);

Rz0p4z0 = Rz0T4_all{i}(:,1);
Rz3p4z0 = Rz0T4_all{i}(:,2);
Rz1p4z1 = Rz1T4_all{i}(:,1);
Rz3p4z1 = Rz1T4_all{i}(:,2);
Rz2p4z2 = Rz2T4_all{i}(:,1);
Rz3p4z2 = Rz2T4_all{i}(:,2);


% Sensitivity
GpT1   = [Rz3p1z0 - Rz0p1z0,...
          Rz3p1z1 - Rz1p1z1,...
          Rz3p1z2 - Rz2p1z2];

GpT2   = [Rz3p2z0 - Rz0p2z0,...
          Rz3p2z1 - Rz1p2z1,...
          Rz3p2z2 - Rz2p2z2];

GpT3   = [Rz3p3z0 - Rz0p3z0,...
          Rz3p3z1 - Rz1p3z1,...
          Rz3p3z2 - Rz2p3z2];

GpT4   = [Rz3p4z0 - Rz0p4z0,...
          Rz3p4z1 - Rz1p4z1,...
          Rz3p4z2 - Rz2p4z2];

GpT1_all{i} = GpT1;
GpT2_all{i} = GpT2;
GpT3_all{i} = GpT3;
GpT4_all{i} = GpT4;

RzT1e_all{i} = [Rz0p1z0, Rz1p1z1, Rz2p1z2];
RzT2e_all{i} = [Rz0p2z0, Rz1p2z1, Rz2p2z2];
RzT3e_all{i} = [Rz0p3z0, Rz1p3z1, Rz2p3z2];
RzT4e_all{i} = [Rz0p4z0, Rz1p4z1, Rz2p4z2];

RzT1t_all{i} = [Rz3p1z0, Rz3p1z1, Rz3p1z2];
RzT2t_all{i} = [Rz3p2z0, Rz3p2z1, Rz3p2z2];
RzT3t_all{i} = [Rz3p3z0, Rz3p3z1, Rz3p3z2];
RzT4t_all{i} = [Rz3p4z0, Rz3p4z1, Rz3p4z2];
end

GpT1 = cat(3,GpT1_all{1:n});
GpT2 = cat(3,GpT2_all{1:n});
GpT3 = cat(3,GpT3_all{1:n});
GpT4 = cat(3,GpT4_all{1:n});

GpT1_m  = mean(mean(GpT1(:,z,:),3),2);
GpT1_mx = max(max(GpT1(:,z,:),[],3),[],2);
GpT1_mn = min(min(GpT1(:,z,:),[],3),[],2);
GpT1_s  = std(cat(3,GpT1(:,z,:)),0,3);

GpT2_m  = mean(mean(GpT2(:,z,:),3),2);
GpT2_mx = max(max(GpT2(:,z,:),[],3),[],2);
GpT2_mn = min(min(GpT2(:,z,:),[],3),[],2);
GpT2_s  = std(cat(3,GpT2(:,z,:)),0,3);

GpT3_m  = mean(mean(GpT3(:,z,:),3),2);
GpT3_mx = max(max(GpT3(:,z,:),[],3),[],2);
GpT3_mn = min(min(GpT3(:,z,:),[],3),[],2);
GpT3_s  = std(cat(3,GpT3(:,z,:)),0,3);

GpT4_m  = mean(mean(GpT4(:,z,:),3),2);
GpT4_mx = max(max(GpT4(:,z,:),[],3),[],2);
GpT4_mn = min(min(GpT4(:,z,:),[],3),[],2);
GpT4_s  = std(cat(3,GpT4(:,z,:)),0,3);


%----------------------------------------------------------------
RzT1e = cat(3,RzT1e_all{1:n});
RzT2e = cat(3,RzT2e_all{1:n});
RzT3e = cat(3,RzT3e_all{1:n});
RzT4e = cat(3,RzT4e_all{1:n});

RzT1e_m  = mean(mean(RzT1e(:,z,:),3),2);
RzT1e_mx = max(max(RzT1e(:,z,:),[],3),[],2);
RzT1e_mn = min(min(RzT1e(:,z,:),[],3),[],2);
RzT1e_s  = std(cat(3,RzT1e(:,z,:)),0,3);

RzT2e_m  = mean(mean(RzT2e(:,z,:),3),2);
RzT2e_mx = max(max(RzT2e(:,z,:),[],3),[],2);
RzT2e_mn = min(min(RzT2e(:,z,:),[],3),[],2);
RzT2e_s  = std(cat(3,RzT2e(:,z,:)),0,3);

RzT3e_m  = mean(mean(RzT3e(:,z,:),3),2);
RzT3e_mx = max(max(RzT3e(:,z,:),[],3),[],2);
RzT3e_mn = min(min(RzT3e(:,z,:),[],3),[],2);
RzT3e_s  = std(cat(3,RzT3e(:,z,:)),0,3);

RzT4e_m  = mean(mean(RzT4e(:,z,:),3),2);
RzT4e_mx = max(max(RzT4e(:,z,:),[],3),[],2);
RzT4e_mn = min(min(RzT4e(:,z,:),[],3),[],2);
RzT4e_s  = std(cat(3,RzT4e(:,z,:)),0,3);

%----------------------------------------------------------------
RzT1t = cat(3,RzT1t_all{1:n});
RzT2t = cat(3,RzT2t_all{1:n});
RzT3t = cat(3,RzT3t_all{1:n});
RzT4t = cat(3,RzT4t_all{1:n});

RzT1t_m  = mean(mean(RzT1t(:,z,:),3),2);
RzT1t_mx = max(max(RzT1t(:,z,:),[],3),[],2);
RzT1t_mn = min(min(RzT1t(:,z,:),[],3),[],2);
RzT1t_s  = std(cat(3,RzT1t(:,z,:)),0,3);

RzT2t_m  = mean(mean(RzT2t(:,z,:),3),2);
RzT2t_mx = max(max(RzT2t(:,z,:),[],3),[],2);
RzT2t_mn = min(min(RzT2t(:,z,:),[],3),[],2);
RzT2t_s  = std(cat(3,RzT2t(:,z,:)),0,3);

RzT3t_m  = mean(mean(RzT3t(:,z,:),3),2);
RzT3t_mx = max(max(RzT3t(:,z,:),[],3),[],2);
RzT3t_mn = min(min(RzT3t(:,z,:),[],3),[],2);
RzT3t_s  = std(cat(3,RzT3t(:,z,:)),0,3);

RzT4t_m  = mean(mean(RzT4t(:,z,:),3),2);
RzT4t_mx = max(max(RzT4t(:,z,:),[],3),[],2);
RzT4t_mn = min(min(RzT4t(:,z,:),[],3),[],2);
RzT4t_s  = std(cat(3,RzT4t(:,z,:)),0,3);


%----------------------------------------------------------------
RzT1g = cat(3,RzT1g_all{1:n});
RzT2g = cat(3,RzT2g_all{1:n});
RzT3g = cat(3,RzT3g_all{1:n});
RzT4g = cat(3,RzT4g_all{1:n});

RzT1g_m  = mean(mean(RzT1g(:,z,:),3),2);
RzT1g_mx = max(max(RzT1g(:,z,:),[],3),[],2);
RzT1g_mn = min(min(RzT1g(:,z,:),[],3),[],2);
RzT1g_s  = std(cat(3,RzT1g(:,z,:)),0,3);

RzT2g_m  = mean(mean(RzT2g(:,z,:),3),2);
RzT2g_mx = max(max(RzT2g(:,z,:),[],3),[],2);
RzT2g_mn = min(min(RzT2g(:,z,:),[],3),[],2);
RzT2g_s  = std(cat(3,RzT2g(:,z,:)),0,3);

RzT3g_m  = mean(mean(RzT3g(:,z,:),3),2);
RzT3g_mx = max(max(RzT3g(:,z,:),[],3),[],2);
RzT3g_mn = min(min(RzT3g(:,z,:),[],3),[],2);
RzT3g_s  = std(cat(3,RzT3g(:,z,:)),0,3);

RzT4g_m  = mean(mean(RzT4g(:,z,:),3),2);
RzT4g_mx = max(max(RzT4g(:,z,:),[],3),[],2);
RzT4g_mn = min(min(RzT4g(:,z,:),[],3),[],2);
RzT4g_s  = std(cat(3,RzT4g(:,z,:)),0,3);



%% Plots-----------------------
d = 2;
h15 = figure;
[pos15] = plotERMSenT1vsT2(h15,lamb, ...
                           [GpT1_m,GpT2_m], ...
                           [GpT1_mn,GpT1_mx,GpT2_mn,GpT2_mx], ...
                           [GpT1_s,GpT2_s],{'1','2'});

%-----------------------
h16 = figure;
[pos16] = plotEmpRiskT1vsT2(h16,lamb, ...
                            [RzT1g_m,RzT2g_m], ...
                            [RzT1g_mn,RzT1g_mx,RzT2g_mn,RzT2g_mx], ...
                            [RzT1g_s,RzT2g_s],{'1','2'});

%-----------------------
h17 = figure;
[pos17] = plotEmpRiskT1vsT2(h17,lamb, ...
                            [RzT1e_m,RzT2e_m], ...
                            [RzT1e_mn,RzT1e_mx,RzT2e_mn,RzT2e_mx], ...
                            [RzT1e_s,RzT2e_s],{'1','1'});


if (SaveFigure ==true)
set(h15,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos15(3), pos15(4)])
print(h15,['NumPlot19RT1vsT2SensMean',fid],'-dpng','-r300')
    
set(h16,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos16(3), pos16(4)])
print(h16,['NumPlot19RT1vsT2GenGapMean',fid],'-dpng','-r300')

set(h17,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos16(3), pos16(4)])
print(h17,['NumPlot19RT1vsT2Training',fid],'-dpng','-r300')
else
end

function [pos] = plotERMSenT1vsT2(h,lamb,R,Mm,Std,z)
    col = {'r','b','m','g'};
    lin = {'-','--','-.',':'};
    n = length(R(1,:));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    h.Position = [pos(1) pos(2) pos(3)+1 pos(4)];
    ymin = min(R-Std,[],'all');
    ymax = (max(R,[],'all') - ymin)*5.3 + ymin;
    hold on;
    for i=1:n
    patch([lamb fliplr(lamb)], [(R(:,i)-Std(i))' fliplr((R(:,i)+Std(i))')], ...
           col{i}, ...
           'EdgeColor','white');
    alpha(0.2)
    end
    for i=1:n
        % semilogx(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        loglog(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        if i ==1
            hold on;
        end
    end
    ylim([ymin,ymax]);
    set(gca, 'XScale', 'log', 'YScale','log')
    legend({ '','',...
           ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)-',...
                   'R_{\mbox{\boldmath $z$}_',z{1},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
           ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right) -' ...
                   'R_{\mbox{\boldmath $z$}_',z{1},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
            },'Interpreter','latex','Location','northwest','FontSize',13);

    hold off;
    grid on;
    box on
    xlabel('Parameter ($\lambda$)','Interpreter','latex')
    % 
end


function [pos] = plotEmpRiskT1vsT2(h,lamb,R,Mm,Std,z)
    col = {'r','b','m','g'};
    lin = {'-','--','-.',':'};
    n = length(R(1,:));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    h.Position = [pos(1) pos(2) pos(3)+1 pos(4)];
    ymin = min(R-Std,[],'all');
    ymax = (max(R,[],'all') - ymin)*1.5 + ymin;
    hold on;
    for i=1:n
    patch([lamb fliplr(lamb)], [(R(:,i)-Std(i))' fliplr((R(:,i)+Std(i))')], ...
           col{i}, ...
           'EdgeColor','white');
    alpha(0.2)
    end
    set(gca, 'XScale', 'log', 'YScale','log')
    for i=1:n
        % semilogx(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        loglog(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        if i ==1
            hold on;
        end
    end
    ylim([ymin,ymax]);
    legend({ '','',...
            ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
            ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
            },'Interpreter','latex','Location','northwest','FontSize',13);
    hold off;
    grid on;
    box on
    xlabel('Parameter ($\lambda$)','Interpreter','latex')
    % 
end