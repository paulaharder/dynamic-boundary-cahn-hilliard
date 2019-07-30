function A_distmesh_runscript

%   Example: (Uniform Mesh on Unit Sphere)
%      fd=@(p) dsphere(p,0,0,0,1);
%      fd=@(x) x(:,1).^2 + x(:,2).^2 + x(:,3).^2 -1;
%      [Nodes,Elements]=distmeshsurface(fd,@huniform,0.4,1.5*[-1,-1,-1;1,1,1]);

%   Example: (Graded Mesh on Unit Sphere)
%      fd=@(p) dsphere(p,0,0,0,1);
%      fh=@(p) 0.05+0.5*dsphere(p,0,0,1,0);
%      [Nodes,Elements]=distmeshsurface(fd,fh,0.15,1.1*[-1,-1,-1;1,1,1]);

%   Example: (Uniform Mesh on Torus)
    %fd=@(p) (sum(p.^2,2)+.8^2-.2^2).^2-4*.8^2*(p(:,1).^2+p(:,2).^2);
    %[Nodes,Elements]=distmeshsurface(fd,@huniform,0.1,[-1.1,-1.1,-.25;1.1,1.1,.25]);

%   Example: (Uniform Mesh on Ellipsoid)
%      fd=@(p) p(:,1).^2/4+p(:,2).^2/1+p(:,3).^2/1.5^2-1;
%      [Nodes,Elements]=distmeshsurface(fd,@huniform,0.2,[-2.1,-1.1,-1.6; 2.1,1.1,1.6]);
a = [0.4 0.03 0.2 0.175 0.15 0.125 0.1 0.075 0.05 0.025];
k = length(a);
for n = 0 : k-1
fd=@(p) sqrt(sum(p.^2,2))-1;
[Nodes,Elements]=distmesh2d(fd,@huniform,a(n+1),[-1,-1;1,1],[]);

length(Nodes)

save(['Circle_nodes',num2str(n),'.txt'],'Nodes','-ASCII');
save(['Circle_elements',num2str(n),'.txt'],'Elements','-ASCII');

end