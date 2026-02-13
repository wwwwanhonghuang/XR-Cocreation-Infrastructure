include ../../common.mk

TBB_VERSION     := 2022.3.0
TBB_SRC_DIR     := $(THIRDPARTY_DIR)/oneTBB-$(TBB_VERSION)
TBB_INSTALL_DIR := $(call package_installed_path,tbb,$(TBB_VERSION))
TBB_MARKER      := $(TBB_SRC_DIR)/CMakeLists.txt

make_tbb: $(TBB_MARKER)
	@mkdir -p $(TBB_SRC_DIR)/build
	cd $(TBB_SRC_DIR)/build && cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(TBB_INSTALL_DIR) \
		-DTBB_TEST=OFF \
		-DTBB_STRICT=OFF \
		..
	$(MAKE) -C $(TBB_SRC_DIR)/build -j$(THREADS) install

$(TBB_MARKER):
	@mkdir -p $(THIRDPARTY_DIR)
	git clone --depth 1 --branch v$(TBB_VERSION) https://github.com/oneapi-src/oneTBB.git $(TBB_SRC_DIR)
	@touch $(TBB_MARKER)