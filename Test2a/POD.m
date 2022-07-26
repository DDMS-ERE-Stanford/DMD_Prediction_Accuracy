function [u,X_pod,soln_error] = POD(M,eps)
dt = 0.004;
t = 0:dt:2;
dx = 0.01;
x = 0:dx:1; x = x';

u = zeros(length(x),length(t));
u(:,1) = 0.5+0.5*sin(pi*x);

lambda = dt/dx^2;
theta = 0.1;
A = diag((1+2*theta*lambda)*ones(length(x),1))-diag(theta*lambda*ones(length(x)-1,1),1)...
    -diag(theta*lambda*ones(length(x)-1,1),-1);
A(1,1) = 1; A(1,2) = 0;
A(end,end-1) = 0; A(end, end) = 1;

mu = 0.01;
tic
for i = 1:length(t)-1
    u(:,i+1) = A\(u(:,i)-dt*mu*(u(:,i)-u(:,i).^3));
end
toc
X = u;

tic
[U,S,V] = svd(X(:,1:M),'econ');
index = find(diag(S)>= S(1,1)*eps);
r = max(index);
% r = rank(S);
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
A_tilde = Ur'*A*Ur;
b = Ur\X(:,1);

f = -mu*(X(:,1:M)-X(:,1:M).^3);
[U_f,~,~] = svd(f,'econ');
U_f_r = U_f(:,1:r);
[~,S] = deim(U_f_r);
Phi_deim = U_f_r/(S'*U_f_r);

X_tilde = zeros(r,length(t));
X_tilde(:,1) = b;

for iter = 2:length(t)
    y_deim = S'*Ur*X_tilde(:,iter-1);
    f_tilde = -mu*(y_deim-y_deim.^3);
    X_tilde(:,iter) = A_tilde\(X_tilde(:,iter-1)+dt*(Ur'*Phi_deim*f_tilde));
end
X_pod = Ur*X_tilde;

soln_error = sqrt(sum((X-X_pod).^2,1));
toc

% mesh(x,t,X_pod')
% xlabel('x')
% ylabel('t')
% zlabel('u')
% title('POD solution')
% zlim([0.4,1])
% 
% figure
% error = sqrt(sum((X-X_pod).^2,1));
% set(gca, 'YScale', 'log')
% hold on
% plot(error,'LineWidth',2)
% xlabel('n','LineWidth',2)
% ylabel('global error e')
% title('\theta =0.1,\mu =0.01')
% 
% 
% norm(X(:,M+1:end)-X_pod(:,M+1:end))
