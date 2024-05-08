#!/usr/bin/bash 

#author: sebinjohn@usf.edu
#semi-automatic fvcom installation for OCL students 
#tetsted in Stampede3 HPC https://tacc.utexas.edu/systems/stampede3/on 2024 April 26 (Rocky Linux,RHEL)
#tetsted in USF HPC Cluster https://wiki.rc.usf.edu/index.php/Connecting_To_SC on 2024 April 26 (Red Hat Enterprise Linux Server 7.4)
# USF HPC cluster: load the intel compliler(module load compilers/intel/2020_cluster_xe)
#tested in Frontera HPC https://tacc.utexas.edu/systems/frontera/ on 2024 April 26 (CentOS Linux 7)
# tested by Orion, Ocl, USF 2024 April 2
#recompiled in sebin-ocg12 linux ubuntu tower server in 2024 March 28
# updated for the FVCOM4.4.2 @ OCL in 2023 January 12
# first version of this script created during My Phd @ NIO with FVCOM3.0, 4.1,4.4.1

echo '---------------------------------------------------------'
echo 'FVCOM  installation @ OCL, USF Work station- With intel compiler'
echo '---------------------------------------------------------'

echo '*********Intel parallel compiler checking ********'

# Find the location of mpicc
mpicc_location=$(which mpicc)

# Check if mpicc is available
if [ -z "$mpicc_location" ]; then
    echo "Error: mpicc compiler not found."
    exit 1
fi

# If mpicc is found, echo its location
echo "mpicc compiler location: $mpicc_location"

# Find the location of mpicc
mpif90_location=$(which mpif90)

# Check if mpicc is available
if [ -z "$mpif90_location" ]; then
    echo "Error: mpicc compiler not found."
    exit 1
fi

# If mpicc is found, echo its location
echo "mpif90 compiler location: $mpif90_location"

echo '*********Intel parallel compiler checking ********'
tar xzf FVCOM_source_4.4.2.tgz 
fvcom_dir=$PWD/FVCOM_source
libs_dir=$fvcom_dir/libs
echo '---------------------------------------------------------'
echo 'Your FVCOM installation directory'
echo '---------------------------------------------------------'

echo $fvcom_dir
chmod -R 775 $fvcom_dir
chmod -R 775 $libs_dir

sed "51s#\(.\{12\}\).*#TOPDIR = $fvcom_dir#" $fvcom_dir/make.inc_seb_linux_ocg12 > $fvcom_dir/make.inc
#sed "51s#\(.\{12\}\).*#TOPDIR = $fvcom_dir \1#" $fvcom_dir/make.inc_seb_linux > $fvcom_dir/make.inc
cd $libs_dir
echo 'Curret working dir'$pwd
echo "deleeting old directiories in lib"
rm -rf fproj julian proj netcdf metis install

echo '---------------------------------------------------------'
echo 'fvcom libs installation start'
echo '---------------------------------------------------------'

make clean
make

echo '---------------------------------------------------------'
echo 'fvcom libs installation sucesss'
echo '---------------------------------------------------------'

echo '---------------------------------------------------------'
echo 'fvcom installation start'
echo '---------------------------------------------------------'


cd $fvcom_dir

make clean
make


echo '---------------------------------------------------------'
echo 'fvcom installation sucesss'
echo '---------------------------------------------------------'

export LD_LIBRARY_PATH=$fvcom_dir/libs/install/lib:$LD_LIBRARY_PATH

./fvcom
