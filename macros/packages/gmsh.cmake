macro(build_gmsh)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_GMSH "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_GMSH_VERSION)
    set(BUILD_GMSH_VERSION "4.8.4")
  endif()
  
  string(CONCAT BUILD_GMSH_URL "http://gmsh.info/src/gmsh-"
  ${BUILD_GMSH_VERSION} "-source.tgz")
  
  string(REPLACE "." "_" TMPVER ${BUILD_GMSH_VERSION})
  string(CONCAT BUILD_GMSH_REPO "https://gitlab.onelab.info/gmsh/" "gmsh.git")
  string(CONCAT BUILD_GMSH_TAG "gmsh_" ${TMPVER})
  unset(TMPVER)
  
  build_cmake_git_subproject(
    NAME gmsh
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    VERSION ${BUILD_GMSH_VERSION}
    GIT_REPO ${BUILD_GMSH_REPO}
    GIT_TAG ${BUILD_GMSH_TAG}
    BUILD_ARGS
      -D ENABLE_MPI:BOOL=OFF
      -D CMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON
      -D ENABLE_PETSC:BOOL=OFF
  )
  

  list(APPEND DEALII_DEPENDENCIES "gmsh")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_GMSH:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D GMSH_DIR=${gmsh_DIR}")
endmacro()