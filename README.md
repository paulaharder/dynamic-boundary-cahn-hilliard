# Masterthesis

If you use this code, please cite:

```sh
@misc{https://doi.org/10.48550/arxiv.2208.04242,
  doi = {10.48550/ARXIV.2208.04242},
  url = {https://arxiv.org/abs/2208.04242},  
  author = {Harder, Paula},
  title = {Abstract error analysis for Cahn--Hilliard type equations with dynamic boundary conditions},
  publisher = {arXiv},
  year = {2022}
}
```

This project are the implementations I did for my masterthesis.
These implementations solve the Cahn-Hilliard equation with
dynamic Cahn-Hilliard boundary conditions on a disk by using 
the finite element method for spatial discretization and the
bdf3 method for time discretization. For details please read
my thesis.
You can contact me for questions: paulaharder@posteo.de

The directory /errorPlots/linearCase contains an implementation of solving a
linear variant of the Cahn-Hilliard equation and generates error plots,
to visualize the spatial convergence.
To obtain the plot shown in my thesis just run the main_cahn_hilliard_linear.m
file.
This case needs about one hour to finish, if you want to have quicker results
you need to decrease the variable number_of_grids

The directory /errorPlots/nonlinearCase contains an implementation of solving a
linear variant of the Cahn-Hilliard equation and generates error plots,
to visualize the spatial convergence.
To obtain the plot shown in my thesis just run the main_cahn_hilliard_linear.m
file.
This case needs about one hour to finish, if you want to have quicker results
you need to decrease the variable number_of_grids

The directory /evolutionPlot contains an implementation of solving a
nonlinear variant of the Cahn-Hilliard equation and generates plots,
to visualize the evolution of the solution in time.
To obtain the plot shown in my thesis just run the main_evolution_plot.m
file.
This case needs about half an hour to finish, if you want to have quicker results
you need to decrease the variable grid_number


