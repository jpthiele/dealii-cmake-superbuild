macro(build_assimp)
  set(oneValueArgs VERSION)
  cmake_parse_arguments(BUILD_ASSIMP "" "${oneValueArgs}" "" ${ARGN})
  
  if (NOT BUILD_ASSIMP_VERSION)
    set(BUILD_ASSIMP_VERSION "4.1.0")
  endif()
  
  string(CONCAT BUILD_ASSIMP_REPO "https://github.com/assimp/" "assimp.git")
  string(CONCAT BUILD_ASSIMP_TAG "v" ${BUILD_ASSIMP_VERSION})
  
  build_cmake_git_subproject(
    NAME assimp
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    VERSION ${BUILD_ASSIMP_VERSION}
    GIT_REPO ${BUILD_ASSIMP_REPO}
    GIT_TAG ${BUILD_ASSIMP_TAG}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON
  )

  list(APPEND DEALII_DEPENDENCIES "assimp")
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_ASSIMP:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D ASSIMP_DIR=${assimp_DIR}")
endmacro()