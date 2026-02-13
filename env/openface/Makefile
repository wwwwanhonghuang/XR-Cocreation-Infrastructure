ACTIVATED_PYTHON_BIN := $(shell which python)
PYTHON_ROOT := $(realpath $(ACTIVATED_PYTHON_BIN)/../..)
REPOSITORY_ROOT = $(realpath ../..)
OPENCV_VERSION := 4.12.0
OPENCV_DIR := $(REPOSITORY_ROOT)/OpenFace/opencv-$(OPENCV_VERSION)
OPENCV_ZIP := $(REPOSITORY_ROOT)/OpenFace/$(OPENCV_VERSION).zip
PYTHON3_INCLUDE_DIR := $(shell $(PYTHON_ROOT)/bin/python -c "from sysconfig import get_paths as gp; print(gp()['include'])")
PYTHON3_LIBRARY := $(shell find $(PYTHON_ROOT)/lib -name 'libpython3.9*.so' | head -n 1)
BOOST_ROOT := $(REPOSITORY_ROOT)/OpenFace/boost_1_59_0
BOOST_ZIP := boost_1_59_0.tar.gz
BOOST_DIR := $(REPOSITORY_ROOT)/OpenFace/boost_1_59_0
OPENFACE_ROOT := $(REPOSITORY_ROOT)/OpenFace/build


prepare_open_face_repository:
	cd $(REPOSITORY_ROOT) && \
	git clone --recursive https://github.com/TadasBaltrusaitis/OpenFace.git 

build_openface:
	sudo mkdir -p $(REPOSITORY_ROOT)/OpenFace/build && \
	cd $(REPOSITORY_ROOT)/OpenFace/build && \
	sudo apt-get install libdlib-dev && \
	sudo cmake ..   \
		-DOpenCV_DIR=$(REPOSITORY_LOCAL_LIB_ROOT)/install/opencv/lib/cmake/opencv \
		-DBoost_USE_STATIC_LIBS=OFF   \
		-DBoost_USE_MULTITHREADED=ON   \
		-DBoost_USE_STATIC_RUNTIME=OFF && \
	sudo make -j$(nproc)
	cp -r $(REPOSITORY_ROOT)/OpenFace/lib/3rdParty/OpenCV/classifiers $(REPOSITORY_ROOT)/OpenFace/build




