function [X_pod,soln_error] = POD2(M,eps)
%% Define time and space discretization
dx = 0.002;
dt = 2e-6;
xi = 0:dx:1; xi = xi';
t = 0:dt:0.5;

load data3.mat;
mu =1;

[U,S,V] = svd(X(:,1:M),'econ');
 index = find(diag(S)>= S(1,1)*eps);
 r = max(index);
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
b = Ur\X(:,1);

X_tilde = zeros(r,length(t));
X_tilde(:,1) = b;

for iter = 2:length(t)
    y = Ur*X_tilde(:,iter-1);
    rhs = dt/dx^2*(0.5*(y+circshift(y,-1))...
        .*(circshift(y,-1)-y)-...
        0.5*(y+circshift(y,1))...
        .*(y-circshift(y,1)))-dt*mu*(y-y.^3);
    X_tilde(:,iter) = X_tilde(:,iter-1)+Ur'*rhs;
end

X_pod = Ur*X_tilde;

X_pod = X_pod(:,1:500:end);

soln_error = sqrt(sum((X(1:length(xi),:)-X_pod(1:length(xi),:)).^2,1));














% 
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
%  figure
% mesh(X_pod(:,1:500:end))
% 
% figure
% error = sqrt(sum((X-X_pod).^2,1));
% set(gca, 'YScale', 'log')
% hold on
% plot(error,'LineWidth',2)
% xlabel('n','LineWidth',2)
% ylabel('global error e')
