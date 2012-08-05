# - Config file for the Armadillo package
# It defines the following variables
#  ARMADILLO_INCLUDE_DIRS - include directories for Armadillo
#  ARMADILLO_LIBRARY_DIRS - library directories for Armadillo (normally not used!)
#  ARMADILLO_LIBRARIES    - libraries to link against

# Tell the user project where to find our headers and libraries
set(ARMADILLO_INCLUDE_DIRS "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4;/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4")
set(ARMADILLO_LIBRARY_DIRS "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4")

# Our library dependencies (contains definitions for IMPORTED targets)
include("/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/ArmadilloLibraryDepends.cmake")

# These are IMPORTED targets created by ArmadilloLibraryDepends.cmake
set(ARMADILLO_LIBRARIES armadillo)

