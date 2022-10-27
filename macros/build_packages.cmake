macro(build_packages)
  ## go through all bools and build wanted packages
  ## This list sorted by types 
  ## Package A needed for package B should have it's build call first
  
  if(${INSTALL_hdf5})
    build_hdf5()
  endif()
  ##############################################################################
  ##   GEOMETRY/CAD PACKAGES                                                  ##
  ##############################################################################
  if(${INSTALL_opencascade})
    build_opencascade()
  endif()
  
  if(${INSTALL_assimp})
    build_assimp()
  endif()
    
  if(${INSTALL_gmsh})
    build_gmsh()
  endif()
  ##############################################################################
  ##   PARALLEL TOOLS                                                         ##
  ##############################################################################
  if(${INSTALL_parmetis})
    build_parmetis()
  endif()
  
  if(${INSTALL_p4est})
    build_p4est()
  endif()
  ##############################################################################
  ## BLAS/LAPACK/SCALAPACK STACK                                              ##
  ##############################################################################
  if(${INSTALL_openblas})
    build_openblas()
  endif()
  if(${INSTALL_scalapack})
    build_scalapack()
  endif()
  
  ##############################################################################
  ##   SOLVERS AND PARALLEL LA                                                ##
  ##############################################################################
  if(${INSTALL_superlu_dist})
    build_superlu_dist()
  endif()
  if(${INSTALL_mumps})
    build_mumps()
  endif()
  if(${INSTALL_ginkgo})
    build_ginkgo()
  endif()  
  if(${INSTALL_trilinos})
    build_trilinos()
  endif()
    
  ##############################################################################
  ##   ADVANCED MATHS PACKAGES                                                ##
  ##############################################################################
  if(${INSTALL_adolc})
    build_adolc()
  endif()
  if(${INSTALL_arpack})
    build_arpack()
  endif()
  if(${INSTALL_symengine})
    build_symengine()
  endif()
  if(${INSTALL_sundials})
    build_sundials()
  endif()
endmacro()