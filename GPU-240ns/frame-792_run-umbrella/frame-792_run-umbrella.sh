#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0-10:00:00
#SBATCH --gres=gpu:1
#SBATCH --job-name=PMF_Vesicle
#SBATCH --account=nawimem
#SBATCH --error=%x-%j.err
#SBATCH --output=%x-%j.out

# Now list your module

ml use -a /nopt/nrel/apps/modules/test/modulefiles
ml cuda/11.2 openmpi/4.1.3/gcc-11.3.0-cuda-11.7 gcc/8.4.0 fftw/3.3.8/intel-impi intel-mpi/2020.1.217

# Short equilibration
/home/dtnguyen28/Software/GROMACS/gromacs-2022/bin/gmx_mpi grompp -f npt_umbrella.mdp -c conf792.gro -r conf792.gro -p system.top -o npt792.tpr  -n index.ndx -maxwarn 10
srun /home/dtnguyen28/Software/GROMACS/gromacs-2022/bin/gmx_mpi mdrun -v -deffnm npt792 

# Umbrella run
/home/dtnguyen28/Software/GROMACS/gromacs-2022/bin/gmx_mpi grompp -f md_umbrella.mdp -c npt792.gro -r npt792.gro -t npt792.cpt -p system.top -o umbrella792.tpr -n index.ndx -maxwarn 10
srun /home/dtnguyen28/Software/GROMACS/gromacs-2022/bin/gmx_mpi mdrun -v -deffnm umbrella792

echo "Job is done, thanks Dan!"
