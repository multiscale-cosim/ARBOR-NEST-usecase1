# checking for already set CO_SIM_* env variables
CO_SIM_ROOT_PATH=${CO_SIM_ROOT_PATH:-/home/vagrant/multiscale-cosim}
CO_SIM_USE_CASE_ROOT_PATH=${CO_SIM_USE_CASE_ROOT_PATH:-/home/vagrant/multiscale-cosim/ARBOR-NEST-usecase1}
CO_SIM_MODULES_ROOT_PATH=${CO_SIM_MODULES_ROOT_PATH:-/home/vagrant/multiscale-cosim/ARBOR-NEST-usecase1}
# exporting CO_SIM_* env variables either case
export CO_SIM_ROOT_PATH=${CO_SIM_ROOT_PATH}
export CO_SIM_USE_CASE_ROOT_PATH=${CO_SIM_USE_CASE_ROOT_PATH}
export CO_SIM_MODULES_ROOT_PATH=${CO_SIM_MODULES_ROOT_PATH}
# CO_SIM_ site-packages for PYTHONPATH
export CO_SIM_PYTHONPATH=/home/vagrant/multiscale-cosim/ARBOR-NEST-usecase1:/home/vagrant/multiscale-cosim/site-packages:/home/vagrant/multiscale-cosim/nest-installed/lib/python3.8/site-packages
# adding EBRAINS_*, site-packages to PYTHONPATH (if needed)
PYTHONPATH=${PYTHONPATH:-$CO_SIM_PYTHONPATH}
echo $PYTHONPATH | grep /home/vagrant/multiscale-cosim/site-packages 1>/dev/null 2>&1
[ $? -eq 0 ] || PYTHONPATH=${CO_SIM_PYTHONPATH}:$PYTHONPATH
export PYTHONPATH=${PYTHONPATH}
# making nest binary reachable
# __ric__? PATH=${PATH:-/home/vagrant/multiscale-cosim/nest/bin}
echo $PATH | grep /home/vagrant/multiscale-cosim/nest/bin 1>/dev/null 2>&1
[ $? -eq 0 ] || export PATH=/home/vagrant/multiscale-cosim/nest/bin:${PATH}
python3 ${CO_SIM_USE_CASE_ROOT_PATH}/main.py \
    --global-settings ${CO_SIM_MODULES_ROOT_PATH}/EBRAINS_WorkflowConfigurations/general/global_settings.xml \
    --action-plan \${CO_SIM_MODULES_ROOT_PATH}/userland/configs/local/plans/cosim_alpha_brunel_local.xml
