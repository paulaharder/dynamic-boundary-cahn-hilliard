function[f_Om, f_Ga] = func_f1(nodes,bnodes,t)
    %the inhomogeneities f_1^\Omega and f_2^\Gamma

    n = length(nodes);
    f_Ga = sparse(n,1);
    
    %the function on the bulk   
    f_Om = -exp(-t)*nodes(:,1).*nodes(:,2);
    
    %the function at the boundary   
    f_Ga(bnodes) = 5*exp(-t)*nodes(bnodes,1).*nodes(bnodes,2);
    
end