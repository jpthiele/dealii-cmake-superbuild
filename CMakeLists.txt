cmake_minimum_required(VERSION 3.19) #minimum 3.19 for MUMPS

project(dealii_superbuild VERSION 1.0.0 LANGUAGES Fortran C CXX)
################################################################################
##Policies includes and default variables                                     ##
################################################################################
cmake_policy(SET CMP0057 NEW)
cmake_policy(SET CMP0135 NEW) 

include(ExternalProject)
include(FetchContent)
include(GNUInstallDirs)
include(ProcessorCount)
add_subdirectory(macros)
#set Install prefix to install subdirectory of build dir.
if(NOT CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX
      "${CMAKE_BINARY_DIR}/install"
      CACHE STRING "Final install location." FORCE)
endif()
# If NUM_BUILD_JOBS not specified grab number of processors on machine
# and leave 2 for tasks other than building. 
# If this slows your machine too much try even fewer.
ProcessorCount(PROCESSOR_COUNT)
MATH(EXPR PROCESSOR_COUNT "${PROCESSOR_COUNT}-2")
if(PROCESSOR_COUNT LESS 1)
  set(PROCESSOR_COUNT 1)
endif()

set(NUM_BUILD_JOBS ${PROCESSOR_COUNT} CACHE STRING 
      "Number of build jobs '-j <n>'")

set(DEFAULT_BUILD_COMMAND cmake --build . --config release -j ${NUM_BUILD_JOBS})

################################################################################
## USER SPECIFIED THIRD PARTY LIBRARIES                                       ##
################################################################################
#Only download and extract (needed for cluster machines w.o. web access)
set(DOWNLOAD_ONLY TRUE) 
set(INSTALL_TPLS "") #For safety reset this variable
list(APPEND INSTALL_TPLS "hdf5")

##GEOMETRY/CAD PACKAGES
list(APPEND INSTALL_TPLS "opencascade")
list(APPEND INSTALL_TPLS "gmsh") #
list(APPEND INSTALL_TPLS "assimp") # 

##Parallel Tools
list(APPEND INSTALL_TPLS "p4est")
list(APPEND INSTALL_TPLS "parmetis") #
 
##BLAS/LAPACK/ScaLAPACK Stack gets auto determined 
list(APPEND INSTALL_TPLS "some_blas") #See README.md for further details

##Solvers/Linear Algebra
list(APPEND INSTALL_TPLS "superlu_dist") 
list(APPEND INSTALL_TPLS "mumps")
list(APPEND INSTALL_TPLS "ginkgo") #
# ##Parallel LA Packages
# list(APPEND INSTALL_TPLS "trilinos")

##Advanced Maths packages
list(APPEND INSTALL_TPLS "adolc") #
list(APPEND INSTALL_TPLS "arpack") #
list(APPEND INSTALL_TPLS "sundials") # 
list(APPEND INSTALL_TPLS "symengine")

################################################################################
## ROUTINES FOR CHECKING AND BUILDING DEPENDENCIES OF DEAL_II                 ##
################################################################################
#Fetch cpu info cmake project and use get cpu info from there
message("checking for cpu vendor")
FetchContent_Declare(
  CmakeCpuDetection
  GIT_REPOSITORY https://github.com/scivision/cmake-cpu-detect.git
  GIT_TAG 2e4e56500383e5483f64deeb48e1c9935d8975a0
)
FetchContent_MakeAvailable(CmakeCpuDetection)
GetHostCPUInfo()
# set INSTALL_<pkgname> to TRUE for all packages in INSTALL_TPLS
# and check for package dependencies
set_packages_and_dependencies()

#this routine calls all build_<pkgname>() enabled by user or dependency
build_packages()
 
###################################################################################
## DEALII ITSELF                                                                 ##
###################################################################################
build_dealii(VERSION 9.4.0)

print_config_summary()




