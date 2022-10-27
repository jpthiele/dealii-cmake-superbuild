macro(build_symengine)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_SYMENGINE "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_SYMENGINE_VERSION)
    set(BUILD_SYMENGINE_VERSION "0.7.0")
  endif()
  
  string(CONCAT BUILD_SYMENGINE_REPO "https://github.com/symengine/" "symengine.git")
  string(CONCAT BUILD_SYMENGINE_TAG "v" ${BUILD_SYMENGINE_VERSION})
  
  build_cmake_git_subproject(
    NAME symengine
    VERSION ${BUILD_SYMENGINE_VERSION}
    GIT_REPO ${BUILD_SYMENGINE_REPO}
    GIT_TAG ${BUILD_SYMENGINE_TAG}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON
      -D BUILD_TEST:BOOL=OFF
      -D BUILD_BENCHMARKS:BOOL=OFF
  )

  list(APPEND DEALII_DEPENDENCIES "symengine")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_SYMENGINE:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D SYMENGINE_DIR=${symengine_DIR}")
endmacro()