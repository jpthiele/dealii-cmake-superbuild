macro(build_parmetis)
 set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_PARMETIS "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_PARMETIS_VERSION)
    set(BUILD_PARMETIS_VERSION "4.0.3")
  endif()
  
  set(BUILD_PARMETIS_MD5 "")
  if (BUILD_PARMETIS_VERSION STREQUAL "4.0.3")
    set(BUILD_PARMETIS_MD5 f69c479586bf6bb7aff6a9bc0c739628)
  endif()
  string(CONCAT BUILD_PARMETIS_URL "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-"
  ${BUILD_PARMETIS_VERSION} ".tar.gz")
  
  setup_subproject_path_vars(ParMetis)    
    
  if (NOT DEFINED BUILD_PARMETIS_VERSION)  
    set(SUBPROJECT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX})
  else()
    set(SUBPROJECT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/ParMETIS-${BUILD_PARMETIS_VERSION})
  endif()
  if(DOWNLOAD_ONLY)
    ExternalProject_Add(ParMETIS
      URL ${BUILD_PARMETIS_URL}
      URL_MD5 ${BUILD_PARMETIS_MD5}
      UPDATE_DISCONNECTED true
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
      CONFIGURE_HANDLED_BY_BUILD true
      CONFIGURE_COMMAND true
      BUILD_COMMAND true
      INSTALL_COMMAND true
      STAMP_DIR ${SUBPROJECT_STAMP_PATH}
      SOURCE_DIR ${SUBPROJECT_SOURCE_PATH}
      BINARY_DIR ${SUBPROJECT_SOURCE_PATH}
      INSTALL_DIR ${SUBPROJECT_INSTALL_PATH}  
    )
  else()
    SET(METIS_CONFOPTS 
          -D CMAKE_VERBOSE_MAKEFILE=1
          -D GKLIB_PATH=GKlib
          -D CMAKE_INSTALL_PREFIX=${SUBPROJECT_INSTALL_PATH}
          -D SHARED=1
          -D CMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    )
    
    SET(PARMETIS_CONFOPTS 
          -D CMAKE_VERBOSE_MAKEFILE=1
          -D GKLIB_PATH=metis/GKlib
          -D METIS_PATH=metis
          -D CMAKE_INSTALL_PREFIX=${SUBPROJECT_INSTALL_PATH}
          -D SHARED=1
          -D CMAKE_C_COMPILER=${CMAKE_MPI_C_COMPILER}
    )
    #Does not work as cmake_subproject as the metis and GKlib paths have to be specified in a weird way
    
    ExternalProject_Add(ParMETIS
      URL ${BUILD_PARMETIS_URL}
      URL_MD5 ${BUILD_PARMETIS_MD5}
      UPDATE_DISCONNECTED true
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
      CONFIGURE_HANDLED_BY_BUILD true
      CONFIGURE_COMMAND cmake -S. -Bbuild ${PARMETIS_CONFOPTS}
      BUILD_COMMAND cmake --build build
      INSTALL_COMMAND cmake --install build
      STAMP_DIR ${SUBPROJECT_STAMP_PATH}
      SOURCE_DIR ${SUBPROJECT_SOURCE_PATH}
      BINARY_DIR ${SUBPROJECT_SOURCE_PATH}
      INSTALL_DIR ${SUBPROJECT_INSTALL_PATH}  
    )
    #We need to add the following steps to also build metis 
    ExternalProject_Add_Step(
      ParMETIS configure_metis
      WORKING_DIRECTORY ${SUBPROJECT_SOURCE_PATH}/metis
      COMMAND cmake -S. -Bbuild ${METIS_CONFOPTS}
      DEPENDEES patch
    )
    
    ExternalProject_Add_Step(
      ParMETIS build_metis
      WORKING_DIRECTORY ${SUBPROJECT_SOURCE_PATH}/metis
      COMMAND cmake --build build
      DEPENDEES configure_metis
    )
    
    ExternalProject_Add_Step(
      ParMETIS install_metis
      WORKING_DIRECTORY ${SUBPROJECT_SOURCE_PATH}/metis
      COMMAND cmake --install build
      DEPENDEES build_metis
      DEPENDERS configure
    )
  
  endif()
  
  set(ParMETIS_DIR ${SUBPROJECT_INSTALL_PATH})
  set(ParMETIS_LIB ${ParMETIS_DIR}/lib/libparmetis${CMAKE_SHARED_LIBRARY_SUFFIX})
  set(METIS_LIB ${ParMETIS_DIR}/lib/libmetis${CMAKE_SHARED_LIBRARY_SUFFIX})
  set(ParMETIS_INCLUDES ${ParMETIS_DIR}/include)
  list(APPEND DEALII_DEPENDENCIES "ParMETIS")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_METIS:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D METIS_DIR=${ParMETIS_DIR}")
  
endmacro()

