
# Instructions for running Isca on lux at UC Santa Cruz

These instructions are intended to get lux users up-and-running with a simple Held-Suarez test case. They assume you are starting with a default user environment.

## Installing the `isca` python module

To begin you will need a copy of the source code. Either fork the Isca repository to your own github username, or clone directly from the ExeClim group:

```{bash}
$ module load git
$ git clone https://github.com/ExeClim/Isca 
$ cd Isca
```

The python module is found in the `src` directory and can be installed using `pip`. It is recommended that you use a python virtual environment to do this. If you do not already have a place where you store virtual environments, make one now in your home directory.

```{bash}
$ module load python/3.6.7
$ mkdir venvs # create directory to store virtual environments if it does not already exist
$ python -m venv venvs/Isca # create virtual environment 
$ source venvs/Isca/bin/activate
(Isca) $ cd Isca/src/extra/python
(Isca) $ pip install -r requirements.txt

Successfully installed MarkupSafe-1.0 f90nml jinja2-2.9.6 numpy-1.13.3 pandas-0.21.0 python-dateutil-2.6.1 pytz-2017.3 sh-1.12.14 six-1.11.0 xarray-0.9.6
```

Now install the `isca` python module in "development mode." This will allow you, if you wish, to edit the `src/extra/python/isca` files and have those changes be used when you next run an isca script.


```{bash}
(Isca) $ pip install -e .
...
Successfully installed Isca
```

## Compiling for the first time

At UC Santa Cruz, Isca is compiled using
* GNU Compiler Collection (GCC) 4.8.5
* OpenMPI 4.0.1 
* NetCDF C 4.7.3
* NetCDF Fortran 4.5.2
* git 2.23.0

Before Isca is compiled/run, an environment is first configured which loads the specific compilers and libraries necessary to build the code. This is done by setting thet environment variable `GFDL_ENV` in your session. 

For example, on lux, I have the following in my `~/.bashrc`:

```{bash}
# directory of the Isca source code
export GFDL_BASE=/home/nfeldl/Isca
# "environment" configuration for lux
export GFDL_ENV=ucsc-lux-gfortran
# temporary working directory used in running the model
export GFDL_WORK=/home/nfeldl/Isca_work
# directory for storing model output
export GFDL_DATA=/home/nfeldl/Isca_out
```

The value of `GFDL_ENV` corresponds to a file in `src/extra/env` that is sourced before each run or compilation.

For example, on lux, I have the following in `ucsc-lux-gfortran`:

```{bash}
echo loadmodules for UCSC lux

export F90=mpif90
export CC=mpicc
export GFDL_MKMF_TEMPLATE=gfort

module purge

module load python/3.6.7
module load openmpi/4.0.1
module load hdf5_gnu/1.10.6-parallel
module load netcdf-c_gnu/4.7.3
module load netcdf-f_gnu/4.5.2
module load git/2.23.0
module load slurm/18.08.4
```

## Performing a test run of the model 

Once you have installed the `isca` python module you will most likely want to try a compilation and run a simple test case. There are several test cases highlighting features of Isca in the `exp/test_cases` directory.

A good place to start is the famous Held-Suarez dynamical core test case. Take a look at the python file for an idea of how an Isca experiment is constructed and then try to run it.

```{bash}
(Isca) $ cd $GFDL_BASE/exp/test_cases/held_suarez
(Isca) $ python held_suarez_test_case.py
```

The `held_suarez_test_case.py` experiment script will attempt to compile the source code for the dry dynamical core and then run for several iterations.

Once the code has sucessfully compiled, the script will continue on to run the model distributed over some number of cores. Once it completes, netCDF diagnostic files will be saved to `$GFDL_DATA/held_suarez_test_case/run####`.

Once you have an environment file that works for your machine saved in `src/extra/env`, all of the test cases should now compile and run - you are now ready to start running your own experiments!

## Running the model with slurm

To run the model operationally, you will use the slurm workload manager. For example, to execute the Held-Suarez test case on the lux cluster nodes, submit the following script:

```{bash}
(Isca) $ cd $GFDL_BASE/exp/site-specific/ucsc-lux
(Isca) $ sbatch --partition=defq isca_job_lux.sh
```

For more on using slurm, see the [lux documentation](https://lux-ucsc.readthedocs.io/en/latest/using_lux.html#running-jobs)

For more on the spectral dynamical core of the Frierson model, see the [GFDL documentation](https://www.gfdl.noaa.gov/idealized-moist-spectral-atmospheric-model-quickstart/). In particular, note that
> The spectral model decomposes the horizontal grid into latitude bands with each band assigned to a processor. When 2 processors are used it is decomposed into northern and southern hemispheres. The number of processors that may be used is restricted such that lat_max/npes must be a multiple of 2. For example, for t42 resolution there are 64 latitudes so that the choices for npes are 1,2,4,8,16,32.

 
