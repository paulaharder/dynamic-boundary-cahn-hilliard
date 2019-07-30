
function[f_Om, f_Ga] = func_f1(nodes,bnodes,t)
    n = length(nodes);
    f_Ga = sparse(n,1);
    
       
    f_Om = -exp(-t)*nodes(:,1).*nodes(:,2);
       
    f_Ga(bnodes) = 5*exp(-t)*nodes(bnodes,1).*nodes(bnodes,2);
    
end