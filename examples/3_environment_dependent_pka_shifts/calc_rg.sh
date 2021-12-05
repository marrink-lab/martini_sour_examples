#!/bin/bash

pHrange=(3.00 3.50 4.00 4.50 5.00 5.50 6.00 6.50 7.00 7.50 8.00)

rm -f radius_of_gyration.txt

# Calculate radius of gyration
for pH in ${pHrange[*]}; do
  cd ${pH}/NpT
  echo 2 | gmx polystat -f traj_comp.xtc > polystat.out 2>&1 
  gmx analyze -f polystat.xvg -ee > analyze.out 2>&1
  val=$(grep 'SS2' analyze.out | awk '{print $2}')
  echo ${pH} ${val} >> ../../radius_of_gyration.txt
  cd ../..
done

# Plot results
python3 << EOF 
import numpy as np
import matplotlib.pyplot as plt

ph, radius_of_gyration = np.loadtxt('radius_of_gyration.txt', unpack=True)

fig = plt.figure()
plt.plot(ph, radius_of_gyration, marker='D', linestyle='--')

plt.xlabel('pH')
plt.ylabel('Radius of gyration (nm)')

fig.tight_layout()
fig.savefig('radius_of_gyration.pdf', bbox_inches='tight')
EOF
