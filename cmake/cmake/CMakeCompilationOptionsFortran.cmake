GET_FILENAME_COMPONENT(Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME_WE)
IF(Fortran_COMPILER_NAME MATCHES "gfortran.*")
    # http://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
    # http://gcc.gnu.org/onlinedocs/gfortran/Code-Gen-Options.html
    # -std=f2003
    # -fcheck=all
    # SET(CMAKE_Fortran_FLAGS         "-cpp -Wextra -Wunused -Wall -fmessage-length=0 -ffixed-line-length-none -ffree-line-length-none -fno-automatic -fdefault-real-8 -fdefault-double-8 -fno-f2c)
    SET(CMAKE_Fortran_FLAGS         "-cpp -Wextra -Wunused -Wall -fmessage-length=0 -ffixed-line-length-none -ffree-line-length-none -fno-automatic -fdefault-real-8 -fdefault-double-8")
    SET(CMAKE_Fortran_FLAGS         "${CMAKE_Fortran_FLAGS} -fno-f2c -pedantic -pedantic-errors -w -Wno-globals -Wunused -Wuninitialized -Wall -Wsurprising -Werror -W")
    # SET(CMAKE_Fortran_FLAGS         "${CMAKE_Fortran_FLAGS} -finit-real=nan -finit-logical=false")
    SET(CMAKE_Fortran_FLAGS_RELEASE "-funroll-loops -O3")
    #-O3 -march=corei7 -msse2 -funroll-loops -fno-protect-parens -ffast-math
    SET(CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g3")
    #-O0 -Wline-truncation -fbounds-check -fpack-derived -fbacktrace -ffpe-summary=all -fimplicit-none -fcheck=all -Wall -Wtabs -Wextra -Wunderflow  -Wno-zerotrip -finit-integer=inf -finit-real=nan -ffpe-trap=zero,overflow
    SET(CMAKE_Fortran_FLAGS_PROFILE "-g -pg")
    IF(CMAKE_BUILD_TYPE_UPPER MATCHES COVERAGE)
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g --coverage")
    ELSEIF(CMAKE_BUILD_TYPE_UPPER MATCHES PROFILE)
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -pg")
    ENDIF()
ELSEIF(Fortran_COMPILER_NAME STREQUAL "ifort")
    EXECUTE_PROCESS(COMMAND ifort --version 
                    OUTPUT_VARIABLE INTEL_COMPILER_VERSION)
    STRING(REGEX MATCH "([0-9]+)" 
            NUM_VERSION ${INTEL_COMPILER_VERSION})
    IF("${NUM_VERSION}" STREQUAL "13")
        ADD_DEFINITIONS(-DINTEL_13)
    ENDIF()
    ADD_DEFINITIONS(-DIntel)
    ADD_DEFINITIONS(-DINTEL)
    SET(CMAKE_Fortran_FLAGS_RELEASE "-f77rtl -O3")
    SET(CMAKE_Fortran_FLAGS_DEBUG   "-f77rtl -O0 -g")
ELSEIF(Fortran_COMPILER_NAME STREQUAL "g77")
    SET(CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
    SET(CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")
ELSE()
    MESSAGE(STATUS "CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
    MESSAGE(STATUS "Fortran compiler: " ${Fortran_COMPILER_NAME})
    MESSAGE(STATUS "No optimized Fortran compiler flags are known, we just try -O2...")
    SET(CMAKE_Fortran_FLAGS_RELEASE "-O2 ")
    SET(CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
ENDIF()

MESSAGE(STATUS "CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE_UPPER} ${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE_UPPER}}")
