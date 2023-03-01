# ARBOR NEST Cosimulation usecase

### In setup and testing state -- more information coming soon -- 
---
#### Get repositories and install everything
  - Same process as here: https://github.com/multiscale-cosim/TVB-NEST-usecase1/blob/main/INSTALL.md
  - Bootstrap script for above usecase: https://github.com/multiscale-cosim/TVB-NEST-usecase1/blob/hpc/installation/local/bootstrap.sh
  --> add `git clone --recurse-submodules https://github.com/multiscale-cosim/ARBOR-NEST-usecase1.git` 
  - TODO: update guide / include arbor
#### Arbor installation on local VM:
- create environment
  - `mkdir /home/vagrant/arbor_installed`
  - ```cmake /home/vagrant/multiscale-cosim-repos/ARBOR-NEST-usecase1/arbor -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_C_COMPILER=$CC -DARB_USE_BUNDLED_LIBS=ON -DARB_WITH_PYTHON=ON -DPYTHON_EXECUTABLE=`which python3` -DARB_WITH_MPI=ON```
- C++ and Python: 
  - `make -j 4` `make -j 4 test``make -j 4 examples`
  - `make install`
  - `pip3 install /home/vagrant/multiscale-cosim-repos/ARBOR-NEST-usecase1/arbor/`


--> usecase repository, all packages, nest and arbor should be installed and available as library in python