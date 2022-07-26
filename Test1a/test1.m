clear all;
%% Define time and space discretization
xi = linspace(-10, 10, 400);
t = linspace (0, 4*pi, 200);
dt = t(2)-t(1);
[Xgrid, T] = meshgrid (xi,t);

%% Create two spatiotemporal patterns
f1 = sech (Xgrid +3).*(1*exp((-0.05)*T));
f2 = (sech(Xgrid).*tanh(Xgrid)).*(2*exp(-0.1*T));

%% Cobine signals and make data matrix
f = f1+f2; f = f';
X = f(:,1:50); %Data matrix

[Z_k,Lambda_k,~,~,k] = DDMD_RRR(X,10^(-12));

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
for iter = 2:length(t)
    tau(iter) = norm(Z_k\f(:,iter)-Lambda_k*(Z_k\f(:,iter-1)),2);
end
figure
plot(tau)

error = sqrt(sum((f-X_dmd).^2,2));
figure
plot(error)

bd = 0*error;
for iter = 1:50
    bd(iter) = error(iter);
end
for iter = 51:length(t)
    bd(iter) = norm(Z_k*Lambda_k*(Z_k\(f(:,50)-X_dmd(:,50))),2)+(iter-50)*norm(Z_k*Lambda_k,'fro')*max(tau);
end
figure
plot(error);
hold on;
plot(bd,'-.');




