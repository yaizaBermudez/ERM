%%  MAIN LOOP

clear;
close all;
load('/Users/ybermude/Documents/Documents-MAC-07006074/Code/ERM_fDR_ANN/Simulation/Proj_2025-May-22_16-39_MNIST');
fid = ['_UniQ'];
SaveFigure = false;
PlotStd    = true;
%%
% n_sampl = 100;
n = nnz(~cellfun(@isempty, RzT1_all)); % count the number of non-empty cells

% GpT1_all   = cell(n,1);
% GpT2_all   = cell(n,1);
% GpT3_all   = cell(n,1);
% GpT4_all   = cell(n,1);
%
% RzT1e_all = cell(n,1);
% RzT2e_all = cell(n,1);
% RzT3e_all = cell(n,1);
% RzT4e_all = cell(n,1);
%
% RzT1t_all = cell(n,1);
% RzT2t_all = cell(n,1);
% RzT3t_all = cell(n,1);
% RzT4t_all = cell(n,1);
%
% for i=1:n
% Rz1p1z1 = RzT1_all{i}(:,1);
% Rz2p1z1 = RzT1_all{i}(:,2);
%
% Rz1p2z1 = RzT2_all{i}(:,1);
% Rz2p2z1 = RzT2_all{i}(:,2);
%
% Rz1p3z1 = RzT3_all{i}(:,1);
% Rz2p3z1 = RzT3_all{i}(:,2);
%
% Rz1p4z1 = RzT4_all{i}(:,1);
% Rz2p4z1 = RzT4_all{i}(:,2);
%
% % Sensitivity
% GpT1   = Rz2p1z1 - Rz1p1z1;
% GpT2   = Rz2p2z1 - Rz1p2z1;
% GpT3   = Rz2p3z1 - Rz1p3z1;
% GpT4   = Rz2p4z1 - Rz1p4z1;
%
% GpT1_all{i} = GpT1;
% GpT2_all{i} = GpT2;
% GpT3_all{i} = GpT3;
% GpT4_all{i} = GpT4;
%
% RzT1e_all{i} =Rz1p1z1;
% RzT2e_all{i} =Rz1p2z1;
% RzT3e_all{i} =Rz1p3z1;
% RzT4e_all{i} =Rz1p4z1;
%
% RzT1t_all{i} = Rz2p1z1;
% RzT2t_all{i} = Rz2p2z1;
% RzT3t_all{i} = Rz2p3z1;
% RzT4t_all{i} = Rz2p4z1;
%
% end

GpT1 = cat(2,GpT1_all{1:n});
GpT2 = cat(2,GpT2_all{1:n});
GpT3 = cat(2,GpT3_all{1:n});
GpT4 = cat(2,GpT4_all{1:n});

GpT1_m  = mean(GpT1,2);
GpT1_mx =  max(GpT1,[],2);
GpT1_mn =  min(GpT1,[],2);
GpT1_s  =  std(GpT1,0,2);

GpT2_m  = mean(GpT2,2);
GpT2_mx =  max(GpT2,[],2);
GpT2_mn =  min(GpT2,[],2);
GpT2_s  =  std(GpT2,0,2);

GpT3_m  = mean(GpT3,2);
GpT3_mx =  max(GpT3,[],2);
GpT3_mn =  min(GpT3,[],2);
GpT3_s  =  std(GpT3,0,2);

GpT4_m  = mean(GpT4,2);
GpT4_mx =  max(GpT4,[],2);
GpT4_mn =  min(GpT4,[],2);
GpT4_s  =  std(GpT4,0,2);


%----------------------------------------------------------------
RzT1 = cat(3,RzT1_all{1:n});
RzT1e = squeeze(RzT1(:,1,:));
RzT1t = squeeze(RzT1(:,2,:));

RzT2 = cat(3,RzT2_all{1:n});
RzT2e = squeeze(RzT2(:,1,:));
RzT2t = squeeze(RzT2(:,2,:));

RzT3 = cat(3,RzT3_all{1:n});
RzT3e = squeeze(RzT3(:,1,:));
RzT3t = squeeze(RzT3(:,2,:));

RzT4 = cat(3,RzT4_all{1:n});
RzT4e = squeeze(RzT4(:,1,:));
RzT4t = squeeze(RzT4(:,2,:));

%----------------------------------------------------------------
RzT1e_m  = mean(RzT1e,2);
RzT1e_mx =  max(RzT1e,[],2);
RzT1e_mn =  min(RzT1e,[],2);
RzT1e_s  =  std(RzT1e,0,2);

RzT2e_m  = mean(RzT2e,2);
RzT2e_mx =  max(RzT2e,[],2);
RzT2e_mn =  min(RzT2e,[],2);
RzT2e_s  =  std(RzT2e,0,2);

RzT3e_m  = mean(RzT3e,2);
RzT3e_mx =  max(RzT3e,[],2);
RzT3e_mn =  min(RzT3e,[],2);
RzT3e_s  =  std(RzT3e,0,2);

RzT4e_m  = mean(RzT4e,2);
RzT4e_mx =  max(RzT4e,[],2);
RzT4e_mn =  min(RzT4e,[],2);
RzT4e_s  =  std(RzT4e,0,2);

%----------------------------------------------------------------
RzT1t_m  = mean(RzT1t,2);
RzT1t_mx =  max(RzT1t,[],2);
RzT1t_mn =  min(RzT1t,[],2);
RzT1t_s  =  std(RzT1t,0,2);

RzT2t_m  = mean(RzT2t,2);
RzT2t_mx =  max(RzT2t,[],2);
RzT2t_mn =  min(RzT2t,[],2);
RzT2t_s  =  std(RzT2t,0,2);

RzT3t_m  = mean(RzT3t,2);
RzT3t_mx =  max(RzT3t,[],2);
RzT3t_mn =  min(RzT3t,[],2);
RzT3t_s  =  std(RzT3t,0,2);

RzT4t_m  = mean(RzT4t,2);
RzT4t_mx =  max(RzT4t,[],2);
RzT4t_mn =  min(RzT4t,[],2);
RzT4t_s  =  std(RzT4t,0,2);
%----------------------------------------------------------------

NQzT1 = cat(2,NQzT1_all{1:n}).*-1;
NQzT2 = cat(2,NQzT2_all{1:n});
NQzT3 = cat(2,NQzT3_all{1:n}).*-1;
NQzT4 = cat(2,NQzT4_all{1:n}).*-1;

NQzT1_m  = mean(NQzT1,2);
NQzT1_mx =  max(NQzT1,[],2);
NQzT1_mn =  min(NQzT1,[],2);
NQzT1_s  =  std(NQzT1,0,2);

NQzT2_m  = mean(NQzT2,2);
NQzT2_mx =  max(NQzT2,[],2);
NQzT2_mn =  min(NQzT2,[],2);
NQzT2_s  =  std(NQzT2,0,2);

NQzT3_m  = mean(NQzT3,2);
NQzT3_mx =  max(NQzT3,[],2);
NQzT3_mn =  min(NQzT3,[],2);
NQzT3_s  =  std(NQzT3,0,2);

NQzT4_m  = mean(NQzT4,2);
NQzT4_mx =  max(NQzT4,[],2);
NQzT4_mn =  min(NQzT4,[],2);
NQzT4_s  =  std(NQzT4,0,2);

function [pos] = plotERMSenT1vsT2(h,lamb,R,Mm,Std,z,varargin)
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
    n = length(R(1,:));
    set(h, 'Units', 'Inches');
    pos = get(h, 'Position');
    pos(3) = pos(3) + 1;
    set(h, 'Position', pos);
    %set(h,'Units','Inches');
    %pos = get(h,'Position');
    %h.Position = [pos(1) pos(2) pos(3)+1 pos(4)];
    %ymin = min(R-Std,[],'all');
    %ymax = (max(R,[],'all') - ymin)*2 + ymin;
    ymin = min(min(R - Std));
    ymax = (max(max(R)) - ymin) * 2 + ymin;
    hold on;
    for i=1:n
        if (Onstd == true)
            patch([lamb fliplr(lamb)], [(R(:,i)-Std(i))' fliplr((R(:,i)+Std(i))')], ...
                    col{i},'EdgeColor','white');
            %alpha(0.15)
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
    end

    for i=1:n
        % semilogx(lamb,R(:,i),col{i},'LineStyle',lin{i},'LineWidth',2);
        plot(lamb,R(:,i),'color',col{i},'LineStyle',lin{i},'LineWidth',3);
        if i ==1
            set(gca, 'XScale', 'log')
        end
    end
    ylim([ymin,ymax]);

    lgd = legend(A,'Interpreter','latex','Location','northwest','FontSize',12);
     title(lgd,['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)-',...
                  'R_{\mbox{\boldmath $z$}_',z{1},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']...
                   );
   % legend({ '','','','',...
   %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)-',...
   %                 'R_{\mbox{\boldmath $z$}_',z{1},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
   %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right) -' ...
   %                 'R_{\mbox{\boldmath $z$}_',z{1},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
   %          },'Interpreter','latex','Location','northwest','FontSize',14);

    hold off;
    %grid on;
    box on
    xlabel('Parameter ($\lambda$)','Interpreter','latex')
    %
end


function [pos] = plotEmpRiskT1vsT2(h,lamb,R,Mm,Std,z,varargin)
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
    n = length(R(1,:));
    set(h, 'Units', 'Inches');
    pos = get(h, 'Position');
    pos(3) = pos(3) + 1;
    set(h, 'Position', pos);
    ymin = min((R - Std)(:));
    ymax = (max(R(:)) - ymin) * 1.05 + ymin;

    hold on;
    if (Onstd == true)
    for i=1:n
        patch([lamb fliplr(lamb)], [(R(:,i)-Std(i))' fliplr((R(:,i)+Std(i))')], ...
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
        loglog(lamb,R(:,i),'color',col{i},'LineStyle',lin{i},'LineWidth',3);
        ylim([ymin,ymax]);
        if i ==1
            hold on;
        end
    end
    lgd = legend(A,'Interpreter','latex','Location','northwest','FontSize',12);
    title(lgd,['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']);
    % legend({ '','','','',...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(P^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$'],...
    %         ['$R_{\mbox{\boldmath $z$}_',z{2},'}\!\left(\bar{P}^{(Q,\lambda)}_{\mbox{\boldmath $\Theta$}|\mbox{\boldmath $Z$}=\mbox{\boldmath $z$}_',z{1},'}\right)$']
    %         },'Interpreter','latex','Location','northwest','FontSize',14);
    hold off;
    %grid on;
    box on
    xlabel('Parameter ($\lambda$)','Interpreter','latex')
    %
end
%% Plots-----------------------
d = 2;
h15 = figure;
[pos15] = plotERMSenT1vsT2(h15,lamb, ...
                           [GpT1_m,GpT2_m,GpT3_m,GpT4_m], ...
                           [GpT1_mn,GpT1_mx,GpT2_mn,GpT2_mx,GpT3_mn,GpT3_mx,GpT4_mn,GpT4_mx], ...
                           [GpT1_s,GpT2_s,GpT3_s,GpT4_s],{'1','2'},PlotStd);

%-----------------------
h16 = figure;
[pos16] = plotEmpRiskT1vsT2(h16,lamb, ...
                            [RzT1t_m,RzT2t_m,RzT3t_m,RzT4t_m], ...
                            [RzT1t_mn,RzT1t_mx,RzT2t_mn,RzT2t_mx,RzT3t_mn,RzT3t_mx,RzT4t_mn,RzT4t_mx], ...
                            [RzT1t_s,RzT2t_s,RzT3t_s,RzT4t_s],{'1','2'},PlotStd);

%-----------------------
h17 = figure;
[pos17] = plotEmpRiskT1vsT2(h17,lamb, ...
                            [RzT1e_m,RzT2e_m,RzT3e_m,RzT4e_m], ...
                            [RzT1e_mn,RzT1e_mx,RzT2e_mn,RzT2e_mx,RzT3e_mn,RzT3e_mx,RzT4e_mn,RzT4e_mx], ...
                            [RzT1e_s,RzT2e_s,RzT3e_s,RzT4e_s],{'1','1'},PlotStd);

%-----------------------
h18 = figure;
[pos18] = plotNQzlog(h18,lamb, ...
                            [NQzT1_m,NQzT2_m,NQzT3_m,NQzT4_m], ...
                            [NQzT1_mn,NQzT1_mx,NQzT2_mn,NQzT2_mx,NQzT3_mn,NQzT3_mx,NQzT4_mn,NQzT4_mx], ...
                            [NQzT1_s,NQzT2_s,NQzT3_s,NQzT4_s],{'1'},PlotStd,2);

if (SaveFigure ==true)
set(h15,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos15(3), pos15(4)])
print(h15,['RfSensMean',fid],'-dpng','-r300')

set(h16,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos16(3), pos16(4)])
print(h16,['RfGenGapMean',fid],'-dpng','-r300')

set(h17,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos17(3), pos17(4)])
print(h17,['RfTraining',fid],'-dpng','-r300')

set(h18,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos18(3), pos18(4)])
print(h18,['NormFunction',fid],'-dpng','-r300')

else
end


