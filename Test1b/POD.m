%accuracy_test
clear all;
load data.mat;
load data_long.mat;

dt = 2.5e-3;
t =  0:dt:pi/2;
y = 0:1/500:1;
dy = 1/500;
bd = 1.01+0.01*sin(-pi/2+t*10);
tic
M = 200;
X = h;

lambda = dt/dy^2;
A = diag((1+2*lambda)*ones(length(y),1))-diag(lambda*ones(length(y)-1,1),1)-diag(lambda*ones(length(y)-1,1),-1);
A(1,1) = 1; A(1,2) = 0;
A(end,end-1) = 0; A(end, end) = 1;

[U,S,V] = svd(X(:,1:M),'econ');
r = 11;
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
b = Ur\X(:,1);
A_tilde = Ur'*A*Ur;
X_tilde = zeros(r,length(t));
X_tilde(:,1) = b;
for iter = 2:length(t)
    X_tilde(:,iter) = A_tilde\[bd(iter-1);X_tilde(:,iter-1);1];
end
X_pod = Ur*X_tilde;
toc

figure
mesh(t,y,X_pod)
xlabel('t')
ylabel('x')
zlabel('u')
title('POD solution')

figure
error = sqrt(sum((h-X_pod).^2,1));
set(gca, 'YScale', 'log')
hold on
plot(error,'LineWidth',2)
xlabel('n','LineWidth',2)
ylabel('global error e')
