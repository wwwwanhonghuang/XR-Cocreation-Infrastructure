# --- Global Paths ---
# Use 'abspath' to ensure paths work regardless of which subdirectory make is called from
REPOSITORY_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
THIRDPARTY_DIR  := $(REPOSITORY_ROOT)/3rdparty
REPOSITORY_LOCAL_LIB_ROOT := $(REPOSITORY_ROOT)/lib
REPOSITORY_LOCAL_INSTALL_ROOT := $(REPOSITORY_LOCAL_LIB_ROOT)/install
# --- Environment Detection ---
# Pin your Python version here
REQUIRED_PY_VER := 3.12
ACTIVATED_PYTHON_BIN := $(shell which python)
PYTHON_ROOT          := $(abspath $(shell $(ACTIVATED_PYTHON_BIN) -c "import sys; print(sys.prefix)"))

# --- Python Paths ---
PYTHON3_INCLUDE_DIR := $(shell $(ACTIVATED_PYTHON_BIN) -c "from sysconfig import get_paths as gp; print(gp()['include'])")
PYTHON3_LIBRARY     := $(shell find $(PYTHON_ROOT)/lib -name 'libpython$(REQUIRED_PY_VER)*.so*' | head -n 1)

# --- Shared Tool Flags ---
# Add common flags like nproc for parallel builds
THREADS := $(shell nproc)

define package_installed_path
$(REPOSITORY_LOCAL_INSTALL_ROOT)/$(1)-$(2)
endef

# --- Package Readiness Check ---
# $(1) = package name, $(2) = package version
define check_package_ready
	@PACKAGE_PATH=$(call package_installed_path,$(1),$(2)); \
	if [ ! -d "$$PACKAGE_PATH" ]; then \
		echo "------------------------------------------------------------"; \
		echo "ERROR: Required package [$(1)] version [$(2)] is missing!"; \
		echo "Expected at: $$PACKAGE_PATH"; \
		echo "Please build it first: make -C 3rdparty/$(1) make_$(1)"; \
		echo "------------------------------------------------------------"; \
		exit 1; \
	else \
		echo "SUCCESS: Found [$(1)-$(2)] at $$PACKAGE_PATH"; \
	fi
endef


# 自动获取某个库安装路径的函数
# 用法: $(call get_install_path,protobuf)
get_install_path = $(call package_installed_path,$(1),$($(shell echo $(1) | tr 'a-z' 'A-Z')_VER))

# 宏：根据库的 DEPS 列表生成该库所需的变量定义
# 参数 1: 目标库名 (例如 PROTOBUF)
define GENERATE_DEPENDENCY_VARS
    # 为 DEPS 列表中的每个项生成 _INSTALL_DIR 变量
    $$(foreach dep_pair,$$($(1)_DEPS),\
        $$(eval _DEP_NAME := $$(word 1,$$(subst :, ,$$(dep_pair)))) \
        $$(eval _DEP_VER_VAR := $$(word 2,$$(subst :, ,$$(dep_pair)))) \
        $$(eval _DEP_UPPER := $$(shell echo $$(_DEP_NAME) | tr 'a-z' 'A-Z')) \
        \
        $$(eval $$(_DEP_UPPER)_INSTALL_DIR := $$(call package_installed_path,$$(_DEP_NAME),$$($$(_DEP_VER_VAR)))) \
    )
endef

# 宏：生成安装检查逻辑
# 参数 1: 目标库名
define GENERATE_CHECK_TARGET
check_$(1)_ready:
	@$$(foreach dep_pair,$$($(1)_DEPS),\
        $$(eval _DEP_NAME := $$(word 1,$$(subst :, ,$$(dep_pair)))) \
        $$(eval _DEP_VER_VAR := $$(word 2,$$(subst :, ,$$(dep_pair)))) \
        $$(call check_package_ready,$$(_DEP_NAME),$$($$(_DEP_VER_VAR))); \
    )
endef


# --- Helper: Environment Check ---
check-env:
	@PY_VER=$$( $(ACTIVATED_PYTHON_BIN) -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" ); \
	if [ "$$PY_VER" != "$(REQUIRED_PY_VER)" ]; then \
		echo "ERROR: Environment mismatch. Expected $(REQUIRED_PY_VER), got $$PY_VER"; \
		exit 1; \
	fi