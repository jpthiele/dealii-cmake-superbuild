macro(build_opencascade)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_OCE "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_OCE_VERSION)
    set(BUILD_OCE_VERSION "0.18.3")
  endif()
  
  string(CONCAT BUILD_OCE_REPO "https://github.com/tpaviot/" "oce.git")
  string(CONCAT BUILD_OCE_TAG "OCE-" ${BUILD_OCE_VERSION})
  
  build_cmake_git_subproject(
      NAME OCE
      VERSION ${BUILD_OCE_VERSION}
      GIT_REPO ${BUILD_OCE_REPO}
      GIT_TAG ${BUILD_OCE_TAG}
      DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
      BUILD_ARGS
        -D CMAKE_BUILD_TYPE=Release
        -D OCE_VISUALISATION:BOOL=OFF 
        -D OCE_DISABLE_TKSERVICE_FONT:BOOL=ON
        -D OCE_DATAEXCHANGE:BOOL=ON
        -D OCE_OCAF:BOOL=OFF
        -D OCE_DISABLE_X11:BOOL=ON
        -D OCE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/OCE-${BUILD_OCE_VERSION}
  )
  list(APPEND DEALII_DEPENDENCIES "OCE")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_OPENCASCADE:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D OPENCASCADE_DIR=${OCE_DIR}")
endmacro()