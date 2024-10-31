# http://compute1-exec-59.ris.wustl.edu:8787/


#!/bin/bash


export LSF_DOCKER_PORTS='8787:8787'
export THPC_BUILD=2023.06
export THPC_CONTAINER_OS=linux
export LSF_DOCKER_VOLUMES='/opt/thpc:/opt/thpc /home/l.ronghan:/home/l.ronghan /storage1/fs1/yeli/Active:/storage1/fs1/yeli/Active /scratch1/fs1/yeli:/scratch1/fs1/yeli'


# bsub -Is -q general-interactive -G compute-yeli -n 8 -R 'select[port8787=1] rusage[mem=100GB] span[hosts=1]' -a 'docker(ghcr.io/washu-it-ris/ris-thpc:runtime)' /bin/bash << 'EOF'
bsub -Is -q subscription -G compute-yeli-t2 -sla yeli-t2 -n 8 -R 'select[port8787=1] rusage[mem=256GB] span[hosts=1]' -a 'docker(ghcr.io/washu-it-ris/ris-thpc:runtime)' /bin/bash << 'EOF'

module load RStudio-Server
rstudio-server start &
EOF
