function [X,X_dmd,tau,error,bd] = accuracy_test(M,eps)
%% Define time and space discretization
xi = linspace(0, 1,500);
dx = xi(2)-xi(1);
t = linspace (0, 0.2, 500);
dt = t(2)-t(1);
lambda=dt/dx^2;
[Xgrid, T] = meshgrid (xi,t);

%% Create DMD data matrices
X = zeros(length(xi),length(t)); X(1,1)= 0; X(end, 1) = 1;

A_n = diag((1+2*lambda)*ones(length(xi),1))-diag(lambda*ones(length(xi)-1,1),1)-diag(lambda*ones(length(xi)-1,1),-1);
A_n(1,1) = 1; A_n(1,2) = 0;
A_n(end,end-1) = 0; A_n(end, end) = 1;

for iter=2:length(t)
    X(:,iter) = A_n\X(:,iter-1);
end

[Z_k,Lambda_k,~,~,k] = DDMD_RRR(X(:,1:M),eps);
%%DMD
% X1 = X(:,1:M-1);
% X2 = X(:,2:M);
% [U,Sigma,V] = svd(X1,'econ');
% index = find(diag(Sigma)<=sum(diag(Sigma))*eps);
% k = min(index);
% U_k = U(:,1:k); Sigma_k = Sigma(1:k,1:k); V_k = V(:,1:k);
% Atilde = U_k'*X2*V_k/Sigma_k;
% [W,D] = eig(Atilde);
% Z_k =U_k*W;% X2*V_k/Sigma_k*W;
% Lambda_k = diag(D);


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


%% error
tau = zeros(1,length(t));
for iter = 2:length(t)
    tau(iter) = norm(Z_k\X(:,iter)-Lambda_k*(Z_k\X(:,iter-1)),2);
%     tau(iter) = norm(X(:,iter)-Z_k*Lambda_k*(Z_k\X(:,iter-1)),2);
end

error = sqrt(sum((X-X_dmd).^2,1));
bd = 0*error;
for iter = 1:M
    bd(iter) = error(iter);
end
eps_m = max(tau(M+1:end));
m =0;
for iter = M+1:length(t)
    m = max(m,norm(Z_k*Lambda_k^(iter-M-1)*pinv(Z_k),'fro'));
    bd(iter) =  norm(Z_k*Lambda_k^(iter-M)*(Z_k\(X(:,M)-X_dmd(:,M))),2)+(iter-M)*m*eps_m;
end







