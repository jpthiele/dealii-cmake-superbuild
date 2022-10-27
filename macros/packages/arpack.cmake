macro(build_arpack)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_ARPACK "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_ARPACK_VERSION)
    set(BUILD_ARPACK_VERSION "3.8.0")
  endif()
  
  string(CONCAT BUILD_ARPACK_REPO "https://github.com/opencollab/" "arpack-ng.git")
  
  build_cmake_git_subproject(
    NAME arpack
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    VERSION ${BUILD_ARPACK_VERSION}
    GIT_REPO ${BUILD_ARPACK_REPO}
    GIT_TAG ${BUILD_ARPACK_VERSION}
    BUILD_ARGS
      -D EXAMPLES:BOOL=OFF 
      -D MPI:BOOL=ON 
      -D BUILD_SHARED_LIBS:BOOL=ON
  )

  list(APPEND DEALII_DEPENDENCIES "arpack")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_ARPACK:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_ARPACK_WITH_PARPACK:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D ARPACK_DIR=${arpack_DIR}")
endmacro()