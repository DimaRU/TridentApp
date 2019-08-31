git clone https://github.com/eProsima/foonathan_memory_vendor.git
cd foonathan_memory_vendor
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=../../build -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --target install
cd ../..
git clone https://github.com/eProsima/Fast-RTPS.git
cd Fast-RTPS
git submodule update --init --recursive
mkdir build && cd build
cmake -Dfoonathan_memory_DIR=../../build/share/foonathan_memory/cmake -DCMAKE_INSTALL_PREFIX=../../build -DTHIRDPARTY=ON -INTERNALDEBUG=ON -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --target install
cd ../..
mkdir Framework
cp build/lib/libfastrtps.1.dylib Framework/
cp build/lib/libfastcdr.1.dylib Framework/
