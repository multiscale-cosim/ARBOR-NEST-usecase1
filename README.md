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
---
### Next steps / TODOs:
#### Action Adapters
  - Interscalehub (copied from TVB-Nest usecase)
  - Nest (copied from TVB-Nest usecase): new adapter / edit current one to fit this usecase
  - Arbor: new adapter
#### Model and Parameters
  - add models adn parameters for NEST and ARBOR in userland/modles which is then loaded by adpater(s) for configuration and simulation
  - For ref
    -- NEST adapter https://github.com/multiscale-cosim/Cosim-LFPy/blob/main/action_adapters/nest_simulator/nest_adapter.py
    -- model at https://github.com/multiscale-cosim/Cosim-LFPy/tree/main/userland/models/Potjans
    -- parameters at https://github.com/multiscale-cosim/Cosim-LFPy/tree/main/userland/parameters
#### InterscaleHUB endpoints
  - Add a Manager class for setup and steering at https://github.com/multiscale-cosim/EBRAINS_InterscaleHUB/tree/main/managers/usecase_specific
  - Communication class for ARBOR at https://github.com/multiscale-cosim/EBRAINS_InterscaleHUB/tree/main/communicators

#### Configurations files
  - see sample files in userland/configs i.e. https://github.com/multiscale-cosim/ARBOR-NEST-usecase1/tree/main/userland/configs
  
