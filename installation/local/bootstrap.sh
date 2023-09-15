#!/bin/bash

#
# USAGE: 
#   a) using defaults <BASELINEPATH>=${HOME} <GITUSERNAME>=multiscale-cosim
#           sh ./TVB_NEST-usecase1_ubuntu_setting_up.sh
#    
#   b) specifiying the parameters   
#        sh ./TVB_NEST_usecase1_ubuntu_setting_up.sh <BASELINEPATH> <GITUSERNAME>
#       e.g. 
#           ./TVB_NEST_usace1_ubuntu_setting_up.sh /opt/MY_COSIM sontheimer

BASELINE_PATH="/home/vagrant"
BASELINE_PATH=${1:-${BASELINE_PATH}}

GIT_DEFAULT_NAME='multiscale-cosim'
GIT_DEFAULT_NAME=${2:-${GIT_DEFAULT_NAME}}

#
# STEP 1 - setting up folder locations
#

[ -d ${BASELINE_PATH} ] \
	|| (echo "${BASELINE_PATH} does not exists"; exit 1;)

#
# Full base path where installation happends:
#
# CO_SIM_ROOT_PATH = /home/<user>/multiscale-cosim/
# or
# CO_SIM_ROOT_PATH = /home/<user>/<git_account_name>/
#
CO_SIM_ROOT_PATH=${BASELINE_PATH}/${GIT_DEFAULT_NAME}

mkdir -p ${CO_SIM_ROOT_PATH}
cd ${CO_SIM_ROOT_PATH}

# CO_SIM_REPOS=${CO_SIM_ROOT_PATH}/cosim-repos
CO_SIM_SITE_PACKAGES=${CO_SIM_ROOT_PATH}/site-packages
CO_SIM_NEST_BUILD=${CO_SIM_ROOT_PATH}/nest-build
CO_SIM_NEST=${CO_SIM_ROOT_PATH}/nest-installed
CO_SIM_ARBOR=${CO_SIM_ROOT_PATH}/arbor
#
# STEP 2 - installing linux packages
#
# STEP 2.1 - base packages
sudo apt update
sudo apt install -y build-essential git python3 python3-pip
sudo snap install cmake --classic # arbor needs version 3.19+
#
# STEP 2.2 - packages used by NEST, TVB and the use-case per se
sudo apt install -y doxygen
sudo apt install -y libboost-all-dev libgsl-dev libltdl-dev \
                    libncurses-dev libreadline-dev 
sudo apt install -y mpich

#
# STEP 2.3 - switching the default MPI installed packages to MPICH
#   Selection    Path                     Priority   Status
#------------------------------------------------------------
#* 0            /usr/bin/mpirun.openmpi   50        auto mode
#  1            /usr/bin/mpirun.mpich     40        manual mode
#  2            /usr/bin/mpirun.openmpi   50        manual mode
echo "1" | sudo update-alternatives --config mpi 1>/dev/null 2>&1 # --> choosing mpich
echo "1" | sudo update-alternatives --config mpirun 1>/dev/null 2>&1 # --> choosing mpirun
 
#
# STEP 3 - install python packages for the ARBOR-NEST use-case
#
pip install --target=${CO_SIM_SITE_PACKAGES} \
    cython mpi4py pyzmq mpi4py numpy matplotlib \
    flask flask-cors gunicorn

export PATH=/home/vagrant/.local/bin:$PATH
export PATH=${CO_SIM_SITE_PACKAGES}/bin:${PATH}
export PYTHONPATH=${CO_SIM_SITE_PACKAGES}:${PYTHONPATH:+:$PYTHONPATH}
export CC=/usr/bin/gcc # arbor compilation
export CXX=/usr/bin/g++ # arbor compilation

# 
# STEP 4 - cloning github repos
#
git clone --recurse-submodules --jobs 4 https://github.com/${GIT_DEFAULT_NAME}/ARBOR-NEST-usecase1.git

# STEP 5 - ARBOR
#
mkdir -p ${CO_SIM_ARBOR}

cd ${CO_SIM_ARBOR}
cmake \
    -DCMAKE_INSTALL_PREFIX:PATH=${CO_SIM_ARBOR} \
    ${CO_SIM_ROOT_PATH}/ARBOR-NEST-usecase1/arbor \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_C_COMPILER=$CC \
    -DARB_USE_BUNDLED_LIBS=ON \
    -DARB_WITH_PYTHON=ON \
    -DPYTHON_EXECUTABLE=`which python3` \
    -DARB_WITH_MPI=ON

make -j 4 
make -j 4 tests 
make -j 4 examples
make install
pip3 install ${CO_SIM_ROOT_PATH}/ARBOR-NEST-usecase1/arbor/
echo "ARBOR installed"

# 
# STEP 6 - NEST compilation
# International Neuroinformatics Coordinating Facility (INCF) 
# https://github.com/INCF/MUSIC
# https://github.com/INCF/libneurosim
git clone https://github.com/nest/nest-simulator.git
cd nest-simulator
# 9cb3cb: Merge pull request from VRGroupRWTH/feature/device_label (https://github.com/nest/nest-simulator/commit/9cb3cb2ec1cc76e278ed7e9a8850609fdb443cae) 
# TODO: Needed until NEST v3.6 release to incorporate the aforementioned pull request.
git checkout 9cb3cb
cd ..

# Cython
export PATH=${CO_SIM_SITE_PACKAGES}/bin:${PATH}
export PYTHONPATH=${CO_SIM_SITE_PACKAGES}:${PYTHONPATH:+:$PYTHONPATH}

mkdir -p ${CO_SIM_NEST} ${CO_SIM_NEST_BUILD}; cd ${CO_SIM_NEST_BUILD}

cmake \
    -DCMAKE_INSTALL_PREFIX:PATH=${CO_SIM_NEST} \
    ${CO_SIM_ROOT_PATH}/nest-simulator \
    -Dwith-mpi=ON \
    -Dwith-openmp=ON \
    -Dwith-readline=ON \
    -Dwith-ltdl=ON \
    -Dcythonize-pynest=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.10 \
    -DPYTHON_INCLUDE_DIR=/usr/include/python3.10 \
    -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.10.so

make -j 4
make -j 4 install
cd ${CO_SIM_ROOT_PATH}
echo "NEST installed"

#
# STEP 7 - WORK-AROUNDs (just in case)
#
echo "Usecase specific configuration..."
# removing typing.py as work-around for pylab on run-time
# rm -f ${CO_SIM_SITE_PACKAGES}/typing.py
#


#
# STEP 8 - Generating the .source file based on ENV variables
#
echo "Creating source and run scripts..."
NEST_PYTHON_PREFIX=`find ${CO_SIM_NEST} -name site-packages`
CO_SIM_USE_CASE_ROOT_PATH=${CO_SIM_ROOT_PATH}/ARBOR-NEST-usecase1
CO_SIM_MODULES_ROOT_PATH=${CO_SIM_ROOT_PATH}/ARBOR-NEST-usecase1

SUFFIX_PYTHONPATH="\${PYTHONPATH:+:\$PYTHONPATH}"

cat <<.EOSF > ${CO_SIM_ROOT_PATH}/ARBOR-NEST-usecase1.source
#!/bin/bash
export CO_SIM_ROOT_PATH=${CO_SIM_ROOT_PATH}
export CO_SIM_USE_CASE_ROOT_PATH=${CO_SIM_USE_CASE_ROOT_PATH}
export CO_SIM_MODULES_ROOT_PATH=${CO_SIM_MODULES_ROOT_PATH}
export PYTHONPATH=${CO_SIM_MODULES_ROOT_PATH}:${CO_SIM_SITE_PACKAGES}:${NEST_PYTHON_PREFIX}${SUFFIX_PYTHONPATH}
export PATH=${CO_SIM_NEST}/bin:${PATH}
.EOSF

# 
# STEP 9 - Generating the run_on_local.sh  
cat <<.EORF > ${CO_SIM_ROOT_PATH}/run_on_local.sh
# checking for already set CO_SIM_* env variables
CO_SIM_ROOT_PATH=\${CO_SIM_ROOT_PATH:-${CO_SIM_ROOT_PATH}}
CO_SIM_USE_CASE_ROOT_PATH=\${CO_SIM_USE_CASE_ROOT_PATH:-${CO_SIM_USE_CASE_ROOT_PATH}}
CO_SIM_MODULES_ROOT_PATH=\${CO_SIM_MODULES_ROOT_PATH:-${CO_SIM_MODULES_ROOT_PATH}}
# exporting CO_SIM_* env variables either case
export CO_SIM_ROOT_PATH=\${CO_SIM_ROOT_PATH}
export CO_SIM_USE_CASE_ROOT_PATH=\${CO_SIM_USE_CASE_ROOT_PATH}
export CO_SIM_MODULES_ROOT_PATH=\${CO_SIM_MODULES_ROOT_PATH}
# CO_SIM_ site-packages for PYTHONPATH
export CO_SIM_PYTHONPATH=${CO_SIM_MODULES_ROOT_PATH}:${CO_SIM_SITE_PACKAGES}:${NEST_PYTHON_PREFIX}
# adding EBRAINS_*, site-packages to PYTHONPATH (if needed)
PYTHONPATH=\${PYTHONPATH:-\$CO_SIM_PYTHONPATH}
echo \$PYTHONPATH | grep ${CO_SIM_SITE_PACKAGES} 1>/dev/null 2>&1
[ \$? -eq 0 ] || PYTHONPATH=\${CO_SIM_PYTHONPATH}:\$PYTHONPATH
export PYTHONPATH=\${PYTHONPATH}
# making nest binary reachable
# __ric__? PATH=\${PATH:-$CO_SIM_NEST/bin}
echo \$PATH | grep ${CO_SIM_NEST}/bin 1>/dev/null 2>&1
[ \$? -eq 0 ] || export PATH=$CO_SIM_NEST/bin:\${PATH}
python3 \${CO_SIM_USE_CASE_ROOT_PATH}/main.py \\
    --global-settings \${CO_SIM_MODULES_ROOT_PATH}/EBRAINS_WorkflowConfigurations/general/global_settings.xml \\
    --action-plan \${CO_SIM_MODULES_ROOT_PATH}/userland/configs/local/plans/cosim_alpha_brunel_local.xml
.EORF

cat <<.EOKF >${CO_SIM_ROOT_PATH}/kill_co_sim_PIDs.sh
for co_sim_PID in \`ps aux | grep TVB-NEST-usecase1 | sed 's/user//g' | sed 's/^ *//g' | cut -d" " -f 1\`; do kill -9 \$co_sim_PID; done
.EOKF

#
# STEP 10 - THIS IS THE END!
# testing



echo "SETUP DONE!" 
