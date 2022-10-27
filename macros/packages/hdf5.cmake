macro(build_hdf5)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_HDF5 "" "${oneValueArgs}" "" ${ARGN})

  if (NOT BUILD_HDF5_VERSION)
    set(BUILD_HDF5_VERSION "1.10.7")
  endif()
    
  string(REPLACE "." ";" BUILD_HDF5_VERSION_LIST ${BUILD_HDF5_VERSION})
  
  list(GET BUILD_HDF5_VERSION_LIST 0 BUILD_HDF5_MAJOR)
  list(GET BUILD_HDF5_VERSION_LIST 1 BUILD_HDF5_MINOR)
  list(GET BUILD_HDF5_VERSION_LIST 2 BUILD_HDF5_PATCH)
  
  string(CONCAT BUILD_HDF5_REPO "https://github.com/HDFGroup/" "hdf5.git")
  string(CONCAT BUILD_HDF5_TAG "hdf5-" ${BUILD_HDF5_MAJOR} "_" ${BUILD_HDF5_MINOR} "_" ${BUILD_HDF5_PATCH})
    
  build_autotools_git_subproject(
    NAME hdf5
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    VERSION ${BUILD_HDF5_VERSION}
    GIT_REPO ${BUILD_HDF5_REPO}
    GIT_TAG ${BUILD_HDF5_TAG}
    CONFIGURE_FLAGS --enable-shared --enable-parallel
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
  )
  
  list(APPEND DEALII_DEPENDENCIES "hdf5")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_HDF5:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D HDF5_DIR=${hdf5_DIR}")
endmacro()