macro(build_adolc)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_ADOLC "" "${oneValueArgs}" "" ${ARGN})

  if (NOT BUILD_ADOLC_VERSION)
    set(BUILD_ADOLC_VERSION "2.7.2")
  endif()
  
  string(CONCAT BUILD_ADOLC_REPO "https://github.com/coin-or/" "ADOL-C.git")
  string(CONCAT BUILD_ADOLC_TAG "releases/" ${BUILD_ADOLC_VERSION})
    
  build_autotools_git_subproject(
    NAME adolc
    VERSION ${BUILD_ADOLC_VERSION}
    GIT_REPO ${BUILD_ADOLC_REPO}
    GIT_TAG ${BUILD_ADOLC_TAG}
    CONFIGURE_FLAGS --with-boost=no
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
  )
  
  list(APPEND DEALII_DEPENDENCIES "adolc")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_ADOLC:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D ADOLC_DIR=${adolc_DIR}")
endmacro()