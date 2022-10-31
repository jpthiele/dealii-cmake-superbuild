deal.II cmake superbuild project
================================
This cmake project is designed to download and install all user specified third party libraries (TPLs) 
and use those to build [deal.II](https://www.dealii.org).

For the impatient
-----------------

1) clone this repository and change directory into cmake-dealii-superbuild
2) Edit the following sections of CMakeLists.txt 
    * 'user specified TPLs and apps': comment in/out the corresponding lines for wanted/unwanted TPLs and apps
    * 'dealii itself': Subsequent calls of `build_dealii(VERSION X.Y.Z)` build different versions side-by-side
3) call `cmake -S. -B<build_dir> -D CMAKE_INSTALL_PREFIX=<install_dir>` 
4) Check the output and see if all wanted packages are installed 
5) If yes call `cmake --build <build_dir>`

If the found compilers are not sufficient or not the ones you intend to use you can specify them with 

`-D CMAKE_C_COMPILER=<name/path of C compiler>`

`-D CMAKE_CXX_COMPILER=<name/path of C++ compiler>`

`-D CMAKE_Fortran_COMPILER=<name/path of Fortran compiler>`

The same goes for the MPI compilers which can be set via

`-D CMAKE_MPI_C_COMPILER=<name/path of MPI C compiler>`

`-D CMAKE_MPI_CXX_COMPILER=<name/path of MPI C++ compiler>`

`-D CMAKE_MPI_Fortran_COMPILER=<name/path of MPI Fortran compiler>`

If you have a sufficient preinstalled version of Boost you can also specify `-D BOOST_DIR=<path_to_boost>` 
and it will be handed to deal.II, otherwise the bundled version will be installed.

A general Note/Warning
----------------------
Cmake superbuilds are not too good at registering changes in package code.
So if you plan on working on a TPL and using this to build all depending packages automatically 
this might not work reliably.

BLAS/LAPACK/ScaLAPACK Stack
---------------------------
The project checks the CPU Vendor_ID and IntelMKL is only used if the id matches 'GenuineIntel' 
otherwise linking and using IntelMKL would be a breach of License. 
If you plan on using the resulting packages on other machines without Intel processors you can
set `-D FORCE_USE_OF_OPENBLAS=ON` in the cmake call and OpenBLAS will be installed no matter what.

A future version will also feature AMD optimized versions of Blis, Libflame and ScaLAPACK

A note for Linux users
----------------------
For even more ease of use a bash script for calling cmake with all options (including specific compilers)
is config/do_configure_cmake.sh is supplied. 
By default if will set the following 
* <build_dir> to "~/build/dealii" 
* <install_dir> to "~/opt/dealii"
* sequential compilers to GNU Compiler Collection
* parallel compilers to OpenMPI Compilers
* FORCE_USE_OF_OPENBLAS to OFF

These settings can of course be changed and then the configure stage can be run from the config subdirectory by `./do_configure_cmake.sh`

I want to use different versions of one or more packages or applications, is this possible?
---------------------------------------------------------------------------
Yes this is possible by editing the `build_packages` or `build_applications` macro and changing
the corresponding call from `build_<pkgname>()` to `build_<pkgname>(VERSION X.Y.Z)`.
However, installation was only tested with the default package versions so 
configuration options might change and in the worst case compatibility will break.

Acknowledgements
----------------
The core functionality lies in the `build_*_subproject.cmake` macros which are derived from 
the [superbuild_ospray](https://github.com/jeffamstutz/superbuild_ospray) project by jeffamstutz.

The [candi project](https://github.com/dealii/candi) provided a good starting point for dependent packages 
and most build arguments for the cmake and autotools projects.


License:
--------

Please see the file [./LICENSE.md](LICENSE.md) for details
