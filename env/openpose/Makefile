include ../../common.mk

# --- Prerequisites ---
PROTOBUF_VERSION := v3.21.12
BOOST_VERSION := 1.90.0
OPENCV_VERSION     := 4.12.0

# --- Openpose Variables ---
OPENPOSE_VERSION := v1.7.0
OPENPOSE_SRC_DIR     := $(THIRDPARTY_DIR)/openpose-$(OPENPOSE_VERSION)
OPENPOSE_ZIP         := $(THIRDPARTY_DIR)/$(OPENPOSE_VERSION).zip
OPENPOSE_URL         := https://github.com//CMU-Perceptual-Computing-Lab/openpose/archive/refs/tags/$(OPENPOSE_VERSION).zip
OPENPOSE_INSTALL_DIR := $(call package_installed_path,openpose,$(OPENPOSE_VERSION))

OPENPOSE_CAFFE_SRC_DIR := $(OPENPOSE_SRC_DIR)/3rdparty/caffe

OPENPOSE_MARKER        := $(OPENPOSE_SRC_DIR)/CMakeLists.txt


## -- Openpose Caffe
CAFFE_INSTALL_DIR := $(call package_installed_path,caffe,ver-openpose)
CAFFE_PATCH_MARKER := \
	$(OPENPOSE_CAFFE_SRC_DIR)/.patched_opencv4
CAFFE_BUILD_MARKER := $(CAFFE_INSTALL_DIR)/.build.mark


## --- Openpose Pybind11 ---
OPENPOSE_PYBIND11_DIR := $(OPENPOSE_SRC_DIR)/3rdparty/pybind11
OPENPOSE_PYBIND_PATCH := $(REPOSITORY_ROOT)/3rdparty/patches/openpose/pybind11/pybind11_python312_compat.patch
OPENPOSE_PYBIND_MARKER := $(OPENPOSE_PYBIND11_DIR)/.patch_pybind11_done


# --- dependencies installation paths ---
BOOST_INSTALL_DIR=$(call package_installed_path,boost,$(BOOST_VERSION))
PROTOBUF_INSTALL_DIR=$(call package_installed_path,protobuf,$(PROTOBUF_VERSION))
OPENCV_INSTALL_DIR := $(call package_installed_path,opencv,$(OPENCV_VERSION))

# --- caffe models ---
OPENPOSE_MODEL_URL := https://github.com/CMU-Perceptual-Computing-Lab/openpose/raw/master/models
BODY_25_MODEL  := pose/body_25/pose_iter_584000.caffemodel
FACE_MODEL     := face/pose_iter_116000.caffemodel
HAND_MODEL     := hand/pose_iter_102000.caffemodel
MODELS_DIR 	   := $(OPENPOSE_SRC_DIR)/models



.PHONY: build_caffe build_openpose prepare_opencv_src download_models install-prerequisites

install-prerequisites: install-caffe-deps

# --- 1. Source Preparation ---
$(OPENPOSE_MARKER):
	@echo "OpenPose source missing. Performing recursive clone for version $(OPENPOSE_VERSION)..."
	@mkdir -p $(THIRDPARTY_DIR)
	@# Remove the directory if it's empty or incomplete from a previous failed unzip
	@if [ ! -f "$(OPENPOSE_CAFFE_SRC_DIR)/CMakeLists.txt" ]; then \
		rm -rf $(OPENPOSE_SRC_DIR); \
	fi
	
	@# Clone the specific tag and all submodules
	git clone --recursive --depth 1 --branch $(OPENPOSE_VERSION) \
		https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
		$(OPENPOSE_SRC_DIR)
	
	@# Double check Caffe submodule is actually there
	@if [ ! -f "$(OPENPOSE_CAFFE_SRC_DIR)/CMakeLists.txt" ]; then \
		echo "Submodule check failed. Attempting manual update..."; \
		cd $(OPENPOSE_SRC_DIR) && git submodule update --init --recursive; \
	fi
	@touch $(OPENPOSE_MARKER)

prepare_openpose_src: $(OPENPOSE_MARKER)


install-caffe-deps:
	@echo "Installing Caffe system dependencies via apt..."
	sudo apt install -y \
		libgoogle-glog-dev \
		libgflags-dev \
		libhdf5-serial-dev \
		liblmdb-dev \
		libleveldb-dev \
		libsnappy-dev \
		libatlas-base-dev \
		libstdc++6 

$(CAFFE_PATCH_MARKER): $(OPENPOSE_MARKER)
	@echo "Checking/Applying compatibility patch for Caffe..."
	@cd $(OPENPOSE_CAFFE_SRC_DIR) && \
	if git apply --reverse --check $(PATCH_FILE) >/dev/null 2>&1; then \
		echo "Patch already applied, skipping."; \
	elif git apply --check $(PATCH_FILE) >/dev/null 2>&1; then \
		echo "Applying patch..."; \
		git apply $(PATCH_FILE); \
	else \
		echo "ERROR: Patch $(PATCH_FILE) is incompatible with current source."; \
		exit 1; \
	fi
	@touch $@


$(CAFFE_BUILD_MARKER): build_caffe
	@touch $@

$(OPENPOSE_PYBIND_MARKER):
	@echo "Applying Python 3.12 compatibility patch to pybind11..."
	@cd $(OPENPOSE_PYBIND11_DIR) && \
	if git apply --reverse --check $(OPENPOSE_PYBIND_PATCH) >/dev/null 2>&1; then \
		echo "Pybind11 patch already applied."; \
	else \
		git apply $(OPENPOSE_PYBIND_PATCH) || (echo "Failed to apply pybind11 patch"; exit 1); \
	fi
	@touch $@

build_caffe: $(OPENPOSE_MARKER) $(CAFFE_PATCH_MARKER) install-caffe-deps 
	@echo "Checking dependencies for Caffe..."
	$(call check_package_ready,boost,$(BOOST_VERSION))
	$(call check_package_ready,opencv,$(OPENCV_VERSION))
	
	@echo "Starting Caffe build..."
	@mkdir -p $(OPENPOSE_CAFFE_SRC_DIR)/build
	
	cd $(OPENPOSE_CAFFE_SRC_DIR)/build && \
	cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DGPU_MODE=CUDA \
		-DBUILD_PYTHON=ON \
		-DBUILD_CAFFE=ON \
		-DBUILD_EXAMPLES=ON \
		-DUSE_CUDNN=OFF \
		\
        -DOpenCV_DIR=$(OPENCV_INSTALL_DIR)/lib/cmake/opencv4 \
        -DOpenCV_CONFIG_PATH=$(OPENCV_INSTALL_DIR)/lib/cmake/opencv4 \
        \
		-DCUDA_ARCH_NAME=Manual \
		-DCUDA_ARCH_BIN="80 86 89" \
		\
		-DCUDA_NVCC_FLAGS="-std=c++17 -Xcompiler -fPIC -D_EXT_THREAD_SAFE" \
		\
		-DDOWNLOAD_BODY_MODEL=ON \
		-DDOWNLOAD_HAND_MODEL=ON \
		-DDOWNLOAD_FACE_MODEL=ON \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_CXX_STANDARD_REQUIRED=ON \
		-DCMAKE_CXX_EXTENSIONS=OFF \
		-DPROTOBUF_INCLUDE_DIR=$(PROTOBUF_INSTALL_DIR)/include \
		-DPROTOBUF_LIBRARY=$(PROTOBUF_INSTALL_DIR)/lib/libprotobuf.so \
		-DProtobuf_PROTOC_EXECUTABLE=$(PROTOBUF_INSTALL_DIR)/bin/protoc \
		\
		-DBoost_DIR=$(BOOST_INSTALL_DIR) \
		-DBOOST_ROOT=$(BOOST_INSTALL_DIR) \
		-DBoost_NO_SYSTEM_PATHS=ON \
		-DBoost_NO_BOOST_CMAKE=TRUE \
		-DBoost_INCLUDE_DIR=$(BOOST_INSTALL_DIR)/include \
		-DBoost_LIBRARY_DIR=$(BOOST_INSTALL_DIR)/lib \
		-DBoost_PYTHON_LIBRARY=$(BOOST_INSTALL_DIR)/lib/libboost_python312.so \
		-DBoost_PYTHON_INCLUDE_DIR=$(BOOST_INSTALL_DIR)/include \
		-DPYTHON_LIBRARIES=$(PYTHON3_LIBRARY) \
		-DPYTHON_INCLUDE_DIR=$(PYTHON3_INCLUDE_DIR) \
		-DBoost_SYSTEM_LIBRARY_RELEASE=$(BOOST_INSTALL_DIR)/lib/libboost_thread.so \
		-DBoost_FILESYSTEM_LIBRARY_RELEASE=$(BOOST_INSTALL_DIR)/lib/libboost_filesystem.so \
		-DBoost_THREAD_LIBRARY_RELEASE=$(BOOST_INSTALL_DIR)/lib/libboost_thread.so \
		-DCMAKE_EXE_LINKER_FLAGS="-L/usr/lib/x86_64-linux-gnu -lssl -lcrypto" \
		\
		-DCMAKE_INSTALL_PREFIX=$(CAFFE_INSTALL_DIR) && \
	make -j$(THREADS) && \
	make install

download_models:
	@echo "Checking OpenPose models in $(MODELS_DIR)..."
	@# Loop through the models to check existence and download if missing
	@for model in $(BODY_25_MODEL) $(FACE_MODEL) $(HAND_MODEL); do \
		if [ -f "$(MODELS_DIR)/$$model" ]; then \
			echo "[PROMPT] $$model already exists. Skipping."; \
		else \
			echo "[FETCH] $$model missing. Downloading..."; \
			mkdir -p "$(MODELS_DIR)/$$(dirname $$model)"; \
			wget -c "$(OPENPOSE_MODEL_URL)/$$model" -O "$(MODELS_DIR)/$$model" || { echo "Download failed for $$model"; exit 1; }; \
		fi; \
	done

build_openpose: $(OPENPOSE_PYBIND_MARKER) $(CAFFE_BUILD_MARKER) download_models
	mkdir -p $(OPENPOSE_SRC_DIR)/build && \
	cd $(OPENPOSE_SRC_DIR)/build && \
	cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DOpenCV_DIR=$(OPENCV_INSTALL_DIR) \
		-DCaffe_DIR=$(CAFFE_INSTALL_DIR)/lib/cmake/Caffe \
		-DCaffe_INCLUDE_DIRS=$(CAFFE_INSTALL_DIR)/include \
		-DCaffe_LIBS=$(CAFFE_INSTALL_DIR)/lib/libcaffe.so \
		-DPROTOBUF_INCLUDE_DIR=$(PROTOBUF_INSTALL_DIR)/include \
		-DPROTOBUF_LIBRARY=$(PROTOBUF_INSTALL_DIR)/lib/libprotobuf.so \
		-DProtobuf_PROTOC_EXECUTABLE=$(PROTOBUF_INSTALL_DIR)/bin/protoc \
		-DBUILD_PYTHON=ON \
		-DBUILD_EXAMPLES=ON \
		-DUSE_CUDA=ON \
		-DCMAKE_INSTALL_PREFIX=$(OPENPOSE_INSTALL_DIR) \
		-DDOWNLOAD_BODY_25_MODEL=OFF \
		-DDOWNLOAD_FACE_MODEL=OFF \
		-DDOWNLOAD_HAND_MODEL=OFF \
		-DDOWNLOAD_BODY_COCO_MODEL=OFF \
		-DDOWNLOAD_BODY_MPI_MODEL=OFF \
		-DBUILD_CAFFE=OFF && \
	make -j$(THREADS) && \
	make install
	cp -r $(OPENPOSE_SRC_DIR)/models $(OPENPOSE_INSTALL_DIR)
	
	@echo "--- Post-Build Integration ---"
	@echo "Fixing Python 3.12 naming and package structure..."
	@mkdir -p $(OPENPOSE_INSTALL_DIR)/python/openpose
	@# Rename and move the binary to the correct package location
	@if [ -f $(OPENPOSE_INSTALL_DIR)/python/pyopenposeNone ]; then \
		mv $(OPENPOSE_INSTALL_DIR)/python/pyopenposeNone \
		   $(OPENPOSE_INSTALL_DIR)/python/openpose/pyopenpose$(PYTHON_EXT_SUFFIX); \
	fi
	
	@echo "Linking OpenPose and Caffe libraries to Conda lib directory..."
	@# Symlink the C++ core libraries so the dynamic linker finds them automatically
	@ln -sf $(OPENPOSE_INSTALL_DIR)/lib/libopenpose.so* $(PYTHON3_LIB_DIR)/
	@ln -sf $(CAFFE_INSTALL_DIR)/lib/libcaffe.so* $(PYTHON3_LIB_DIR)/
	
	@echo "Linking OpenPose package to site-packages..."
	@# Symlink the python package folder
	@ln -sfv $(OPENPOSE_INSTALL_DIR)/python/openpose $(PYTHON_SITE_PACKAGES)/openpose

	@echo "Verifying installation..."
	@$(ACTIVATED_PYTHON_BIN) -c "import openpose; print('Build Success: OpenPose is ready for XR infrastructure!')"

clean_openpose_buld_files:
	rm -rf $(OPENPOSE_SRC_DIR)/build
clean_caffe_build_files:
	rm -rf $(OPENPOSE_CAFFE_SRC_DIR)/build

clean_build_files:
	@echo "Cleaning OpenCV build artifacts..."
	rm -rf $(OPENPOSE_SRC_DIR)/build
