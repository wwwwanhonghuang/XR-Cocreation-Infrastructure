include ../../common.mk

BLAS_VERSION := 0.3.31
BLAS_SRC_DIR := $(THIRDPARTY_DIR)/OpenBLAS-$(BLAS_VERSION)
BLAS_INSTALL_DIR := $(call package_installed_path,openblas,$(BLAS_VERSION))
BLAS_MARKER  := $(BLAS_SRC_DIR)/Makefile

make_openblas: $(BLAS_MARKER)
	$(MAKE) -C $(BLAS_SRC_DIR) -j$(THREADS) USE_THREAD=1
	$(MAKE) -C $(BLAS_SRC_DIR) PREFIX=$(BLAS_INSTALL_DIR) \
		INSTALL="cp -p" install
	ln -sf $(BLAS_INSTALL_DIR)/lib/libopenblas_*.a $(BLAS_INSTALL_DIR)/lib/libopenblas.a

$(BLAS_MARKER):
	@mkdir -p $(THIRDPARTY_DIR)
	git clone --depth 1 --branch v$(BLAS_VERSION) https://github.com/OpenMathLib/OpenBLAS.git $(BLAS_SRC_DIR)
	@touch $(BLAS_MARKER)

