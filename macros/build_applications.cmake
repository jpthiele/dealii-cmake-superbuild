macro(build_applications)

  ## BETTER: 
  ## Check for further dependencies of deal.II TPLs earlier
  foreach(arg ${INSTALL_APPS})
    set(INSTALL_${arg} TRUE)
  endforeach()
  ## As apps don't depend on each other just build them 
  ## in alphabetical order
  
  if(${INSTALL_aspect})
    build_aspect()
  endif()
endmacro()