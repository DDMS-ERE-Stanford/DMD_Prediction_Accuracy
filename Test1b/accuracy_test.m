function [X,X_dmd,tau,error,bd] = accuracy_test(M,eps)

%accuracy_test
load data.mat;
load data_long.mat;

dt = 2.5e-3;
t =  0:dt:0.5*pi;
y = 0:1/500:1;
dy = 1/500;
%b = 1.01+0.01*sin(-pi/2+t*10);

X = h;

[Z_k,Lambda_k,~,~,k] = DDMD_RRR(X(:,1:M),eps);
% %%DMD
% X1 = X(:,1:M-1);
% X2 = X(:,2:M);
% [U,Sigma,V] = svd(X1,'econ');
% eps = 1e-8;
% index = find(diag(Sigma)<=sum(diag(Sigma))*eps);
% k = min(index);
% U_k = U(:,1:k); Sigma_k = Sigma(1:k,1:k); V_k = V(:,1:k);
% Atilde = U_k'*X2*V_k/Sigma_k;
% [W,D] = eig(Atilde);
% Z_k = U_k*W;% X2*V_k/Sigma_k*W;
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
X_dmd = real(X_dmd);

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
    m = max(m,norm(Z_k*Lambda_k^(iter-M-1))*norm(Z_k));
    bd(iter) =  norm(Z_k*Lambda_k^(iter-M)*(Z_k\(X(:,M)-X_dmd(:,M))),2)+(iter-M)*m*eps_m;
end