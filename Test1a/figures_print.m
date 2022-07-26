clear all;
xi = linspace(0, 1,500);
dx = xi(2)-xi(1);
t = linspace (0, 0.2, 500);
dt = t(2)-t(1);

%% print resolved solution and DMD solution with m = 200
%[X,X_dmd,~,~,~] = accuracy_test(200,1e-8);
% figure
% width = 3;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,xi,X)
% colormap jet;
% axis([0 0.2 0 1])
% title('resolved solution','FontUnits','points','interpreter','latex',...
%     'FontSize',9)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% caxis([0 1])
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% print('resolved_soln.eps','-depsc2','-r300');
% 
% 
% figure
% width = 3;     % Width in inches
% height = 2;    % Height in inches
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 'inches');
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);
% 
% imagesc(t,xi,real(X_dmd))
% colormap jet;
% 
% title('DMD solution','FontUnits','points','interpreter','latex',...
%     'FontSize',9)
% hcb = colorbar
% title(hcb,{'$u$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% caxis([0 1])
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel({'$t$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% ylabel({'$x$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% print('DMD_soln.eps','-depsc','-r300');

% 
% 
% print local truncation error
m1 = 100; m2 = 200; m3 = 300;
[~,~,tau1,error1,bd1] = accuracy_test(m1,1e-12);
[~,~,tau2,error2,bd2] = accuracy_test(m2,1e-12);
[~,~,tau3,error3,bd3] = accuracy_test(m3,1e-12);

figure
width = 7;     % Width in inches
height = 7.5;    % Height in inches
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

subplot(3,1,1)
set(gca, 'YScale', 'log')
hold on;
plot(m1+1:length(tau1),tau1(m1+1:end),'b-','LineWidth',1)
plot(m2+1:length(tau2),tau2(m2+1:end),'k-.','LineWidth',1)
plot(m3+1:length(tau3),tau3(m3+1:end),'r--','LineWidth',1)
title('local truncation error with rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
     'FontSize',11)

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
ylabel({'$||\bf \tau||_2$'},'FontUnits','points','interpreter','latex',...
    'FontSize',11);
legend({'$M = 100$', '$M = 200$', '$M = 300$'},'interpreter','latex',...
    'FontSize',11,'Location','Bestoutside');
legend boxoff 

subplot(3,1,2)
set(gca, 'YScale', 'log')
hold on;
plot(m1:length(t),error1(m1:end),'b-','LineWidth',1);
plot(m1:length(t),bd1(m1:end),'k-.','LineWidth',1);
plot(m1,error1(m1),'r*')

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel('$n$','FontUnits','points','interpreter','latex',...
    'FontSize',11)
ylabel('$||\textbf{e}||_{2}$','FontUnits','points','interpreter','latex',...
    'FontSize',11)
title('snapshot $M = 100$, rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
     'FontSize',11)
legend({'global error','bound estimate'},'interpreter','latex',...
    'FontSize',11,'Location','bestoutside');
legend boxoff

subplot(3,1,3)
set(gca, 'YScale', 'log')
hold on;
plot(m2:length(t),error2(m2:end),'b-','LineWidth',1);
plot(m2:length(t),bd2(m2:end),'k-.','LineWidth',1);
plot(m2,error2(m2),'r*')

set(gca,'FontUnits','points','FontWeight','normal','FontSize',10)
xlabel('$n$','FontUnits','points','interpreter','latex',...
    'FontSize',11)
ylabel('$||\textbf{e}||_{2}$','FontUnits','points','interpreter','latex',...
    'FontSize',11)
title('snapshot $M = 200$, rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
     'FontSize',11)
legend({'global error','bound estimate'},'interpreter','latex',...
    'FontSize',11,'Location','bestoutside');
legend boxoff
print('figure2-3.eps','-depsc2','-r300');





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
% set(gca, 'YScale', 'log')
% hold on;
% plot(m1+1:length(tau1),tau1(m1+1:end),'LineWidth',2)
% plot(m2+1:length(tau2),tau2(m2+1:end),'-.','LineWidth',2)
% plot(m3+1:length(tau3),tau3(m3+1:end),'--','LineWidth',2)
% title('local truncation error with rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
%      'FontSize',9)
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',9)
% xlabel({'$n$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% ylabel({'$||\bf \tau||_2$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9);
% legend({'$M = 100$', '$M = 200$', '$M = 300$'},'FontUnits','points','interpreter','latex',...
%     'FontSize',9,'Location','Bestoutside');
% legend boxoff 
% 
% print('local_2.eps','-depsc2','-r300');


% % 
% % 
% %% print global truncation error
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
% set(gca, 'YScale', 'log')
% hold on;
% plot(m1:length(t),error1(m1:end),'LineWidth',2);
% plot(m1:length(t),bd1(m1:end),'-.','LineWidth',2);
% plot(m1,error1(m1),'r*')
% 
% set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% xlabel('$n$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% ylabel('$||\textbf{e}||_{2}$','FontUnits','points','interpreter','latex',...
%     'FontSize',8)
% title('snapshot $m = 100$, rank threshold $\varepsilon = 10^{-8}$','FontUnits','points','interpreter','latex',...
%      'FontSize',8)
% legend({'global error','bound estimate'},'FontUnits','points','interpreter','latex',...
%     'FontSize',8,'Location','bestoutside');
% legend boxoff
% print('m100_2_revision.eps','-depsc2','-r300');
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
% % set(gca, 'YScale', 'log')
% % hold on;
% % plot(m2:length(t),error2(m2:end),'LineWidth',2);
% % plot(m2:length(t),bd2(m2:end),'-.','LineWidth',2);
% % plot(m2,error2(m2),'r*')
% % 
% % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % xlabel('$n$','FontUnits','points','interpreter','latex',...
% %     'FontSize',8)
% % ylabel('$||\bf e||_{2}$','FontUnits','points','interpreter','latex',...
% %     'FontSize',8)
% % title('snapshot $m = 200$, rank threshold $\varepsilon = 10^{-8}$','FontUnits','points','interpreter','latex',...
% %      'FontSize',8)
% % legend({'global error','bound estimate'},'FontUnits','points','interpreter','latex',...
% %     'FontSize',8,'Location','bestoutside');
% % legend boxoff
% % print('m200_1_revision.eps','-depsc2','-r300');
% % % 
% % % figure
% % % width = 5.5;     % Width in inches
% % % height = 1.5;    % Height in inches
% % % set(gcf,'InvertHardcopy','on');
% % % set(gcf,'PaperUnits', 'inches');
% % % papersize = get(gcf, 'PaperSize');
% % % left = (papersize(1)- width)/2;
% % % bottom = (papersize(2)- height)/2;
% % % myfiguresize = [left, bottom, width, height];
% % % set(gcf,'PaperPosition', myfiguresize);
% % % set(gca, 'YScale', 'log')
% % % hold on;
% % % plot(m3:length(t),error3(m3:end),'LineWidth',2);
% % % plot(m3:length(t),bd3(m3:end),'-.','LineWidth',2);
% % % plot(m3,error3(m3),'r*')
% % % 
% % % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % % xlabel('n','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % ylabel('e','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % title('snapshot $m = 300$, rank threshold $\varepsilon = 10^{-8}$','FontUnits','points','interpreter','latex',...
% % %      'FontSize',8)
% % % legend({'global error','bound estimate'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8,'Location','bestoutside');
% % % legend boxoff
% % % print('m300_1.eps','-depsc2','-r300');
% % % 
% % % 
% % % 
% % % %% smaller eps
% % % %% print global truncation error
% % % m1 = 100; m2 = 200; m3 = 300;
% % % [~,~,tau1,error1,bd1] = accuracy_test(m1,1e-12);
% % % [~,~,tau2,error2,bd2] = accuracy_test(m2,1e-12);
% % % [~,~,tau3,error3,bd3] = accuracy_test(m3,1e-12);
% % % 
% % % 
% % % figure
% % % width = 5.5;     % Width in inches
% % % height = 1.5;    % Height in inches
% % % set(gcf,'InvertHardcopy','on');
% % % set(gcf,'PaperUnits', 'inches');
% % % papersize = get(gcf, 'PaperSize');
% % % left = (papersize(1)- width)/2;
% % % bottom = (papersize(2)- height)/2;
% % % myfiguresize = [left, bottom, width, height];
% % % set(gcf,'PaperPosition', myfiguresize);
% % % 
% % % set(gca, 'YScale', 'log')
% % % hold on;
% % % plot(m1+1:length(tau1),tau1(m1+1:end),'LineWidth',2)
% % % plot(m2+1:length(tau2),tau2(m2+1:end),'-.','LineWidth',2)
% % % plot(m3+1:length(tau3),tau3(m3+1:end),'--','LineWidth',2)
% % % title('local truncation error with rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
% % %      'FontSize',8)
% % % 
% % % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % % xlabel({'n'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8);
% % % ylabel({'$\tau$'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8);
% % % legend({'m = 100', 'm = 200', 'm = 300'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8,'Location','Bestoutside');
% % % legend boxoff 
% % % 
% % % print('local_2.eps','-depsc2','-r300');
% % % 
% % % %% print global truncation error
% % % figure
% % % width = 5.5;     % Width in inches
% % % height = 1.5;    % Height in inches
% % % set(gcf,'InvertHardcopy','on');
% % % set(gcf,'PaperUnits', 'inches');
% % % papersize = get(gcf, 'PaperSize');
% % % left = (papersize(1)- width)/2;
% % % bottom = (papersize(2)- height)/2;
% % % myfiguresize = [left, bottom, width, height];
% % % set(gcf,'PaperPosition', myfiguresize);
% % % set(gca, 'YScale', 'log')
% % % hold on;
% % % plot(m1:length(t),error1(m1:end),'LineWidth',2);
% % % plot(m1:length(t),bd1(m1:end),'-.','LineWidth',2);
% % % plot(m1,error1(m1),'r*')
% % % 
% % % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % % xlabel('n','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % ylabel('e','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % title('snapshot $m = 100$, rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
% % %      'FontSize',8)
% % % legend({'global error','bound estimate'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8,'Location','bestoutside');
% % % legend boxoff
% % % print('m100_2.eps','-depsc2','-r300');
% % % 
% % % figure
% % % width = 5.5;     % Width in inches
% % % height = 1.5;    % Height in inches
% % % set(gcf,'InvertHardcopy','on');
% % % set(gcf,'PaperUnits', 'inches');
% % % papersize = get(gcf, 'PaperSize');
% % % left = (papersize(1)- width)/2;
% % % bottom = (papersize(2)- height)/2;
% % % myfiguresize = [left, bottom, width, height];
% % % set(gcf,'PaperPosition', myfiguresize);
% % % set(gca, 'YScale', 'log')
% % % hold on;
% % % plot(m2:length(t),error2(m2:end),'LineWidth',2);
% % % plot(m2:length(t),bd2(m2:end),'-.','LineWidth',2);
% % % plot(m2,error2(m2),'r*')
% % % 
% % % set(gca,'FontUnits','points','FontWeight','normal','FontSize',8)
% % % xlabel('n','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % ylabel('e','FontUnits','points','interpreter','latex',...
% % %     'FontSize',8)
% % % title('snapshot $m = 200$, rank threshold $\varepsilon = 10^{-12}$','FontUnits','points','interpreter','latex',...
% % %      'FontSize',8)
% % % legend({'global error','bound estimate'},'FontUnits','points','interpreter','latex',...
% % %     'FontSize',8,'Location','bestoutside');
% % % legend boxoff
% % % print('m200_2.eps','-depsc2','-r300');