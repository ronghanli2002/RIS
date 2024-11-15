# How to use Rstudio on RIS

## Use Rstudio on Open Ondemand
URL: `https://ood.ris.wustl.edu/pun/sys/dashboard/batch_connect/sessions`
Mounts: `/storage1/fs1/yeli/Active:/storage1/fs1/yeli/Active /scratch1/fs1/yeli:/scratch1/fs1/yeli`
Job Group: `/l.ronghan/ood`

## Use Rstudio docker image
You could refer to `https://docs.ris.wustl.edu/doc/compute/recipes/tools/ris-rstudio.html?highlight=rprofile` to get more information.
### Initial setup
Create a R library in the storage1 directory.
```
mkdir /storage1/fs1/${STORAGE_ALLOCATION}/Active/R_libraries/
```

Create a .Rprofile in your home directory:
```
touch ~/.Rprofile
```

Backup an existing .Rprofile file if you have one.
```
mv ~/.Rprofile ~/.Rprofile.bak
```

Create a new .Rprofile file to store your additional R packages in storage1.

```
cat <<EOF > $HOME/.Rprofile
vals <- paste('/storage1/fs1/${STORAGE_ALLOCATION}/Active/R_libraries/',paste(R.version$major,R.version$minor,sep="."),sep="")
for (devlib in vals) {
    if (!file.exists(devlib))
    dir.create(devlib)
x <- .libPaths()
x <- .libPaths(c(devlib,x))
}
rm(x,vals)
EOF
```

Create this shell script in your storage1 directory, named `run_rscript.sh`:
```
# http://compute1-exec-184.ris.wustl.edu:8787/

#!/bin/bash


export LSF_DOCKER_PORTS='8787:8787'
export THPC_BUILD=2023.06
export THPC_CONTAINER_OS=linux
export LSF_DOCKER_VOLUMES='/opt/thpc:/opt/thpc /home/l.ronghan:/home/l.ronghan /storage1/fs1/yeli/Active:/storage1/fs1/yeli/Active /scratch1/fs1/yeli:/scratch1/fs1/yeli'

bsub -Is -q subscription -G compute-yeli-t2 -sla yeli-t2 -n 8 -R 'select[port8787=1] rusage[mem=256GB] span[hosts=1]' -a 'docker(ghcr.io/washu-it-ris/ris-thpc:runtime)' /bin/bash << 'EOF'

module load RStudio-Server
rstudio-server start &
EOF
```
Run this command line in the terminal:
```
bash run_rscript.sh
```
You will get a port. for example it gives you port 184. Then open this url:
```
http://compute1-exec-184.ris.wustl.edu:8787/
```

Then you could use Rstudio on your own browser.
