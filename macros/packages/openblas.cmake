macro(build_openblas)

  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_OPENBLAS "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_OPENBLAS_VERSION)
    set(BUILD_OPENBLAS_VERSION "0.3.13")
  endif()
  
  
  string(CONCAT BUILD_OPENBLAS_REPO "https://github.com/xianyi/" "OpenBLAS.git")
  string(CONCAT BUILD_OPENBLAS_TAG "v" ${BUILD_OPENBLAS_VERSION})

  build_cmake_git_subproject(
    NAME OpenBLAS
    VERSION ${BUILD_OPENBLAS_VERSION}
    GIT_REPO ${BUILD_OPENBLAS_REPO}
    GIT_TAG ${BUILD_OPENBLAS_TAG}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON
      -D CMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
  )

  set(BLAS_LIBS ${OpenBLAS_DIR}/lib64/libopenblas${CMAKE_SHARED_LIBRARY_SUFFIX})
  set(LAPACK_LIBS ${BLAS_LIBS})
  set(BLAS_DIR ${OpenBLAS_DIR})
  set(BLAS_PROJECT_NAME OpenBLAS)

  list(APPEND DEALII_DEPENDENCIES "OpenBLAS")
  list(APPEND DEALII_CONFOPTS "-D LAPACK_LIBRARIES=${LAPACK_LIBS}")
      
endmacro()