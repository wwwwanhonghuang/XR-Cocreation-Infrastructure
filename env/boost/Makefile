include ../../common.mk

# --- Boost Variables ---
BOOST_VERSION      := 1.90.0
BOOST_SRC_DIR      := $(THIRDPARTY_DIR)/boost-$(BOOST_VERSION)
BOOST_ARCHIVE          := $(THIRDPARTY_DIR)/boost-$(BOOST_VERSION).tar.gz.7z

OPENCV_URL         := https://github.com/opencv/opencv/archive/refs/tags/$(OPENCV_VERSION).zip
OPENCV_INSTALL_DIR := $(call package_installed_path,opencv,$(OPENCV_VERSION))
BOOST_URL          := https://github.com/boostorg/boost/releases/download/boost-$(BOOST_VERSION)/boost-$(BOOST_VERSION)-cmake.7z

BOOST_INSTALL_DIR  := $(call package_installed_path,boost,$(BOOST_VERSION))

BOOST_MARKER       := $(BOOST_SRC_DIR)/bootstrap.sh

.PHONY: make_boost install-prerequisites clean_boost

# --- 1. Prerequisites ---
install-prerequisites:
	@echo "Installing Boost build dependencies..."
	sudo apt install -y libbz2-dev python3-dev build-essential p7zip-full

# --- 2. Build and Install ---
make_boost: $(BOOST_MARKER) install-prerequisites
	@echo "Starting Boost build..."
	
	# Step A: Bootstrap
	cd $(BOOST_SRC_DIR) && ./bootstrap.sh --prefix=$(BOOST_INSTALL_DIR) --with-python=$(ACTIVATED_PYTHON_BIN)
	
	# Step B: B2 Install
	# Note: Python configuration in B2 is usually handled via user-config.jam, 
	# but passing the paths directly works for standard setups.
	cd $(BOOST_SRC_DIR) && ./b2 install \
		-j$(THREADS) \
		--prefix=$(BOOST_INSTALL_DIR) \
		threading=multi \
		link=static,shared \
		runtime-link=shared \
		--with-system --with-filesystem --with-thread --with-program_options --with-python
	
	@echo "Boost $(BOOST_VERSION) installed to $(BOOST_INSTALL_DIR)"


$(BOOST_MARKER):
	@echo "Boost $(BOOST_VERSION) source missing. Preparing..."
	@mkdir -p $(THIRDPARTY_DIR)
	
	@# Download step
	@if [ ! -f $(BOOST_ARCHIVE) ]; then \
		echo "Downloading from $(BOOST_URL)..."; \
		curl -L -f -o $(BOOST_ARCHIVE) $(BOOST_URL) || (echo "Download failed! Check URL."; exit 1); \
	fi
	
	@echo "Extracting Boost..."
	@# Use -xf (tar handles gzip automatically in modern versions)
	7z x $(BOOST_ARCHIVE) -o$(THIRDPARTY_DIR)
	
	@# Rename the extracted 'boost_1_90_0' to your 'boost-1.90.0'
	@if [ -d "$(THIRDPARTY_DIR)/boost_$(BOOST_UNDERSCORE)" ]; then \
		mv $(THIRDPARTY_DIR)/boost_$(BOOST_UNDERSCORE) $(BOOST_SRC_DIR); \
	fi
	
	@rm -f $(BOOST_ARCHIVE)
	@touch $(BOOST_MARKER)
	@echo "Boost source extraction complete."

prepare_boost_src: $(BOOST_MARKER)

clean_boost_build:
	@echo "Cleaning Boost build artifacts..."
	@if [ -d "$(BOOST_SRC_DIR)" ]; then \
		cd $(BOOST_SRC_DIR) && ./b2 --clean-all; \
		rm -rf $(BOOST_SRC_DIR)/bin.v2; \
		rm -rf $(BOOST_SRC_DIR)/project-config.jam; \
	fi