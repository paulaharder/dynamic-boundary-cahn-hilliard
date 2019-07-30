function [A,M]=assembly_surface(nodes,elements)

    N=length(nodes);

    A=zeros(N, N);
    M=zeros(N, N);
    
    %mass matrix 
    M0_surface=[1/3 1/6
               1/6 1/3];
    %stiffness matrix
    A_ref_surface=[1  -1
                   -1   1];

    for i_element=1:size(elements,1)  
        
        a=nodes(elements(i_element,1),:);
        b=nodes(elements(i_element,2),:);
        nrm=norm(b-a);
    
        %local stiffness and mass matrix
        A_loc=(1/nrm)*A_ref_surface;
        M_loc=nrm*M0_surface;
    
    
        A(elements(i_element,1:2),elements(i_element,1:2))=A(elements(i_element,1:2),elements(i_element,1:2))+A_loc;
        M(elements(i_element,1:2),elements(i_element,1:2))=M(elements(i_element,1:2),elements(i_element,1:2))+M_loc;
    end

end