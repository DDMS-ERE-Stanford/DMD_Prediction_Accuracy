function rhs = dmd_solition_rhs2(t,a,dummy,L,Ur)
rhs = L*a+Ur\(abs(Ur*a).^2.*(Ur*a));