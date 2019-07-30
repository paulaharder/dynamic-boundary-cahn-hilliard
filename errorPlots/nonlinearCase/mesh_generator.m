function mesh_generator
%this function generates the meshes

% the 'mesh width' are chosen such that the number of nodes doubles,
% starting from 20
    a = [0.389 0.301 0.2095 0.1505 0.105 0.07507 0.0532 0.03762];
k = length(a);
dof = zeros(k,1);
for n = 0 : k-1
fd=@(p) sqrt(sum(p.^2,2))-1;

[nodes, elements]=distmesh2d(fd,@huniform,a(n+1),[-1,-1;1,1],[]);

dof(n+1) = length(nodes);

save(['Circle_nodes',num2str(n),'.txt'],'nodes','-ASCII');
save(['Circle_elements',num2str(n),'.txt'],'elements','-ASCII');

end