function main_cahn_hilliard_nonlinear
    
 
    %end time
    T=1;

    %number of different grids (different sizs) we use
    number_of_grids = 8;
   

    %the different time step sizes we use
    taus = [0.025 0.0125 0.005 0.0025 0.00125];
    number_of_timestep_sizes = length(taus);

    %initialization of the errors in L^2 and H^2 norm
    u_error_L2 = zeros(number_of_grids, number_of_timestep_sizes);
    u_error_H1 = zeros(number_of_grids, number_of_timestep_sizes);
    w_error_L2 = zeros(number_of_grids, number_of_timestep_sizes);
    w_error_H1 = zeros(number_of_grids, number_of_timestep_sizes);

    %the bdf tableau
    k=3;
    [delta, gamma] = BDF_tableau(k);
    
    mesh_sizes = zeros(number_of_grids,1);
    
    %iteration over the different grids
    for grid_number = 1:number_of_grids
        
        %loading of nodes and elements
        nodes=load(['Circle_nodes',num2str(grid_number-1),'.txt']);
        elements=load(['Circle_elements',num2str(grid_number-1),'.txt']);
        number_of_nodes = length(nodes);
        
        mesh_sizes(grid_number)=mesh_size(nodes,elements);
        
        
        %determination of boundary nodes and boundary elements
        [boundary_indizes,boundary_elements] = boundary_determination(elements);
        

        %bulk matrix assembly of mass and stiffness matrix
        [A_Om, M_Om] = assembly_bulk(nodes, elements);
        
        %surface matrix assembly of mass and stiffness matrix
        [A_Ga, M_Ga] = assembly_surface(nodes, boundary_elements);
        
        A = sparse(number_of_nodes,number_of_nodes);
        M = sparse(number_of_nodes,number_of_nodes);
        %The bulk-surface coupling matrices
        A = A_Om + A_Ga;
        M = M_Om + M_Ga;
        
      
        %determioniation of the exact solution
        solution_u = func_sol_u(nodes,T);
        solution_w = func_sol_w(nodes,T);
        
        
        
        %iteration over the different time step sizes
        for j = 1:number_of_timestep_sizes
            
            %the time step size
            tau = taus(j);
            
            %number of time steps we make
            number_of_timesteps = ceil(T/tau);
            
            %initialization of the intermediate solution (u,w)
            u = zeros(number_of_nodes, number_of_timesteps);
            w = zeros(number_of_nodes, number_of_timesteps);
            
            %the bdf-k method starts
            
            %the starting values for the bdf met0hods
            for i = 1:k
                time = (i-1)*tau;
                u(:,i) = func_sol_u(nodes,time);
                w(:,i) = func_sol_w(nodes,time);
            end
            
            for i = k+1:number_of_timesteps
                time = (i-1)*tau;
                
                [f1_Om, f1_Ga] = func_f1(nodes,boundary_indizes,time);
                
                %_________________
                %FUNC_F2 CHANGED CAUSE OF NONLINEARITY
                [f2_Om, f2_Ga] = func_f2(nodes,boundary_indizes,time);
                %______________________
                
                b1 = M_Om*f1_Om + M_Ga*f1_Ga;
                b2 = M_Om*f2_Om + M_Ga*f2_Ga;
                
                sum_bdf = 0;
                for l = 1:k
                    sum_bdf = sum_bdf + delta(l+1)*u(:,i-l);
                end
                
                %___________________
                %THE NON_LINEARITY
                u_tilde = 0;
                for l = 1:k
                    u_tilde = u_tilde + gamma(l)*u(:,i-l);
                end
                
              
               [F_Om, F_Ga] = func_F(u_tilde, boundary_indizes);
               F = M_Om*F_Om + M_Ga*F_Ga;
               %___________________
                
               
               %__________________________
               %ADDING THE NON-LINEARITY F ON THE RHS
                rhs_bdf = [b1  - M*1/tau*sum_bdf; b2+F];
                %_______________________
                
                lhs_bdf = [delta(1)*1/tau*M A; -A M];
                
                u_w = lhs_bdf\rhs_bdf;
                
                u(:,i) = u_w(1:number_of_nodes,:);
                w(:,i) = u_w(number_of_nodes+1:2*number_of_nodes,:);
                
            end
            
            u_error = u(:,i) - solution_u;
            w_error = w(:,i) - solution_w;
            
            u_error_L2(grid_number, j) = sqrt(u_error'*M*u_error);
            u_error_H1(grid_number, j) = sqrt(u_error'*A*u_error);
            w_error_L2(grid_number, j) = sqrt(w_error'*M*w_error);
            w_error_H1(grid_number, j) = sqrt(w_error'*A*w_error);
            
            u_err=[u_error_L2(grid_number, j) ; u_error_H1(grid_number, j)];
            save(['u_errors/errors_grid',num2str(grid_number),'_tau',num2str(tau), '.txt'],'u_err','-ASCII');
            w_err=[w_error_L2(grid_number, j) ; w_error_H1(grid_number, j)];
            save(['w_errors/errors_grid',num2str(grid_number),'_tau',num2str(tau), '.txt'],'w_err','-ASCII');
        end
    end 

     
    u_error_H1 = u_error_H1 + u_error_L2;   
    %die Fehler werden geplottet
    x=mesh_sizes;
   
    figure


    subplot(1,2,1)
    for j=1:length(taus)
        loglog(x,u_error_L2(:,j)+w_error_L2(:,j),'*-')
        hold on
    end
    loglog(x,x.^2,'--');
    legend('\tau=0.025','\tau=0.0125','\tau=0.005','\tau=0.0025','\tau=0.00125','O(h^2)')
    xlabel('mesh width')
    ylabel('error')
    title('$|u(\cdot,t^N)-(u_h^N)^l|+|w(\cdot,t^N)-(w_h^N)^l|$','Interpreter','latex') 
    hold off

    subplot(1,2,2)
    for j=1:length(taus)
        loglog(x,u_error_H1(:,j)+w_error_H1(:,j),'*-')
        hold on
    end
    loglog(x,x,'--');
    hold on
    loglog(x,x.^2,'--');
    legend('\tau=0.025','\tau=0.0125','\tau=0.005','\tau=0.0025','\tau=0.00125','O(h)','O(h^2)')
    xlabel('mesh width')
    ylabel('error')
    title('$||u(\cdot,t^N)-(u_h^N)^l||+||w(\cdot,t^N)-(w_h^N)^l||$','Interpreter','latex')
    hold off

end