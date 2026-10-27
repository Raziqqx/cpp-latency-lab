cmake_minimum_required(VERSION 3.20)
project(cpp_latency_lab LANGUAGES CXX)

# ---------------------------------------------------------------------------
# Language and build settings
# ---------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Lets VS Code / clangd understand the project
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Default to Release: Debug-build benchmarks are meaningless
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Tune for this CPU (turn off if you share binaries between machines)
option(LAB_NATIVE "Compile with -march=native" ON)

# ---------------------------------------------------------------------------
# Google Benchmark (downloaded automatically)
# ---------------------------------------------------------------------------
include(FetchContent)

set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "" FORCE)
set(BENCHMARK_ENABLE_GTEST_TESTS OFF CACHE BOOL "" FORCE)
set(BENCHMARK_ENABLE_INSTALL OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
  googlebenchmark
  GIT_REPOSITORY https://github.com/google/benchmark.git
  GIT_TAG        v1.9.1
  GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(googlebenchmark)

find_package(Threads REQUIRED)

# ---------------------------------------------------------------------------
# Shared code: your rdtsc timer, histogram, etc. go in common/
# ---------------------------------------------------------------------------
add_library(lab_common INTERFACE)
target_include_directories(lab_common INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/common)

target_compile_options(lab_common INTERFACE
  -Wall -Wextra -Wpedantic
  -g                      # keep symbols so perf / objdump show function names
  $<$<BOOL:${LAB_NATIVE}>:-march=native>
)
target_link_libraries(lab_common INTERFACE Threads::Threads)

# ---------------------------------------------------------------------------
# Experiments: every .cpp in experiments/ becomes its own executable.
# Add a file, re-run the build, and it appears. No edits to this file needed.
#
#   experiments/slowpath.cpp     ->  build/slowpath
#   experiments/vector_list.cpp  ->  build/vector_list
# ---------------------------------------------------------------------------
file(GLOB LAB_EXPERIMENTS CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_SOURCE_DIR}/experiments/*.cpp)

foreach(src IN LISTS LAB_EXPERIMENTS)
  get_filename_component(name ${src} NAME_WE)
  add_executable(${name} ${src})
  target_link_libraries(${name} PRIVATE lab_common benchmark::benchmark_main)
endforeach()
