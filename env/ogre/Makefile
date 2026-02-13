include ../../common.mk
# --- OGRE 3D Versioning ---
OGRE3D_VERSION   := v14.5.2
OGRE3D_DIR       := $(REPOSITORY_ROOT)/3rdparty/ogre-$(OGRE3D_VERSION)
OGRE3D_BUILD_DIR := $(OGRE3D_DIR)/build
OGRE3D_MARKER    := $(OGRE3D_DIR)/CMakeLists.txt
OGRE3D_URL       := https://github.com/OGRECave/ogre/archive/refs/tags/$(OGRE3D_VERSION).zip
OGRE3D_ZIP       := $(REPOSITORY_ROOT)/3rdparty/ogre-$(OGRE3D_VERSION).zip

OGRE_INSTALL_DIR  := $(call package_installed_path,ogre,$(OGRE3D_VERSION))


# --- Source Preparation ---
$(OGRE3D_MARKER):
	@mkdir -p $(REPOSITORY_ROOT)/3rdparty
	@if [ ! -f $(OGRE3D_ZIP) ]; then \
		echo "Downloading OGRE $(OGRE3D_VERSION)..."; \
		curl -L -o $(OGRE3D_ZIP) $(OGRE3D_URL); \
	fi
	@echo "Extracting OGRE..."
	@unzip -q $(OGRE3D_ZIP) -d $(REPOSITORY_ROOT)/3rdparty
	@rm $(OGRE3D_ZIP)
	@# Standardize directory name if unzip creates a nested folder
	@mv $(REPOSITORY_ROOT)/3rdparty/ogre-14.5.2 $(OGRE3D_DIR) || true
	@touch $(OGRE3D_MARKER)

prepare_ogre3d_src:
	$(MAKE) $(OGRE3D_MARKER)

# --- Dependency Installation ---
# Note: Added -y to apt-get for non-interactive Makefile execution
.PHONY: install-unix-dependencies
install-unix-dependencies:
	sudo apt-get update
	sudo apt-get install -y libgles2-mesa-dev libvulkan-dev glslang-dev \
		libwayland-dev libwayland-egl1 libegl-dev \
		libxrandr-dev libsdl2-dev doxygen

# --- Build Rule ---
.PHONY: make_ogre3d
make_ogre3d: $(OGRE3D_MARKER) install-unix-dependencies
	@echo "Starting OGRE 3D build..."
	@mkdir -p $(OGRE3D_BUILD_DIR)
	cd $(OGRE3D_BUILD_DIR) && cmake \
		-D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_INSTALL_PREFIX=$(OGRE_INSTALL_DIR) \
		-D OGRE3D_BUILD_COMPONENT_PYTHON=ON \
		-D OGRE3D_USE_WAYLAND=ON \
		-D OGRE3D_BUILD_SAMPLES=OFF \
		-D PYTHON_EXECUTABLE=$(ACTIVATED_PYTHON_BIN) \
		..
	$(MAKE) -C $(OGRE3D_BUILD_DIR) -j$(shell nproc)
	$(MAKE) -C $(OGRE3D_BUILD_DIR) install