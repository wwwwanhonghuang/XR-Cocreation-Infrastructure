include ../../common.mk

# --- Prerequisites ---
OPENFACE_VERSION := 2.2.0
OPENCV_VERSION   := 4.12.0
BOOST_VERSION    := 1.83.0

# --- Paths ---
OPENFACE_SRC_DIR     := $(THIRDPARTY_DIR)/openface-$(OPENFACE_VERSION)
OPENFACE_INSTALL_DIR := $(call package_installed_path,openface,$(OPENFACE_VERSION))
OPENFACE_MARKER      := $(OPENFACE_SRC_DIR)/CMakeLists.txt

# Existing dependencies
OPENCV_INSTALL_DIR   := $(call package_installed_path,opencv,$(OPENCV_VERSION))
BOOST_INSTALL_DIR    := $(call package_installed_path,boost,$(BOOST_VERSION))

.PHONY: prepare_openface_src build_openface

# Define the specific commit that represents the 2.2.0 release
OPENFACE_COMMIT := 3d4b5cf

$(OPENFACE_MARKER):
	@echo "Cloning OpenFace at specific commit $(OPENFACE_COMMIT) (Version 2.2.0)..."
	@mkdir -p $(THIRDPARTY_DIR)
	@# We clone master, then hard-reset to the 2.2.0 commit to be 100% sure
	git clone https://github.com/TadasBaltrusaitis/OpenFace.git $(OPENFACE_SRC_DIR)
	cd $(OPENFACE_SRC_DIR) && \
		git checkout $(OPENFACE_COMMIT) && \
		git submodule update --init --recursive
	@touch $@

prepare_openface_src: $(OPENFACE_MARKER)

# --- 2. Build and Install ---
build_openface: $(OPENFACE_MARKER)
	@echo "Checking dependencies for OpenFace..."
	$(call check_package_ready,boost,$(BOOST_VERSION))
	$(call check_package_ready,opencv,$(OPENCV_VERSION))
	
	@mkdir -p $(OPENFACE_SRC_DIR)/build
	cd $(OPENFACE_SRC_DIR)/build && \
	cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(OPENFACE_INSTALL_DIR) \
		\
		-DCMAKE_CXX_FLAGS="-DBOOST_FILESYSTEM_VERSION=4 -DBOOST_FILESYSTEM_NO_DEPRECATED" \
		-DOpenCV_DIR=$(OPENCV_INSTALL_DIR)/lib/cmake/opencv4 \
		\
		-DBOOST_ROOT=$(BOOST_INSTALL_DIR) \
		-DBoost_INCLUDE_DIR=$(BOOST_INSTALL_DIR)/include \
		-DBoost_LIBRARY_DIR=$(BOOST_INSTALL_DIR)/lib \
		-DBoost_NO_SYSTEM_PATHS=ON \
		-DBoost_NO_BOOST_CMAKE=ON \
		\
		-DEXE_LINKER_FLAGS="-Wl,-rpath,$(OPENCV_INSTALL_DIR)/lib:$(BOOST_INSTALL_DIR)/lib" && \
	make -j$(THREADS) && \
	make install
	
	@echo "Copying models and classifiers to install directory..."
	@cp -r $(OPENFACE_SRC_DIR)/lib/3rdParty/OpenCV/classifiers $(OPENFACE_INSTALL_DIR)/bin/
	@# OpenFace needs to run its model downloader script
	@cd $(OPENFACE_INSTALL_DIR) && ./download_models.sh
	$(MAKE) move_models

move_models:
	mkdir -p $(OPENFACE_INSTALL_DIR)/lib/local/LandmarkDetector/model/
	mv $(OPENFACE_SRC_DIR)/lib/local/LandmarkDetector/model/patch_experts $(OPENFACE_INSTALL_DIR)/lib/local/LandmarkDetector/model/
