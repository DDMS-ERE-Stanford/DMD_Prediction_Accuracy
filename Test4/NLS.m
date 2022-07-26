function [X,X_dmd,soln_error,tau,g_error,bd] = NLS(M,eps,obs)
L = 30; n =512; % Domain length and # points
xi2 = linspace(-L/2,L/2,n+1); %domain discretization
xi = xi2(1:n); % periodic domain 
dx = xi(2)-xi(1);
k = (2*pi/L)*[0:n/2-1 -n/2:-1].'; % wavenumbers

%%Define time discretization
slices = 60;
t = linspace(0,3*pi,slices+1); dt = t(2)-t(1);

%%Create initial conditions
q = 2*sech(xi).';
qt = fft(q);
%%Combine signals
 
% %Solve with Runge-Kutta
[tsol,qtsol] = ode45 ('dmd_solition_rhs',t,qt,[],k);
 
% %bring back to time domain and store data
qsol = 0*qtsol;
for j = 1:length(t)
    qsol(j,:) = ifft (qtsol(j,:));
end

if obs == 1
    X = qsol;
else
    X = [qsol abs(qsol).^2.*qsol];
end

X = X';

%%DMD
X1 = X(:,1:M-1);
X2 = X(:,2:M);
[U,Sigma,V] = svd(X1,'econ');
 index = find(diag(Sigma)>= Sigma(1,1)*eps);
 k = max(index);
U_k = U(:,1:k); Sigma_k = Sigma(1:k,1:k); V_k = V(:,1:k);
Atilde = U_k'*X2*V_k/Sigma_k;
[W,D] = eig(Atilde);
Z_k = X2*V_k/Sigma_k*W;
Lambda_k = diag(D);
%%using DDMD_RRR
%[Z_k,Lambda_k,~,~,k] = DDMD_RRR(X(:,1:M),10^(-6));
% 
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

tau = zeros(1,length(t));
c = zeros(k,length(t));
% m = zeros(1,length(t));
% m = 0;
for iter = 2:length(t)
      c(:,iter) = Z_k\X(:,iter)-Lambda_k*(Z_k\X(:,iter-1));
      tau(iter) = norm(c(:,iter),2);
       tau(iter) = norm(X(:,iter)-Z_k*Lambda_k*(Z_k\X(:,iter-1)));
%       m(iter) = max(m(iter-1),norm(Z_k*Lambda_k^(iter-M-1)*c(:,iter)));
%     c = X(:,iter)-Z_k(:,:)*Lambda_k*(Z_k(:,:)\X(:,iter-1));
%     tau(iter)=norm(c(1:n),2);
end

soln_error = sqrt(sum((abs(X(1:n,:))-abs(X_dmd(1:n,:))).^2,1));

g_error = sqrt(sum((X-X_dmd).^2,1));

bd = 0*g_error;
for iter = 1:M
    bd(iter) = g_error(iter);
end
eps_m = max(tau(M+1:end));

m = 0;
for iter = M+1:length(t)
    m = max(m,norm(Z_k*Lambda_k^(iter-M-1)));
    a = Z_k*Lambda_k^(iter-M)*(Z_k\(X(:,M)-X_dmd(:,M)));
    bd(iter) =  norm(a,2)+(iter-M)*abs(m)*abs(eps_m);
end
