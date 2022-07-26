function rhs = dmd_solition_rhs(t,qt,dummy,k)
q = ifft(qt);
rhs = -(i/2)*(k.^2).*qt+i*fft((abs(q).^2).*q);
