# Install script for directory: /home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
   "/usr/include/")
FILE(INSTALL DESTINATION "/usr/include" TYPE DIRECTORY FILES "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/include/" REGEX "/\\.svn$" EXCLUDE REGEX "/[^/]*\\.cmake$" EXCLUDE REGEX "/[^/]*\\~$" EXCLUDE REGEX "/[^/]*orig$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
   "/usr/include/armadillo_bits/config.hpp")
FILE(INSTALL DESTINATION "/usr/include/armadillo_bits" TYPE FILE FILES "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/include/armadillo_bits/config.hpp")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FOREACH(file
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so.3.2.4"
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so.3"
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      FILE(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    ENDIF()
  ENDFOREACH()
  list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
   "/usr/lib/libarmadillo.so.3.2.4;/usr/lib/libarmadillo.so.3;/usr/lib/libarmadillo.so")
FILE(INSTALL DESTINATION "/usr/lib" TYPE SHARED_LIBRARY FILES
    "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/libarmadillo.so.3.2.4"
    "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/libarmadillo.so.3"
    "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/libarmadillo.so"
    )
  FOREACH(file
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so.3.2.4"
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so.3"
      "$ENV{DESTDIR}/usr/lib/libarmadillo.so"
      )
    IF(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      IF(CMAKE_INSTALL_DO_STRIP)
        EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "${file}")
      ENDIF(CMAKE_INSTALL_DO_STRIP)
    ENDIF()
  ENDFOREACH()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "dev")
  IF(EXISTS "$ENV{DESTDIR}/usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake")
    FILE(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}/usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake"
         "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/CMakeFiles/Export/_usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake")
    IF(EXPORT_FILE_CHANGED)
      FILE(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}/usr/share/Armadillo/CMake/ArmadilloLibraryDepends-*.cmake")
      IF(OLD_CONFIG_FILES)
        MESSAGE(STATUS "Old export file \"$ENV{DESTDIR}/usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        FILE(REMOVE ${OLD_CONFIG_FILES})
      ENDIF(OLD_CONFIG_FILES)
    ENDIF(EXPORT_FILE_CHANGED)
  ENDIF()
  list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
   "/usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake")
FILE(INSTALL DESTINATION "/usr/share/Armadillo/CMake" TYPE FILE FILES "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/CMakeFiles/Export/_usr/share/Armadillo/CMake/ArmadilloLibraryDepends.cmake")
  IF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^()$")
    list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
     "/usr/share/Armadillo/CMake/ArmadilloLibraryDepends-noconfig.cmake")
FILE(INSTALL DESTINATION "/usr/share/Armadillo/CMake" TYPE FILE FILES "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/CMakeFiles/Export/_usr/share/Armadillo/CMake/ArmadilloLibraryDepends-noconfig.cmake")
  ENDIF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^()$")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "dev")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "dev")
  list(APPEND CPACK_ABSOLUTE_DESTINATION_FILES
   "/usr/share/Armadillo/CMake/ArmadilloConfig.cmake;/usr/share/Armadillo/CMake/ArmadilloConfigVersion.cmake")
FILE(INSTALL DESTINATION "/usr/share/Armadillo/CMake" TYPE FILE FILES
    "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/InstallFiles/ArmadilloConfig.cmake"
    "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/InstallFiles/ArmadilloConfigVersion.cmake"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "dev")

IF(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
ELSE(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
ENDIF(CMAKE_INSTALL_COMPONENT)

FILE(WRITE "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/${CMAKE_INSTALL_MANIFEST}" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/home/traviscollins/git/Thesis/BLiSS/onrbliss/source/bliss/armadillo-3.2.4/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
ENDFOREACH(file)
