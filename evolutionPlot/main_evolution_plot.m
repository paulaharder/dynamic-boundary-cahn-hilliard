function main_evolution_plot
    
 
    %end time
    T=3.1;

    %number of different grids (different sizs) we use
    grid_number = 7;
   

    %the different time step sizes we use
    tau = 0.00125;
  

   
    %the bdf tableau
    k=2;
    [delta_2, gamma_2] = BDF_tableau(2);
  
        
    %loading of nodes and elements
    nodes=load(['Circle_nodes',num2str(grid_number-1),'.txt']);
    elements=load(['Circle_elements',num2str(grid_number-1),'.txt']);
    number_of_nodes = length(nodes);
        
    nodes=10*nodes;
    
        
    %determination of boundary nodes and boundary elements
    [boundary_indizes,boundary_elements] = boundary_determination(elements);
        
    %bulk matrix assembly of mass and stiffness matrix
    [A_Om, M_Om] = assembly_bulk(nodes, elements);
        
    %surface matrix assembly of mass and stiffness matrix
    [A_Ga, M_Ga] = assembly_surface(nodes, boundary_elements);
        
       
     %The bulk-surface coupling matrices
     A = A_Om + A_Ga;
     M = M_Om + M_Ga;
            
            
     %number of time steps we make
    number_of_timesteps = ceil(T/tau);
            
    %initialization of the intermediate solution (u,w)
    u = zeros(number_of_nodes, number_of_timesteps);
    w = zeros(number_of_nodes, number_of_timesteps);
            
    %the bdf-k method starts
            
    %the starting values for the bdf met0hods
            
            
    %we choose random initial data for u_0
    for j = 1:number_of_nodes
        a = randn;
       
        u(j,1) = sign(a);
    end
    
    %we determine w_0
    [F_Om, F_Ga] = func_F(u(:,1), boundary_indizes);
    F = M_Om*F_Om + M_Ga*F_Ga;
    w(:,1) = M\(A*u(:,1)+F);
            
     %we determine u_tau and w_tau
     
     %___________________
                
               
    %__________________________
    %ADDING THE NON-LINEARITY F ON THE RHS
    rhs_bdf = [  M*1/tau*u(:,1); F];
    %_______________________
                
    lhs_bdf = [1/tau*M A; -A M];
                
    u_w = lhs_bdf\rhs_bdf;
                
    u(:,2) = u_w(1:number_of_nodes,:);
    w(:,2) = u_w(number_of_nodes+1:2*number_of_nodes,:);
            
    for i = k+1:number_of_timesteps
        
         sum_bdf = 0;
         for l = 1:k
              sum_bdf = sum_bdf + delta_2(l+1)*u(:,i-l);
         end
                
         %___________________
         %THE NON_LINEARITY
         u_tilde = 0;
         for l = 1:k
               u_tilde = u_tilde + gamma_2(l)*u(:,i-l);
         end
                
              
         [F_Om, F_Ga] = func_F(u_tilde, boundary_indizes);
         F = M_Om*F_Om + M_Ga*F_Ga;
         %___________________
                
               
         %__________________________
         %ADDING THE NON-LINEARITY F ON THE RHS
         rhs_bdf = [  - M*1/tau*sum_bdf; F];
         %_______________________
                
        lhs_bdf = [delta_2(1)*1/tau*M A; -A M];
                
         u_w = lhs_bdf\rhs_bdf;
                
         u(:,i) = u_w(1:number_of_nodes,:);
         w(:,i) = u_w(number_of_nodes+1:2*number_of_nodes,:);
            
            
            
            
    end
    
    times = [0 0.005 0.01 0.1 0.2 0.35 0.5 0.7 3];
    
    
    figure
    
    for i = 1 : 9
        subplot(3,3,i)
        
        time = times(i);
        time_step = floor(time/tau)+1;
        trisurf(elements, nodes(:,1), nodes(:,2),0*nodes(:,2),u(:,time_step));
        view([0 0 1]);
        title(['t = ',num2str(time)])
        axis('equal');
        hold on 
     
    end

    colorbar
end