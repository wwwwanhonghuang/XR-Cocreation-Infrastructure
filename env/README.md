## create a new virtual environment (we use conda):

``` bash
conda create -n xr-integrated python=3.12
conda activate xr-integrated
conda install -n xr-integrated -c conda-forge openssl>=3.2.0
```

For more smooth environment setup, it is expect in order prepare the following environment according instructions.

## Build ORGE
[orge_installation](./orge/README.md)

## Build absl
[protobuf_installation](./protobuf/README.md)

## Build TBB

## Build Protobuf
[protobuf_installation](./protobuf/README.md)

## Build Openblas

## Build OpenCV

## Build Boost

## Build Openpose
[orge_installation](./openpose/README.md)

## Build dependencies

``` bash
cd /path/to/repository_root/lib/
make -j
```

## Build OpenFace (see [openface](./openface/README.md))
