% %accuracy_test
% clear all;
% %% Define time and space discretization
% dx = 0.002;
% dt = 2e-6;
% xi = 0:dx:1; xi = xi';
% t = 0:dt:0.5;
% 
% %% Create DMD data matrices
% u = zeros(length(xi),length(t)); 
% u(:,1) = 0.5+0.5*sin(pi*xi);
% 
% mu = 1;
% 
% for iter=2:length(t)
%     u(:,iter) = u(:,iter-1)+dt/dx^2*(0.5*(u(:,iter-1)+circshift(u(:,iter-1),-1))...
%         .*(circshift(u(:,iter-1),-1)-u(:,iter-1))-...
%         0.5*(u(:,iter-1)+circshift(u(:,iter-1),1))...
%         .*(u(:,iter-1)-circshift(u(:,iter-1),1)))-dt*mu*(u(:,iter-1)-u(:,iter-1).^3);
% end
% 
% X = u;
% M = 500;
% 
% [U,S,V] = svd(X(:,1:M),'econ');
% r = 23;
% Ur = U(:,1:r);
% Sr = S(1:r,1:r);
% Vr = V(:,1:r);
% b = Ur\X(:,M);
% 
% X_tilde = zeros(r,length(t));
% X_tilde(:,1) = b;
% for iter = 2:length(t)
%     y = Ur*X_tilde(:,iter-1);
%     rhs = dt/dx^2*(0.5*(y+circshift(y,-1))...
%         .*(circshift(y,-1)-y)-...
%         0.5*(y+circshift(y,1))...
%         .*(y-circshift(y,1)))-dt*mu*(y-y.^3);
%     X_tilde(:,iter) = X_tilde(:,iter-1)+Ur'*rhs;
% end
% 
% X_pod = Ur*X_tilde;
%  
% mesh(X_pod(:,1:500:end))
% 
% figure
% error = sqrt(sum((X-X_pod).^2,1));
% set(gca, 'YScale', 'log')
% hold on
% plot(error,'LineWidth',2)
% xlabel('n','LineWidth',2)
% ylabel('global error e')


clear all;
%% Define time and space discretization
dx = 0.002;
dt = 1e-3;
xi = 0:dx:1; xi = xi';
tspan = 0:dt:0.5;

%% Create DMD data matrices
M = 200;
load data3.mat;

[U,S,V] = svd(X(:,1:M),'econ');
index = find(diag(S)>= S(1,1)*10^(-6));
r = max(index);
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
b = Ur\X(:,1);

U_x = 0*Ur;
U_xx = 0*Ur;
U_x(2:end-1,:) = (Ur(3:end,:)-Ur(1:end-2,:))/dx/2;
U_xx(2:end-1,:) = (Ur(3:end,:)-2*Ur(2:end-1,:)+Ur(1:end-2,:))/dx^2;

[t,a] = ode45 (@(t,a) myode(t,a,U_x,U_xx,Ur),tspan,b);

u_pod = Ur*a';
mesh(tspan,xi,u_pod)

function dadt = myode(t,a,U_x,U_xx,Ur)
dadt = Ur'*((U_x*a).^2+(Ur*a).*(U_xx*a))+Ur'*((Ur*a).^3-Ur*a);
end







