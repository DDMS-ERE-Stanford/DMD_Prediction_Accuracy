function [X,X_dmd,soln_error,tau,g_error,bd] = accuracy_test(M,eps,obs)
%% Define time and space discretization
dx = 0.002;
dt = 1e-3;
xi = 0:dx:1; xi = xi';
t = 0:dt:0.5;

%% Create DMD data matrices
load data3.mat;

if obs == 1
    X = X;
else
    X = [X;0.5*X.^2;X.^3];
end

X1 = X(:,1:M-1);
X2 = X(:,2:M);
[U,Sigma,V] = svd(X1,'econ');
% k = rank(Sigma);
 index = find(diag(Sigma)>= Sigma(1,1)*eps);
 k = max(index);
U_k = U(:,1:k); Sigma_k = Sigma(1:k,1:k); V_k = V(:,1:k);
Atilde = U_k'*X2*V_k/Sigma_k;
[W,D] = eig(Atilde);
Z_k = X2*V_k/Sigma_k*W;
Lambda_k = diag(D);
%  [Z_k,Lambda_k,~,~,k] = DDMD_RRR(X(:,1:M),eps);


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

soln_error = sqrt(sum((X(1:length(xi),:)-X_dmd(1:length(xi),:)).^2,1));

tau = zeros(1,length(t));
for iter = 2:length(t)
%      tau(iter) = norm(Z_k\X(:,iter)-Lambda_k*(Z_k\X(:,iter-1)),2);
    tau(iter) = norm(X(:,iter)-Z_k*Lambda_k*(Z_k\X(:,iter-1)),2);
end

g_error = sqrt(sum((X-X_dmd).^2,1));

bd = 0*g_error;
for iter = 1:M
    bd(iter) = g_error(iter);
end
eps_m = max(tau(M+1:end));
m =0;
for iter = M+1:length(t)
    m = max(m,norm(Z_k*Lambda_k^(iter-M-1)));
    bd(iter) =  norm(Z_k*Lambda_k^(iter-M)*(Z_k\(X(:,M)-X_dmd(:,M))),2)+(iter-M)*m*eps_m;
end


