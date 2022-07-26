%accuracy_test
clear all;
%% Define time and space discretization
xi = linspace(0, 1,500);
dx = xi(2)-xi(1);
t = linspace (0, 0.2, 500);
dt = t(2)-t(1);
lambda=dt/dx^2;
[Xgrid, T] = meshgrid (xi,t);

%% Create DMD data matrices
M = 200;
X = zeros(length(xi),length(t)); X(1,1)= 0; X(end, 1) = 1;

A_n = diag((1+2*lambda)*ones(length(xi),1))-diag(lambda*ones(length(xi)-1,1),1)-diag(lambda*ones(length(xi)-1,1),-1);
A_n(1,1) = 1; A_n(1,2) = 0;
A_n(end,end-1) = 0; A_n(end, end) = 1;

for iter=2:length(t)
    X(:,iter) = A_n\X(:,iter-1);
end


[U,S,V] = svd(X(:,1:M),'econ');
r = 23;
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
b = Ur\X(:,1);
A_tilde = Ur'*A_n*Ur;
X_tilde = zeros(r,length(t));
X_tilde(:,1) = b;
for iter = 2:length(t)
    X_tilde(:,iter) = A_tilde\X_tilde(:,iter-1);
end
X_pod = Ur*X_tilde;
figure
mesh(t,xi,real(X_pod))
xlabel('t')
ylabel('x')
zlabel('u')
title('POD solution')
zlim([0,1])

figure
error = sqrt(sum((X-X_pod).^2,1));
set(gca, 'YScale', 'log')
hold on
plot(error,'LineWidth',2)
xlabel('n','LineWidth',2)
ylabel('global error e')
