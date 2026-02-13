# Prepare Protobuf
For ubuntu system,
``` python
sudo apt-get install libprotobuf-dev protobuf-compiler
```
may work.

If the openpose Makefile generation with CMake cannot find the protobuf library,
try manually specify the path in the cmake-gui.
Specifically,
follow entries should be specifies:
- Protobuf_LIBRARY_DEBUG
- Protobuf_LIBRARY_RELEASE
- Protobuf_LITE_LIBRARY_DEBUG
- Protobuf_LITE_LIBRARY_RELEASE
- Protobuf_PROTOC_LIBRARY_DEBUG
- Protobuf_PROTOC_LIBRARY_RELEASE

The library `/usr/lib/x86_64-linux-gnu/libprotobuf.so`
should resided in `/usr/lib/x86_64-linux-gnu/` i installed by apt-get.
It should be in anaconda home's `lib/libprotobuf.so`, or `envs/[environment_name]/lib/libprotobuf.so` it is installed by anaconda.

Alternatively, 
we may also build protobuf manually, then manually specify the path in the cmake-gui:

## Build Protobuf from Source
``` bash
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git submodule update --init --recursive 
mkdir build && cd build
cmake -Dprotobuf_BUILD_SHARED_LIBS=ON -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. 
make -j$(nproc)
sudo make install
sudo ldconfig
```