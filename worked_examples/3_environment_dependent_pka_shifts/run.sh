#!/bin/bash

pHrange=(3.00 3.50 4.00 4.50 5.00 5.50 6.00 6.50 7.00 7.50 8.00)

for pH in ${pHrange[*]}; do
  cd ${pH}/min
  gmx grompp -f ../../min.mdp -c ../../start.gro -p ../system.top
  gmx mdrun

  cd ../eq
  gmx grompp -f ../../eq.mdp -c ../min/confout.gro -p ../system.top
  gmx mdrun -nt 10

  cd ../NpT
  gmx grompp -f ../../NpT.mdp -c ../eq/confout.gro -p ../system.top
  gmx mdrun -nt 10

  cd ../..
done
