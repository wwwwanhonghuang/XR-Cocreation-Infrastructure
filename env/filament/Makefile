include ../../common.mk
# --- OGRE 3D Versioning ---
FILAMENT_VERSION   := v1.69.2
FILAMENT_DIR       := $(REPOSITORY_ROOT)/3rdparty/filament-$(FILAMENT_VERSION)
FILAMENT_BUILD_DIR := $(FILAMENT_DIR)/build
FILAMENT_MARKER    := $(FILAMENT_DIR)/CMakeLists.txt
FILAMENT_URL       := https://github.com/google/filament/archive/refs/tags/$(FILAMENT_VERSION).zip
FILAMENT_ZIP       := $(REPOSITORY_ROOT)/3rdparty/filament-$(FILAMENT_VERSION).zip

FILAMENT_INSTALL_DIR  := $(call package_installed_path,filament,$(FILAMENT_VERSION))



# --- Source Preparation ---
$(FILAMENT_MARKER):
	@mkdir -p $(REPOSITORY_ROOT)/3rdparty
	@if [ ! -f $(FILAMENT_ZIP) ]; then \
		echo "Downloading Filament $(FILAMENT_VERSION)..."; \
		curl -L -o $(FILAMENT_ZIP) $(FILAMENT_URL); \
	fi
	@echo "Extracting OGRE..."
	@unzip -q $(FILAMENT_ZIP) -d $(REPOSITORY_ROOT)/3rdparty
	@mv $(REPOSITORY_ROOT)/3rdparty/filament-$(FILAMENT_VERSION:v%=%) \
    	$(FILAMENT_DIR)
	@rm $(FILAMENT_ZIP)
	@touch $(FILAMENT_MARKER)

prepare_src:
	$(MAKE) $(FILAMENT_MARKER)

prepare_unix_dependencies:
	sudo apt install clang libglu1-mesa-dev libc++-dev libc++abi-dev ninja-build libxi-dev libxcomposite-dev libxxf86vm-dev -y

# --- Build Rule ---
make_filament: $(FILAMENT_MARKER) prepare_unix_dependencies
	cd $(FILAMENT_DIR) && \
	mkdir -p out/cmake-release && \
	cd out/cmake-release && \
	cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$(FILAMENT_INSTALL_DIR) \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    ../.. && \
	ninja

install:
	cd $(FILAMENT_DIR)/out/cmake-release && \
	ninja install

clean:
	rm $(FILAMENT_DIR)/out -rf