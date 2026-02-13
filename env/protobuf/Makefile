include ../../common.mk

# --- Prerequisites ---
ABSL_VERSION := 20250512.1

# --- Protobuf Variables ---
PROTOBUF_VERSION     := v3.21.12 #v33.5
PROTOBUF_SRC_DIR     := $(THIRDPARTY_DIR)/protobuf-$(PROTOBUF_VERSION)

PROTOBUF_INSTALL_DIR := $(call package_installed_path,protobuf,$(PROTOBUF_VERSION))
ABSL_INSTALL_DIR := $(call package_installed_path,absl,$(ABSL_VERSION))/lib/cmake/absl

PROTOBUF_MARKER := $(PROTOBUF_SRC_DIR)/CMakeLists.txt

.PHONY: make_protobuf prepare_protobuf_src

# 1. The high-level target
make_protobuf: $(PROTOBUF_MARKER)
	# Circuit Breaker: Ensure Abseil exists before we spend time building
	$(call check_package_ready,absl,$(ABSL_VERSION))
	@echo "Starting Protobuf build..."
	@mkdir -p $(PROTOBUF_SRC_DIR)/build
	cd $(PROTOBUF_SRC_DIR)/build && cmake \
		-Dprotobuf_BUILD_SHARED_LIBS=ON \
		-Dprotobuf_BUILD_TESTS=OFF \
		-Dprotobuf_ABSL_PROVIDER=package \
		-Dabsl_DIR= $(ABSL_INSTALL_DIR)\
		-DCMAKE_INSTALL_PREFIX=$(PROTOBUF_INSTALL_DIR) \
		-DCMAKE_BUILD_TYPE=Release \
		..
	$(MAKE) -C $(PROTOBUF_SRC_DIR)/build -j$(THREADS)
	$(MAKE) -C $(PROTOBUF_SRC_DIR)/build install
	@echo "Protobuf installed to $(PROTOBUF_INSTALL_DIR)"

# 2. Source fetching
$(PROTOBUF_MARKER):
	@echo "Cloning Protobuf $(PROTOBUF_VERSION)..."
	@mkdir -p $(THIRDPARTY_DIR)
	@if [ ! -d $(PROTOBUF_SRC_DIR) ]; then \
		git clone --depth 1 --branch $(PROTOBUF_VERSION) https://github.com/protocolbuffers/protobuf.git $(PROTOBUF_SRC_DIR); \
	fi
	cd $(PROTOBUF_SRC_DIR) && git submodule update --init --recursive
	@touch $(PROTOBUF_MARKER)

# 3. Optional helper
prepare_protobuf_src: $(PROTOBUF_MARKER)