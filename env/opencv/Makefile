include ../../common.mk

# --- Prerequisites ---
PROTOBUF_REQ_VER := v33.5
TBB_VERSION      := 2022.3.0
ABSL_VERSION     := 20250512.1
OPENBLAS_VERSION := 0.3.31

# --- OpenCV Variables ---
OPENCV_VERSION     := 4.12.0
OPENCV_SRC_DIR     := $(THIRDPARTY_DIR)/opencv-$(OPENCV_VERSION)
OPENCV_ZIP         := $(THIRDPARTY_DIR)/$(OPENCV_VERSION).zip
OPENCV_URL         := https://github.com/opencv/opencv/archive/refs/tags/$(OPENCV_VERSION).zip
OPENCV_INSTALL_DIR := $(call package_installed_path,opencv,$(OPENCV_VERSION))

OPENCV_MARKER := $(OPENCV_SRC_DIR)/CMakeLists.txt

.PHONY: make_opencv

install-prerequisites:
	# sudo apt update
	sudo apt install libgtk-3-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev zlib1g-dev -y
	$(ACTIVATED_PYTHON_BIN) -m pip install numpy==1.26.4

make_opencv: $(OPENCV_MARKER) install-prerequisites
	@dpkg -l libgtk-3-dev > /dev/null || (echo "Error: libgtk-3-dev missing. Run 'make install-prerequisites'"; exit 1)
	# Fail-fast: ensure dependencies are ready
	$(call check_package_ready,protobuf,$(PROTOBUF_REQ_VER))
	$(call check_package_ready,tbb,$(TBB_VERSION))
	$(call check_package_ready,openblas,$(OPENBLAS_VERSION))
	$(call check_package_ready,absl,$(ABSL_VERSION))
	
	@echo "Locating dependency paths..."
	$(eval ABSL_PATH := $(shell find $(call package_installed_path,absl,$(ABSL_VERSION)) -name abslConfig.cmake -exec dirname {} \;))
	$(eval TBB_PATH  := $(shell find $(call package_installed_path,tbb,$(TBB_VERSION)) -name TBBConfig.cmake -exec dirname {} \;))
	$(eval BLAS_ROOT := $(call package_installed_path,openblas,$(OPENBLAS_VERSION)))

	@echo "Starting OpenCV build..."
	@mkdir -p $(OPENCV_SRC_DIR)/build
	cd $(OPENCV_SRC_DIR)/build && cmake \
		-D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=$(OPENCV_INSTALL_DIR) \
		-D CMAKE_CXX_STANDARD=17 \
		-D CMAKE_CXX_STANDARD_REQUIRED=ON \
		-D CMAKE_INSTALL_MODE=COPY \
		-D BUILD_ZLIB=OFF \
		-D BUILD_PROTOBUF=ON \
		-D absl_DIR=$(ABSL_PATH) \
		-D LAPACK_INCLUDE_DIR=$(BLAS_ROOT)/include \
        -D LAPACK_CBLAS_H="cblas.h" \
		-D WITH_TBB=ON \
		-D TBB_DIR=$(TBB_PATH) \
		-D WITH_LAPACK=ON \
		-D WITH_BLAS=ON \
		-D BLAS_LIBRARIES=$(BLAS_ROOT)/lib/libopenblas.a \
		-D LAPACK_LIBRARIES=$(BLAS_ROOT)/lib/libopenblas.a \
		-D PYTHON3_EXECUTABLE=$(ACTIVATED_PYTHON_BIN) \
		-D PYTHON3_INCLUDE_DIR=$(PYTHON3_INCLUDE_DIR) \
		-D PYTHON3_LIBRARY=$(PYTHON3_LIBRARY) \
		-D BUILD_opencv_python3=ON \
		-D OPENCV_SKIP_PYTHON_LOADER=ON \
		-D BUILD_EXAMPLES=OFF \
		-D BUILD_TESTS=OFF \
		-D BUILD_PERF_TESTS=OFF \
		-D WITH_V4L=ON \
		-D WITH_QT=OFF \
		-D WITH_OPENGL=ON \
		..
	$(MAKE) -C $(OPENCV_SRC_DIR)/build -j$(THREADS)
	# Use '-' to ignore NTFS permission errors and 'install/fast' to skip redundant checks
	-$(MAKE) -C $(OPENCV_SRC_DIR)/build install/fast
	@echo "OpenCV build process finished."

# 3. Source fetch rule
$(OPENCV_MARKER):
	@echo "OpenCV source missing. Preparing..."
	@mkdir -p $(THIRDPARTY_DIR)
	@if [ ! -f $(OPENCV_ZIP) ]; then \
		echo "Downloading $(OPENCV_VERSION)..."; \
		curl -L -o $(OPENCV_ZIP) $(OPENCV_URL); \
	fi
	@echo "Extracting OpenCV..."
	unzip -q $(OPENCV_ZIP) -d $(THIRDPARTY_DIR)
	@if [ ! -d $(OPENCV_SRC_DIR) ]; then \
		mv $(THIRDPARTY_DIR)/opencv-$(OPENCV_VERSION) $(OPENCV_SRC_DIR); \
	fi
	@rm $(OPENCV_ZIP)
	@touch $(OPENCV_MARKER)



clean_build_files:
	@echo "Cleaning OpenCV build artifacts..."
	rm -rf $(OPENCV_SRC_DIR)/build
