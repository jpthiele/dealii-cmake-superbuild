macro(append_cmake_prefix_path)
  list(APPEND CMAKE_PREFIX_PATH ${ARGN})
  string(REPLACE ";" "|" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
endmacro()