# ARBOR NEST Cosimulation usecase
### In setup and testing state
---
#### Get repositories and install everything
  - For VM it is the same process as for TVB-NEST usecase: https://github.com/multiscale-cosim/TVB-NEST-usecase1/blob/main/INSTALL.md
  - With the bootstrap script : https://github.com/multiscale-cosim/TVB-NEST-usecase1/blob/hpc/installation/local/bootstrap.sh
  --> add `git clone --recurse-submodules https://github.com/multiscale-cosim/ARBOR-NEST-usecase1.git` 
  - TODO: update guide / include arbor
#### (additional) Arbor installation:
- create environment and cmake example
  - `mkdir /home/vagrant/arbor_installed`
  - ```cmake /home/vagrant/multiscale-cosim-repos/ARBOR-NEST-usecase1/arbor -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_C_COMPILER=$CC -DARB_USE_BUNDLED_LIBS=ON -DARB_WITH_PYTHON=ON -DPYTHON_EXECUTABLE=`which python3` -DARB_WITH_MPI=ON```
- install in C++ and Python: 
  - `make -j 4` `make -j 4 test` `make -j 4 examples`
  - `make install`
  - `pip3 install /home/vagrant/multiscale-cosim-repos/ARBOR-NEST-usecase1/arbor/`

---
--> usecase repository, all packages should be installed

--> nest and arbor should be available as library in python

---
### Next steps / TODOs:
#### Action Adapters
  - Interscalehub (copied from TVB-Nest usecase): new managers for Arbor (see: https://github.com/multiscale-cosim/EBRAINS_InterscaleHUB/blob/main/Interscale_hub/manager_nest_to_tvb.py)
  - Nest (copied from TVB-Nest usecase): new adapter / edit current one to fit this usecase
  - Arbor: new adapter 
#### Configurations files
  - Actions, Parameters, Plans: https://github.com/multiscale-cosim/EBRAINS_WorkflowConfigurations/tree/23e05d2e425eafe4a6c9253325fbc3caf1fc56f8/usecase/local/
  - Create new ones or extend current ones?
  - for local and/or hpc systems ?
