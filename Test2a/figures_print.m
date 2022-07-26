clear all;
dt = 0.004;
t = 0:dt:2;
dx = 0.01;
x = 0:dx:1; x = x';
M =200;

%% print resolved solution and DMD solution with m = 200
[u,X_dmd1,soln_error_dmd1,tau1,g_error1,bd1] = SLP(M,1e-8,1);
[u,X_dmd2,soln_error_dmd2,tau2,g_error2,bd2] = SLP(M,1e-10,2);
[u,X_pod,soln_error_pod] = POD(M,1e-11);
% 
% figure
% width = 2.5;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,x,u)
% 
% 
% title('resolved solution','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% caxis([0.5 1])
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% print('resolved_soln.eps','-depsc2','-r300');
% 
% 
% figure
% width = 2.5;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,x,real(X_dmd1(1:length(x),:)))
% 
% 
% title('DMD with $g_1(x) = x$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% caxis([0.5 1])
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% print('DMD_soln1.eps','-depsc','-r300');
% 
% figure
% width = 2.5;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,x,real(X_dmd2(1:length(x),:)))
% 
% 
% title('DMD with $g_2(x) = [x;x^3]$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% caxis([0.5 1])
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% print('DMD_soln2.eps','-depsc','-r300');
% 
% figure
% width = 2.5;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,x,real(X_pod(1:length(x),:)))
% 
% 
% title('POD solution','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% caxis([0.5 1])
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% print('POD_soln.eps','-depsc','-r300');
% %soln error comparison
% 

figure
width = 7;     % Width in inches
height = 8.5;    % Height in inches
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(4,1,1)
plot(M+1:length(t),tau1(M+1:end),'b-','LineWidth',1);
hold on;
plot(M+1:length(t),tau2(M+1:end),'k-.','LineWidth',1);
set(gca,'box','off')
xlim([200,500])

set(gca, 'YScale', 'log')
title('local truncation error, $M = 200$','FontUnits','points','interpreter','latex',...
    'FontSize',11)

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
ylabel({'$||\bf \tau||_2$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);

legend({'$\textbf{g}_1$', '$\textbf{g}_2$'},'interpreter','latex',...
    'FontSize',11,'Location','Bestoutside');
legend boxoff 

subplot(4,1,2)
plot(1:length(t),soln_error_pod,'b-','LineWidth',1);
hold on;
plot(1:length(t),soln_error_dmd1,'k-.','LineWidth',1);
plot(1:length(t),soln_error_dmd2,'r--','LineWidth',1);
set(gca,'box','off')
xlim([0,500])
set(gca, 'YScale', 'log')
title('solution error','FontUnits','points','interpreter','latex',...
    'FontSize',11)

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
ylabel({'error of $u$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);

legend({'POD', 'DMD with $\textbf{g}_1$', 'DMD with $\textbf{g}_2$'},'interpreter','latex',...
    'FontSize',11,'Location','Bestoutside');
legend boxoff 

subplot(4,1,3)
plot(M+1:length(t),g_error1(M+1:end),'b-','LineWidth',1);
hold on;
plot(M+1:length(t),bd1(M+1:end),'k-.','LineWidth',1);
set(gca,'box','off')
 xlim([200,500])

set(gca, 'YScale', 'log')

title('observable error, $\textbf{g}_1 = \textbf{u}$','FontUnits','points','interpreter','latex',...
    'FontSize',11)

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
ylabel({'$||\textbf{e}||_2$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);

legend({'error of $\textbf{g}_1$', 'bound estimate'},'interpreter','latex',...
    'FontSize',11,'Location','Bestoutside');
legend boxoff 

subplot(4,1,4)
plot(M+1:length(t),g_error2(M+1:end),'b-','LineWidth',1);
hold on;
plot(M+1:length(t),bd2(M+1:end),'k-.','LineWidth',1);

set(gca,'box','off')
 xlim([200,500])
set(gca, 'YScale', 'log')


title('observable error, $\textbf{g}_2 = [\textbf{u};\textbf{u}^3]$','FontUnits','points','interpreter','latex',...
    'FontSize',11)

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
ylabel({'$||\textbf{e}||_2$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
legend({'error of $\textbf{g}_2$', 'bound estimate'},'interpreter','latex',...
    'FontSize',11,'Location','Bestoutside');
legend boxoff 



print('figure2-7.eps','-depsc2','-r300');





% figure
% width = 5.5;     % Width in inches
% height = 1.5;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% plot(1:length(t),soln_error_pod,'LineWidth',2);
% hold on;
% plot(1:length(t),soln_error_dmd1,'-.','LineWidth',2);
% plot(1:length(t),soln_error_dmd2,'--','LineWidth',2);
% set(gca,'box','off')
% xlim([0,500])
% set(gca, 'YScale', 'log')
% title('solution error','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'error of $u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% legend({'POD', 'DMD with $g_1$', 'DMD with $g_2$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8,'Location','Bestoutside');
% legend boxoff 
% print('soln_error.eps','-depsc2','-r300');
% 
% 
% % figure
% % width = 5.5;     % Width in inches
% % height = 1.5;    % Height in inches
% % set(gcf,'InvertHardcopy','on');
% % set(gcf,'PaperUnits', 'inches');
% % papersize = get(gcf, 'PaperSize');
% % left = (papersize(1)- width)/2;
% % bottom = (papersize(2)- height)/2;
% % myfiguresize = [left, bottom, width, height];
% % set(gcf,'PaperPosition', myfiguresize);
% % 
% % plot(M+1:length(t),tau1(M+1:end),'LineWidth',2);
% % hold on;
% % plot(M+1:length(t),tau2(M+1:end),'-.','LineWidth',2);
% % set(gca,'box','off')
% % xlim([200,500])
% % 
% % set(gca, 'YScale', 'log')
% % title('local truncation error, $m = 200$','FontUnits','points','interpreter','latex',...
% %     'FontSize',8)
% % 
% % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
% %     'FontSize',8);
% % ylabel({'$||\bf \tau||_2$'},'FontUnits','points','interpreter','latex',...
% %     'FontSize',8);
% % 
% % legend({'$g_1$', '$g_2$'},'FontUnits','points','interpreter','latex',...
% %     'FontSize',8,'Location','Bestoutside');
% % legend boxoff 
% % print('local.eps','-depsc2','-r300');
% 
% figure
% width = 5.5;     % Width in inches
% height = 1.5;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% plot(M+1:length(t),g_error1(M+1:end),'LineWidth',2);
% hold on;
% plot(M+1:length(t),bd1(M+1:end),'-.','LineWidth',2);
% set(gca,'box','off')
%  xlim([200,500])
% 
% set(gca, 'YScale', 'log')
% 
% title('observable error, $g_1 = x$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$||\bf e||_2$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% 
% legend({'error of $g_1$', 'bound estimate'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8,'Location','Bestoutside');
% legend boxoff 
% print('g1_error_revision.eps','-depsc2','-r300');
% 
% 
% 
% figure
% width = 5.5;     % Width in inches
% height = 1.5;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% plot(M+1:length(t),g_error2(M+1:end),'LineWidth',2);
% hold on;
% plot(M+1:length(t),bd2(M+1:end),'-.','LineWidth',2);
% 
% set(gca,'box','off')
%  xlim([200,500])
% set(gca, 'YScale', 'log')
% 
% 
% title('observable error, $g_2 = [x;x^3]$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% ylabel({'$||\bf e||_2$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8);
% legend({'error of $g_2$', 'bound estimate'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8,'Location','Bestoutside');
% legend boxoff 
% 
% print('g2_error_revision.eps','-depsc2','-r300');