function rhs = pod_solition_rhs(t,b,dummy,A,U,S,Ur)
A_tilde = Ur'*A*Ur;
Phi_deim = U/(S'*U);
y_deim = S'*Ur*b;
q = ifft(y_deim);
rhs = Ur'*Phi_deim*(1i*fft((abs(q).^2).*q));
rhs = A_tilde*b'+rhs';
end