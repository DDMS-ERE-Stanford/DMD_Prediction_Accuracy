function [u,X_dmd,soln_error,tau,g_error,bd] = SLP(M,eps,obs)
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

mu = 1;

for i = 1:M
    u(:,i+1) = A\(u(:,i)-dt*mu*(u(:,i)-u(:,i).^3));
%     u(1,i+1) = 0;
%     u(end,i+1) = 0;
end

for i =M+1:length(t)-1
    u(:,i+1) = A\(u(:,i)-dt*mu*(u(:,i)-u(:,i).^3));
%     u(1,i+1) = 0;
%     u(end,i+1) = 0;
end

if obs == 1
    X = u;
else
    X = [u;u.^3];
end

%%DMD
X1 = X(:,1:M-1);
X2 = X(:,2:M);
[U,Sigma,V] = svd(X1,'econ');
% % k=10;
% k = rank(Sigma);
% eps = 1e-8;
 index = find(diag(Sigma)>= Sigma(1,1)*eps);
 k = max(index);
U_k = U(:,1:k); Sigma_k = Sigma(1:k,1:k); V_k = V(:,1:k);
Atilde = U_k'*X2*V_k/Sigma_k;
[W,D] = eig(Atilde);
Z_k = X1*V_k/Sigma_k*W;
Lambda_k = diag(D);
% [Z_k,Lambda_k,~,~,k] = DDMD_RRR(X(:,1:M),eps);

%%DMD Spectra
omega = log(Lambda_k)/dt;
Lambda_k = diag(Lambda_k);

%% Compute DMD Solution
x1 = X(:,1);
b = Z_k\x1;
time_dynamics = zeros(k,length(t));
for iter = 1:length(t)
    time_dynamics(:,iter) = (b.*exp(omega*t(iter)));
end
X_dmd = Z_k*time_dynamics;

soln_error = sqrt(sum((real(X_dmd(1:length(x),:))-u).^2));

tau = zeros(1,length(t));
c = zeros(k,length(t));
% m = zeros(1,length(t));
% m = 0;
for iter = 2:length(t)
      c(:,iter) = Z_k\X(:,iter)-Lambda_k*(Z_k\X(:,iter-1));
      tau(iter) = norm(c(:,iter),2);
end

g_error = sqrt(sum((real(X_dmd)-X).^2));
bd = 0*g_error;
for iter = 1:M
    bd(iter) = g_error(iter);
end
eps_m = max(tau(M+1:end));

m = 0;
for iter = M+1:length(t)
    m = max(m,norm(Z_k*Lambda_k^(iter-M-1)*pinv(Z_k)));
    a = Z_k*Lambda_k^(iter-M)*(Z_k\(X(:,M)-X_dmd(:,M)));
    bd(iter) =  norm(a,2)+(iter-M)*m*eps_m;
end
