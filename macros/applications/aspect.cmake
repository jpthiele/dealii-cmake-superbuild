macro(build_aspect)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_ASPECT "" "${oneValueArgs}" "" ${ARGN})

  if (NOT BUILD_ASPECT_VERSION)
    set(BUILD_ASPECT_VERSION "2.4.0")
  endif()
  
  string(CONCAT BUILD_ASPECT_REPO "https://github.com/geodynamics/" "aspect.git")
  string(CONCAT BUILD_ASPECT_TAG "v" ${BUILD_ASPECT_VERSION})
    
   build_cmake_git_subproject(
    NAME ASPECT
    VERSION ${BUILD_ASPECT_VERSION}
    GIT_REPO ${BUILD_ASPECT_REPO}
    GIT_TAG ${BUILD_ASPECT_TAG}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON
      -D DEAL_II_DIR=${MAIN_DEAL_II_DIR}
#       -D CMAKE_C_COMPILER=${CMAKE_MPI_C_COMPILER}
#       -D CMAKE_Fortran_COMPILER=${CMAKE_MPI_FC_COMPILER}
#       -D CMAKE_CXX_COMPILER=${CMAKE_MPI_CXX_COMPILER}
    DEPENDS_ON ${MAIN_DEAL_II}
  )
    
  
endmacro()