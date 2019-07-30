function[F_Om, F_Ga] = func_F(u, bnodes)
n = length(u);
    F_Ga = sparse(n,1);
    
    F_Om = 20*(u.^3-u) ;
    F_Ga(bnodes) = 20*(u(bnodes).^3-u(bnodes)) ;
end