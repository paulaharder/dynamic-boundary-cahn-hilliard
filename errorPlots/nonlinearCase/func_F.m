function[F_Om, F_Ga] = func_F(u, bnodes)
%the nonlineaity
    n = length(u);
    F_Ga = sparse(n,1);
    
    F_Om = u.^3-u ;
    F_Ga(bnodes) = u(bnodes).^3-u(bnodes) ;
end