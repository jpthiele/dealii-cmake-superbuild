macro(build_sundials)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_SUNDIALS "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_SUNDIALS_VERSION)
    set(BUILD_SUNDIALS_VERSION "5.7.0")
  endif()
  
  
  string(CONCAT BUILD_SUNDIALS_REPO "https://github.com/LLNL/" "sundials.git")
  string(CONCAT BUILD_SUNDIALS_TAG "v" ${BUILD_SUNDIALS_VERSION})
  
  build_cmake_git_subproject(
    NAME sundials
    VERSION ${BUILD_SUNDIALS_VERSION}
    GIT_REPO ${BUILD_SUNDIALS_REPO}
    GIT_TAG ${BUILD_SUNDIALS_TAG}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON 
      -D ENABLE_MPI:BOOL=ON
  )

endmacro()