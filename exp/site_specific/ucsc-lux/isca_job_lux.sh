#!/bin/bash
#SBATCH --job-name=held_suarez_test_case      # Job name
#SBATCH --partition=defq             # queue for job submission
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=nfeldl@ucsc.edu   # Where to send mail
#SBATCH --ntasks=16                  # Number of MPI ranks
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks-per-node=16         # How many tasks on each node
#SBATCH --time=01:00:00              # Time limit hrs:min:sec
#SBATCH --output=mpi_test_%j.log     # Standard output and error log

pwd; hostname; date

echo "Running program on $SLURM_JOB_NUM_NODES nodes with $SLURM_NTASKS total tasks, with each node getting $SLURM_NTASKS_PER_NODE running on cores."

source $HOME/.bashrc
source $GFDL_BASE/src/extra/env/ucsc-lux-gfortran
source $HOME/venvs/Isca/bin/activate

python $GFDL_BASE/exp/test_cases/held_suarez/held_suarez_test_case.py

date
