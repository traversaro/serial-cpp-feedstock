#!/bin/sh

rm -rf build
mkdir build
cd build

cmake ${CMAKE_ARGS} -GNinja .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING:BOOL=ON \
      -DBUILD_SHARED_LIBS:BOOL=ON \
      ..

cmake --build . --config Release

if [[ ("${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "") ]]; then
  # test-timer skipped: https://github.com/conda-forge/serial-cpp-feedstock/pull/1#issuecomment-4777748854
  ctest --output-on-failure -E "test-timer" -C Release
fi

cmake --build . --config Release --target install
