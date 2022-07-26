function h_dmd = DMD(h,t)
%% inputs: snapshots data h (need reshape first), snapshots time dt, 
%% final time/time interval t wnat to predict;
%% output: DMD predict solution h_dmd (need reshape back) for time/time interval t;

dt = t(2)-t(1);
M = size(h,2);%%number of snapshots
X1 = h(:,1:M-1);
X2 = h(:,2:M);

%% SVD and rank truncation
[U,S,V] = svd(X1, 'econ');
rank_truncation = rank(S);
Ur = U(:,1:rank_truncation);
Sr = S(1:rank_truncation,1:rank_truncation);
Vr = V(:,1:rank_truncation);

%% Build Atilde and DMD Modes
Atilde = Ur'*X2*Vr/Sr;
[W,D] = eig(Atilde);
Phi = X2*Vr/Sr*W; %DMD Modes

%%DMD Spectra
lambda = diag(D);
omega = log(lambda)/dt;

%% Compute DMD Solution
x1 = h(:,1);
b = Phi\x1;
time_dynamics = zeros(rank_truncation,length(t));
for iter = 1:length(t)
    time_dynamics(:,iter) = (b.*exp(omega*t(iter)));
end
X_dmd = Phi*time_dynamics;
X_dmd = real(X_dmd);
end




