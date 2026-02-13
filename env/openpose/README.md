> GPU version of Openpose can be more complex to be built. Please refers to [Openpose official instructions](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/installation/0_index.md) for details. 
> Unexpected errors may happens depends on specific GPU and versions of Cuda/Cudnn, etc.
> We provide the steps for building a GPU version of Openpose here. If it fails, we can consider modify the Makefile in `env-preparation/openpose/Makefile`, to set the `-DGPU_MODE=CUDA` to `-DGPU_MODE=CPU_ONLY`.

``` bash
conda activate dance-dynamics
pip install opencv-python
```



``` bash
cd /path/to/repository_root/env-preparation/openpose
make prepare_openpose_repository
```

The command above will clone the openpose repository.


``` bash
make prebuild_openpose
make build_openpose
```

## Solutions for Some Errors in Building

1. new versions of cuDNN seems not be supported. 
cuDNN support has been disabled during the build due to compatibility issues with the newer cuDNN versions **by default** in the command above.

2. The CUDA architecture is automatically detected by default. The building process can fails if it cannot detect the correct CUDA archtecture. 

If the `make prebuild_openpose` command reports problems related to this issue, try modify the `Cuda.cmake` in `/path/to/repository_root/openpose/3rdparts/caffe/cmake/` folder, change 
the `86` (which means `sm_86` arch.) in the follow codes, into the correct one of CUDA arch.

``` cmake
  if (NOT CUDA_gpu_detect_output)
    message(STATUS "Automatic GPU detection failed. xxxxxxxxxxxxxxx")
    set(${out_variable} "86" PARENT_SCOPE)
  else ()
```

3. `/usr/local/cuda/include/crt/math_functions.h` need to be patched to remove `error: exception specification is incompatible with that of previous function "xxxx" ` errors, if these errors appear.

Solution: Add `noexcept(true);` to the end of each line of problematics function definitions.

4. If it report C++ standard need >= `14`, try modify all `-std=c++11` in `/path/to/repository_root/openpose/3rdparts/caffe/CMakeLists.txt` to `-std=c++17`. And also modify all `-std=c++11` in `/path/to/repository_root/openpose/CMakeLists.txt` to `-std=c++17`


## Fast Building
Manual Do it if any failure happen.

``` bash
cd <path-to-env>/openpose
make prepare_openpose_repository 
```