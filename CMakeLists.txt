cmake_minimum_required(VERSION 3.10)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(dec)

option(TRACY_ENABLE "" ON)
option(TRACY_ON_DEMAND "" ON)

add_compile_definitions(TRACY_ENABLE)
include_directories("tracy")

set(TRACY_BASE_DIR "${CMAKE_SOURCE_DIR}/tracy")
add_subdirectory(tracy)

set(DECNUMBER_BASE_DIR "${CMAKE_SOURCE_DIR}/decNumber")
set(DECNUMBER_INSTALL_DIR "${DECNUMBER_BASE_DIR}/install")
set(DECNUMBER_SOURCE_DIR "${DECNUMBER_BASE_DIR}/decNumber-icu-368")

add_executable(decdemo ${CMAKE_SOURCE_DIR}/decdemo.c)
#target_sources(decdemo ${TRACY_BASE_DIR}/public/TracyClient.cpp)
target_include_directories(decdemo PRIVATE "${TRACY_BASE_DIR}/public/tracy")
target_include_directories(decdemo PRIVATE "${DECNUMBER_INSTALL_DIR}")
target_link_libraries(decdemo PRIVATE "${DECNUMBER_INSTALL_DIR}/libdecnum.a")
target_link_libraries(decdemo PRIVATE TracyClient)


add_executable(dec_example1 ${DECNUMBER_SOURCE_DIR}/example1.c)
target_include_directories(dec_example1 PRIVATE "${DECNUMBER_INSTALL_DIR}")
target_link_libraries(dec_example1 PRIVATE "${DECNUMBER_INSTALL_DIR}/libdecnum.a")

#########


set(MPFR_HEADER_DIR "/usr/local/include")
set(MPFR_DYLIB "/usr/local/lib/libmpfr.dylib")
set(GMP_DYLIB "/usr/local/lib/libgmp.dylib")

add_executable(frversion mpfr/frversion.c)
target_link_libraries(frversion PRIVATE "${MPFR_DYLIB}")
target_include_directories(frversion PRIVATE "${MPFR_HEADER_DIR}")

add_executable(frsample mpfr/frsample.c)
target_link_libraries(frsample PRIVATE "${MPFR_DYLIB}")
target_link_libraries(frsample PRIVATE "${GMP_DYLIB}")
target_include_directories(frsample PRIVATE "${MPFR_HEADER_DIR}")

add_executable(fr123 mpfr/fr123.c)
target_link_libraries(fr123 PRIVATE "${MPFR_DYLIB}")
target_link_libraries(fr123 PRIVATE "${GMP_DYLIB}")
target_include_directories(fr123 PRIVATE "${MPFR_HEADER_DIR}")




message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")

message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_INCLUDE_PATH: ${CMAKE_INCLUDE_PATH}")
message(STATUS "CMAKE_LIBRARY_PATH: ${CMAKE_LIBRARY_PATH}")
message(STATUS "CMAKE_PROGRAM_PATH: ${CMAKE_PROGRAM_PATH}")

message(STATUS "CMAKE_SYSTEM_PREFIX_PATH: ${CMAKE_SYSTEM_PREFIX_PATH}")
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

