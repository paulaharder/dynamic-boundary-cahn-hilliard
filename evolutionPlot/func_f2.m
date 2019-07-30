
function[f_Om, f_Ga] = func_f2(nodes,bnodes,t)
    n = length(nodes);
    f_Ga = sparse(n,1);
    
       
    f_Om = 2*exp(-t)*nodes(:,1).*nodes(:,2)- exp(-3*t)*nodes(:,1).^3.*nodes(:,2).^3 ;
    
    f_Ga(bnodes) = -4*exp(-t)*nodes(bnodes,1).*nodes(bnodes,2)- exp(-3*t)*nodes(bnodes,1).^3.*nodes(bnodes,2).^3;
    
end