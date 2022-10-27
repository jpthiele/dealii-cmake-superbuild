#!/bin/bash
#Change BUILD and INSTALL DIRS, or use defaults
DIR_SUFFIX=dealii
BUILD_DIR=$HOME/build/${DIR_SUFFIX}
INSTALL_DIR=$HOME/opt/${DIR_SUFFIX}
cmake \
  -S.. \
  -D CMAKE_C_COMPILER=gcc \
  -D CMAKE_CXX_COMPILER=g++ \
  -D CMAKE_Fortran_COMPILER=gfortran \
  -D CMAKE_MPI_C_COMPILER=mpicc \
  -D CMAKE_MPI_CXX_COMPILER=mpicxx \
  -D CMAKE_MPI_FC_COMPILER=mpif90 \
  -D FORCE_USE_OF_OPENBLAS:BOOL=OFF \
  -B${BUILD_DIR} \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
#   -D BOOST_DIR=<path_to_boost> \

  
