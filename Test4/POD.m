% clear all
% L = 30; n =512; % Domain length and # points
% xi2 = linspace(-L/2,L/2,n+1); %domain discretization
% xi = xi2(1:n); % periodic domain 
% dx = xi(2)-xi(1);
% k = (2*pi/L)*[0:n/2-1 -n/2:-1].'; % wavenumbers
% 
% %%Define time discretization
% slices = 1000;
% t = linspace(0,pi,slices+1); dt = t(2)-t(1);
% 
% %%Create initial conditions
% q = 2*sech(xi).';
% 
% lambda=1i/2*dt/dx^2;
% A_n = diag((1+2*lambda)*ones(length(xi),1))-diag(lambda*ones(length(xi)-1,1),1)-diag(lambda*ones(length(xi)-1,1),-1);
% A_n(1,1) = 1; A_n(1,2) = 0;
% A_n(end,end-1) = 0; A_n(end, end) = 1;
% 
% qsol = zeros(length(xi),length(t));
% qsol(:,1) = q;
% for iter = 1:length(t)-1
%     qsol(:,iter+1) = A_n\(qsol(:,iter)+dt*1i*abs(qsol(:,iter)).^2.*qsol(:,iter));
% end
% 
% mesh(abs(qsol))
%     
    
% %%Combine signals
%  
% % %Solve with Runge-Kutta
% [tsol,qtsol] = ode45 ('dmd_solition_rhs',t,qt,[],k);
%  
% % %bring back to time domain and store data
% qsol = 0*qtsol;
% for j = 1:length(t)
%     qsol(j,:) = ifft (qtsol(j,:));
% end
% 
% % 
% % M = 20;
% % X = qtsol';
% % A = diag(-1i/2*(k.^2));
% % 
% % 
% % [U,S,V] = svd(X(:,1:M),'econ');
% % r = 10;
% % Ur = U(:,1:r);
% % Sr = S(1:r,1:r);
% % Vr = V(:,1:r);
% % A_tilde = Ur'*A*Ur;
% % b = Ur\X(:,1);
% % 
% % f = 1i*fft((abs(qsol(1:M,:)).^2).*qsol(1:M,:));f = f';
% % [U_f,~,~] = svd(f,'econ');
% % U_f_r = U_f(:,1:r);
% % [~,S] = deim(U_f_r);
% % Phi_deim = U_f_r/(S'*U_f_r);
% % 
% % X_tilde = zeros(r,length(t));
% % X_tilde(:,1) = b;
% % 
% % [tsol,X_sol] = ode45 ('pod_solition_rhs',t,b,[],A,U,S,Ur);
% % X_sol = X_sol';
% % X_pod = Ur*X_sol;
% % 
% % X_pod = ifft(X_pod);
% % 
% % mesh(xi,t,real(X_pod)')
% % xlabel('x')
% % ylabel('t')
% % zlabel('u')
% % title('POD solution')
% % 


function  [q_pod,soln_error] = POD(M,eps)
L = 30; n = 516; % Domain length and # points
xi2 = linspace(-L/2,L/2,n+1); %domain discretization
xi = xi2(1:n); % periodic domain 
dx = xi(2)-xi(1);
k = (2*pi/L)*[0:n/2-1 -n/2:-1].'; % wavenumbers

%%Define time discretization
slices = 60;
tspan = linspace(0,3*pi,slices+1); dt = tspan(2)-tspan(1);

%%Create initial conditions
q = 2*sech(xi).';
qt = fft(q);
%%Combine signals
 
% %Solve with Runge-Kutta
[tsol,qtsol] = ode45 ('dmd_solition_rhs',tspan,qt,[],k);
 
% %bring back to time domain and store data
qsol = 0*qtsol;
for j = 1:length(tspan)
    qsol(j,:) = ifft (qtsol(j,:));
end

X = qsol';
[U,S,V] = svd(X(:,1:M),'econ');
index = find(diag(S)>= S(1,1)*eps);
r = max(index);
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);

U_x = 0*U;
U_x(2:end-1,:) = (U(3:end,:)-U(1:end-2,:))/dx/2;

L = zeros(r,r);
for p = 1:r
    for l = 1:r
        L(p,l) = -1i/2*U_x(:,p)'*U_x(:,l);
    end
end

initial = Ur\q;

[t,a] = ode45 (@(t,a) myode(t,a,L,Ur),tspan,initial);

q_pod = Ur*a';

soln_error = sqrt(sum((abs(X)-abs(q_pod)).^2,1));
end
function dadt = myode(t,a,L,Ur)
dadt = L*a+Ur'*(1i*abs(Ur*a).^2.*(Ur*a));
end
