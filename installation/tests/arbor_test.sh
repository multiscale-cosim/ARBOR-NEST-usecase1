#!/bin/bash

### Run Arbor test scripts

# 1) simple example
/home/vagrant/multiscale-cosim/arbor/bin/dryrun

# 2) remote mpi example
mpirun -n 2 /home/vagrant/multiscale-cosim/arbor/bin/remote
