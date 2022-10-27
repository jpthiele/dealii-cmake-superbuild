macro(build_p4est)

set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_P4EST "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_P4EST_VERSION)
    set(BUILD_P4EST_VERSION "2.3.2")
  endif()
  
  
  set(BUILD_P4EST_MD5 "")
  if (BUILD_P4EST_VERSION STREQUAL "2.3.2")
    set(BUILD_P4EST_MD5 0ea6e4806b6950ad64e62a5607bfabbb)
  endif()
  string(CONCAT BUILD_P4EST_URL "https://p4est.github.io/release/p4est-"
  ${BUILD_P4EST_VERSION} ".tar.gz")
  
  
      
  if (NOT DEFINED BUILD_P4EST_VERSION)  
    set(P4EST_INSTALL_PATH ${CMAKE_INSTALL_PREFIX})
  else()
    set(P4EST_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/p4est-${BUILD_P4EST_VERSION})
  endif()
  
  

  set(p4est_fast_flags --prefix=${P4EST_INSTALL_PATH}/FAST CFLAGS=-O2)
  set(p4est_debug_flags --prefix=${P4EST_INSTALL_PATH}/DEBUG CFLAGS=-O0)
  set(p4est_enable_flags --enable-shared --disable-vtk-binary --without-blas --enable-mpi)
  set(p4est_compile_flags CPPFLAGS=-DSC_LOG_PRIORITY=SC_LP_ESSENTIAL F77=mpif77 )


  if(DOWNLOAD_ONLY)
    ExternalProject_Add(
      p4est
      URL ${BUILD_P4EST_URL}
      URL_MD5 ${BUILD_P4EST_MD5}
      UPDATE_DISCONNECTED true  # need this to avoid constant rebuild
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
      CONFIGURE_COMMAND true
      BUILD_COMMAND true
      INSTALL_COMMAND true
    )
  else()
    find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)
    ExternalProject_Add(
      p4est
      URL ${BUILD_P4EST_URL}
      URL_MD5 ${BUILD_P4EST_MD5}
      UPDATE_DISCONNECTED true  # need this to avoid constant rebuild
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
      CONFIGURE_COMMAND ${CMAKE_BINARY_DIR}/p4est-prefix/src/p4est/configure ${p4est_enable_flags} ${p4est_fast_flags} ${p4est_compile_flags}
      BUILD_COMMAND ${MAKE_EXECUTABLE} -C sc 
      COMMAND make 
      INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    )

    ExternalProject_Get_Property(p4est SOURCE_DIR)
    
    ExternalProject_Add_Step(
      p4est p4est_add_debug_build_path
      COMMAND mkdir -p DEBUG
      WORKING_DIRECTORY ${SOURCE_DIR}
      DEPENDEES install
    )

    ExternalProject_Add_Step(
      p4est p4est_config_debug
      COMMAND ${CMAKE_BINARY_DIR}/p4est-prefix/src/p4est/configure --enable-debug ${p4est_enable_flags} ${p4est_debug_flags} ${p4est_compile_flags}
      WORKING_DIRECTORY ${SOURCE_DIR}/DEBUG
      DEPENDEES p4est_add_debug_build_path
    )

    ExternalProject_Add_Step(
      p4est p4est_makesc_debug
      COMMAND make -C sc
      WORKING_DIRECTORY ${SOURCE_DIR}/DEBUG
      DEPENDEES p4est_config_debug
    )
    ExternalProject_Add_Step(
      p4est p4est_make_debug
      COMMAND make 
      WORKING_DIRECTORY ${SOURCE_DIR}/DEBUG
      DEPENDEES p4est_makesc_debug
    )
    ExternalProject_Add_Step(
      p4est p4est_install_debug
      COMMAND make 
      WORKING_DIRECTORY ${SOURCE_DIR}/DEBUG
      DEPENDEES p4est_make_debug
    )
  endif()

  list(APPEND DEALII_DEPENDENCIES "p4est")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_P4EST:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D P4EST_DIR=${P4EST_INSTALL_PATH}")
endmacro()
