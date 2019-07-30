function [y]  = func_sol_w(nodes,t)
    y = exp(-t)*nodes(:,1).*nodes(:,2);
end