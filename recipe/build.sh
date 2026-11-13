#!/bin/sh
#

set -exuo

if [ "$(uname)" == "Darwin" ]; then
  # for Mac OSX
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

INSTALL_DOCUMENTATION=ON
if [[ "${target_platform}" == "linux-riscv64" ]]; then
  # doxygen isn't available on linux-riscv64
  INSTALL_DOCUMENTATION=OFF
fi

mkdir build
cd build

PYTHON_INCLUDE_DIR="$(python -c 'import sysconfig; print(sysconfig.get_path("include"))')"

cmake ${CMAKE_ARGS} .. \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING:BOOL=OFF \
      -DINSTALL_DOCUMENTATION:BOOL=${INSTALL_DOCUMENTATION} \
      -DBUILD_PYTHON_INTERFACE:BOOL=ON \
      -DBUILD_WITH_VECTORIZATION_SUPPORT:BOOL=ON \
      -DBUILD_WITH_OPENMP_SUPPORT:BOOL=ON \
      -DPython_EXECUTABLE=$PYTHON \
      -DPython_INCLUDE_DIR=$PYTHON_INCLUDE_DIR

ninja -j${CPU_COUNT}
ninja install
