function [y]  = func_sol(nodes,t)

    %the chosen solution for u and w
    y = exp(-t)*nodes(:,1).*nodes(:,2);
end