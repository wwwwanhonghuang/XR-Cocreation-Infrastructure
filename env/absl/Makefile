include ../../common.mk

# --- Abseil Variables ---
ABSL_VERSION   := 20250512.1
ABSL_SRC_DIR   := $(THIRDPARTY_DIR)/abseil-cpp-$(ABSL_VERSION)
ABSL_MARKER    := $(ABSL_SRC_DIR)/CMakeLists.txt

# Utilizing the central function for the install path
ABSL_INSTALL_DIR := $(call package_installed_path,absl,$(ABSL_VERSION))

.PHONY: make_absl prepare_absl_src

# 1. High-level build rule
make_absl: $(ABSL_MARKER)
	@echo "Starting Abseil build..."
	@mkdir -p $(ABSL_SRC_DIR)/build
	cd $(ABSL_SRC_DIR)/build && cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(ABSL_INSTALL_DIR) \
		-DCMAKE_CXX_STANDARD=17 \
		-DABSL_PROPAGATE_CXX_STD=ON \
		-DBUILD_SHARED_LIBS=ON \
		..
	@echo "Compiling Abseil..."
	$(MAKE) -C $(ABSL_SRC_DIR)/build -j$(THREADS)
	$(MAKE) -C $(ABSL_SRC_DIR)/build install
	@echo "Abseil installed to $(ABSL_INSTALL_DIR)"

# 2. Source fetching rule
$(ABSL_MARKER):
	@echo "Cloning Abseil $(ABSL_VERSION)..."
	@mkdir -p $(THIRDPARTY_DIR)
	@if [ ! -d $(ABSL_SRC_DIR) ]; then \
		git clone --depth 1 --branch $(ABSL_VERSION) https://github.com/abseil/abseil-cpp.git $(ABSL_SRC_DIR); \
	else \
		echo "Abseil source already exists."; \
	fi
	@touch $(ABSL_MARKER)

prepare_absl_src: $(ABSL_MARKER)