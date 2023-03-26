# ARBOR NEST Cosimulation usecase
### WIP
---
#### Get repositories and install everything
  - For VM it is the same process as for TVB-NEST usecase: https://github.com/multiscale-cosim/TVB-NEST-usecase1/blob/main/INSTALL.md
      - updated `bootstrap.sh` and `Vagrantfile` in https://github.com/multiscale-cosim/ARBOR-NEST-usecase1/tree/main/installation/local

Short description:
  - Have virtualbox and vagrant installed
  - get the bootstrap.sh and Vagrantfile from the installation folder
    - create a VM directory on the host-system with the bootrap.sh, Vagrantfile and a shared firectory
  - run `vagrant up` to start the VM with ARBOR and NEST installed
  - run `vagrant ssh` to log in to the VM
  - test the installation:
    - `cd multiscale-cosim`
    - `source ARBOR-NEST-usecase1.source`
    - `python3 ARBOR-NEST-usecase1/installation/tests/nest_test.py`
    - `sh ARBOR-NEST-usecase1/installation/tests/arbor_test.sh`

#### Troubleshooting:
  - Error message during NEST installation
  - failed ARBOR remote test
  

---
### Next steps / TODOs:
#### Action Adapters
  - Interscalehub (copied from TVB-Nest usecase)
  - Nest (copied from TVB-Nest usecase): new adapter / edit current one to fit this usecase
  - Arbor: new adapter 
#### InterscaleHUB endpoints
  - Manager class for setup and steering ( https://github.com/multiscale-cosim/EBRAINS_InterscaleHUB/blob/main/Interscale_hub/manager_nest_to_tvb.py)
  - Communication class for actual data transport (https://github.com/multiscale-cosim/EBRAINS_InterscaleHUB/blob/main/Interscale_hub/communicator_nest_to_tvb.py)
#### Configurations files
  - Actions, Parameters, Plans: https://github.com/multiscale-cosim/EBRAINS_WorkflowConfigurations/tree/23e05d2e425eafe4a6c9253325fbc3caf1fc56f8/usecase/local/
  - Create new ones or extend current ones?
  - for local and/or hpc systems ?
