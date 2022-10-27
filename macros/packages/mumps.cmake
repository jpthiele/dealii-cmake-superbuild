macro(build_mumps)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_MUMPS "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_MUMPS_VERSION)
    set(BUILD_MUMPS_VERSION "5.4.0.5")
  endif()
  
  if (BLAS_TYPE STREQUAL "IntelMKL")
    set(MUMPS_BLAS_OPTS -D MKLROOT=${MKL_ROOT})
  elseif( BLAS_TYPE STREQUAL "OpenBLAS")
    set(MUMPS_BLAS_OPTS 
      -D pc_blas_LIBRARY_DIRS=${BLAS_DIR}/lib
      -D pc_lapack_LIBRARY_DIRS=${BLAS_DIR}/lib
      -D pc_scalapack_LIBRARY_DIRS=${ScaLAPACK_DIR}/lib
    )
  endif()
  
  string(CONCAT BUILD_MUMPS_REPO "https://github.com/scivision/" "mumps.git")
  string(CONCAT BUILD_MUMPS_TAG "v" ${BUILD_MUMPS_VERSION})

  set(BUILD_MUMPS_C_FLAGS "-g -fPIC -O3")
  set(BUILD_MUMPS_F_FLAGS "-fallow-argument-mismatch")
  
  if(DOWNLOAD_ONLY) 
    string(REPLACE "." ";" TMP_LIST ${BUILD_MUMPS_VERSION})
    list(POP_BACK TMP_LIST)
    list(POP_FRONT TMP_LIST TMPVAR)
    set(TMP_VERSION ${TMPVAR})
    list(POP_FRONT TMP_LIST TMPVAR)
    string(CONCAT TMP_VERSION ${TMP_VERSION} "." ${TMPVAR})
    list(POP_FRONT TMP_LIST TMPVAR)
    string(CONCAT TMP_VERSION ${TMP_VERSION} "." ${TMPVAR})
    unset(TMP_LIST)
    unset(TMPVAR)
    # This package uses FetchContent internally 
    # so we need to download and extract a corresponding tar file
    string(CONCAT MUMPS_FILENAME "MUMPS_" ${TMP_VERSION} ".tar.gz")
    string(CONCAT MUMPS_SRC_URL "http://graal.ens-lyon.fr/MUMPS/" ${MUMPS_FILENAME})
    unset(TMP_VERSION)
    file(DOWNLOAD ${MUMPS_SRC_URL} ${CMAKE_BINARY_DIR}/MUMPS/build/_deps/mumps-subbuild/mumps-populate-prefix/src/${MUMPS_FILENAME})
  endif()
  build_cmake_git_subproject(
    NAME MUMPS
    VERSION ${BUILD_MUMPS_VERSION}
    GIT_REPO ${BUILD_MUMPS_REPO}
    GIT_TAG ${BUILD_MUMPS_TAG}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D metis=true
      -D METIS_LIBRARY=${METIS_LIB}
      -D METIS_INCLUDE_DIR=${ParMETIS_INCLUDES}
      -D PARMETIS_LIBRARY=${ParMETIS_LIB}
      ${MUMPS_BLAS_OPTS}
      -D CMAKE_Fortran_COMPILER=mpif90
      -D CMAKE_C_COMPILER=${CMAKE_MPI_C_COMPILER}
      -D CMAKE_CXX_COMPILER=${CMAKE_MPI_CXX_COMPILER}
      -D CMAKE_C_FLAGS:STRING=${BUILD_MUMPS_C_FLAGS}
      -D CMAKE_Fortran_FLAGS:STRING=${BUILD_MUMPS_F_FLAGS}
      -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
      -D BUILD_SHARED_LIBS:BOOL=ON
      -D CMAKE_POLICY_DEFAULT_CMP0135:STRING=NEW
    DEPENDS_ON ${BLAS_PROJECT_NAME} ${ScaLAPACK_NAME} ParMETIS
  )

  list(APPEND TRILINOS_DEPENDENCIES "MUMPS")
  list(APPEND TRILINOS_CONFOPTS "-D TPL_ENABLE_MUMPS:BOOL=ON")
  list(APPEND TRILINOS_CONFOPTS "-D MUMPS_LIBRARY_DIRS:PATH=${MUMPS_DIR}/lib")
  list(APPEND TRILINOS_CONFOPTS "-D MUMPS_INCLUDE_DIRS:PATH=${MUMPS_DIR}/include")
endmacro()