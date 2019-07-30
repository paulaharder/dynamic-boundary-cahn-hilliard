function [y]  = func_sol_u(nodes,t)
    y = exp(-t)*nodes(:,1).*nodes(:,2);
end