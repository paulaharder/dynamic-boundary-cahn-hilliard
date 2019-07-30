function [Boundary_nodes,Boundary_Edges]=boundary_determination(elements)

    % we determine boundary nodes and boundary edges
    tic;

    % edges
    edges(1,:)=[elements(1,1) elements(1,2) 1 0];
    edges(2,:)=[elements(1,2) elements(1,3) 1 0];
    edges(3,:)=[elements(1,3) elements(1,1) 1 0];

    %iteration over all elements
    number_of_elements=size(elements,1);
    
    %by checking if an edge appears in two different
    %elements we determine the boundary elements
    for ind_element=2:number_of_elements
        
        %the nodes of the current element
        node_a=elements(ind_element,1);
        node_b=elements(ind_element,2);
        node_c=elements(ind_element,3);
        double_ab=0;
        double_bc=0;
        double_ca=0;

        number_of_edges=size(edges,1);
        for ind_edge=1:number_of_edges
            
            %check if edge [node_a node_b] is same as current edge
            if isequal([node_a node_b] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_ab=1;
            elseif isequal([node_b node_a] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_ab=1;
            end

            %check if edge [node_b node_c] is same as current edge
            if isequal([node_b node_c] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_bc=1;
            elseif isequal([node_c node_b] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_bc=1;
            end

            %check if edge [node_c node_a] is same as current edge
            if isequal([node_c node_a] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_ca=1;
            elseif isequal([node_a node_c] , edges(ind_edge,1:2))
                edges(ind_edge,4)=ind_element;
                double_ca=1;
            end
        end
        
        %we add all edges which didnt appear double so far to our edge list
        if double_ab == 0
            edges=[edges;[node_a node_b ind_element 0]];
        end

        if double_bc == 0
            edges=[edges;[node_b node_c ind_element 0]];
        end

        if double_ca == 0
            edges=[edges;[node_c node_a ind_element 0]];
        end
    end

    % boundary edges
    number_of_edges=size(edges,1);
    boundary_edge_count=1;
    for ind_edge=1:number_of_edges
        if (edges(ind_edge,4)==0)
            Boundary_Edges(boundary_edge_count,:)=edges(ind_edge,1:2); 
            boundary_edge_count=boundary_edge_count+1;
        end
    end

    %boundary nodes
    Boundary_nodes=unique(Boundary_Edges);

    %disposal of the time
    time=toc;
    disp(['Mesh preprocession: ',num2str(time),'(s)']);
end