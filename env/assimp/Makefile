include ../../common.mk


# --- Assimp Variables ---
ASSIMP_VERSION     := v6.0.4
ASSIMP_SRC_DIR     := $(THIRDPARTY_DIR)/assimp-$(ASSIMP_VERSION)
ASSIMP_ZIP         := $(THIRDPARTY_DIR)/$(ASSIMP_VERSION).zip
ASSIMP_URL         := https://github.com/assimp/assimp/archive/refs/tags/$(ASSIMP_VERSION).zip
ASSIMP_INSTALL_DIR := $(call package_installed_path,assimp,$(ASSIMP_VERSION))

ASSIMP_MARKER := $(ASSIMP_SRC_DIR)/CMakeLists.txt

.PHONY: make_assimp

make_assimp: $(ASSIMP_MARKER) 
	@echo "Starting Assimp build..."
	@mkdir -p $(ASSIMP_SRC_DIR)/build
	cd $(ASSIMP_SRC_DIR)/build && cmake \
		-D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=$(ASSIMP_INSTALL_DIR) \
		..
	$(MAKE) -C $(ASSIMP_SRC_DIR)/build -j$(THREADS)
	$(MAKE) install -C $(ASSIMP_SRC_DIR)/build -j$(THREADS)
	@echo "Assimp build process finished."

# 3. Source fetch rule
$(ASSIMP_MARKER):
	@echo "Assimp source missing. Preparing..."
	@mkdir -p $(THIRDPARTY_DIR)
	@if [ ! -f $(ASSIMP_ZIP) ]; then \
		echo "Downloading $(ASSIMP_VERSION)..."; \
		curl -L -o $(ASSIMP_ZIP) $(ASSIMP_URL); \
	fi
	@echo "Extracting Assimp..."
	unzip -q $(ASSIMP_ZIP) -d $(THIRDPARTY_DIR)
	@if [ ! -d $(ASSIMP_SRC_DIR) ]; then \
		mv $(THIRDPARTY_DIR)/assimp-$(ASSIMP_VERSION) $(ASSIMP_SRC_DIR); \
	fi
	@rm $(ASSIMP_ZIP)
	@touch $(ASSIMP_MARKER)


prepare_src: $(ASSIMP_MARKER)
clean_build_files:
	@echo "Cleaning Assimp build artifacts..."
	rm -rf $(ASSIMP_SRC_DIR)/build
