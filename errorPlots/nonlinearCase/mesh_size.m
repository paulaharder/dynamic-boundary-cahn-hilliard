function[hmax] = mesh_size(nodes, elements)

    %this function computes the mesh size of a given mesh as the maximal
    %side length of all triangles
    hmax=0;
    for j = 1:size(elements,1)
        x_1=[nodes(elements(j,1),1) nodes(elements(j,1),2)]';
        x_2=[nodes(elements(j,2),1) nodes(elements(j,2),2)]';
        x_3=[nodes(elements(j,3),1) nodes(elements(j,3),2)]';
  
        hmax=max([hmax, norm(x_1-x_2), norm(x_1-x_3), norm(x_2-x_3)]);
    end    
end