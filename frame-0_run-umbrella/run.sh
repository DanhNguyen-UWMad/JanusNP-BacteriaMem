#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --gres=gpu:h100:1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=gpu-h100
#SBATCH --account=nawimem
#SBATCH --cpus-per-task=52
#SBATCH --job-name=Curve_90
#SBATCH --mem=160000M
#SBATCH --output=std.%j.out
#SBATCH --error=std.%j.err
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jzhou525@wisc.edu

export MPICH_GPU_SUPPORT_ENABLED=1
export CUDA_VISIBLE_DEVICES=0


#module purge
module load cmake/3.27.9 cuda/12.3 openmpi/4.1.6-gc gcc/10.3.0

# Source to gmx on Kestrel
source /home/dtnguyen28/SOFTWARE/GROMACS/gromacs-2024.2/bin/GMXRC

# Short equilibration
gmx grompp -f npt_umbrella.mdp -c conf0.gro -r conf0.gro -p system.top -o npt0.tpr  -n index.ndx -maxwarn 11
gmx mdrun -v -ntomp 52 -deffnm npt0 

# Umbrella run
gmx grompp -f md_umbrella.mdp -c npt0.gro -r npt0.gro -t npt0.cpt -p system.top -o umbrella0.tpr -n index.ndx -maxwarn 11
gmx mdrun -v -ntomp 52 -deffnm umbrella0

echo "Job is done, thanks Dan!"
