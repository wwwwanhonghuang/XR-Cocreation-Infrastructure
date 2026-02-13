REPOSITORY_ROOT ?= $(PWD)/../..
NORMALIZED_REPOSITORY_ROOT := $(shell realpath $(REPOSITORY_ROOT))
PATCHES_ROOT := $(NORMALIZED_REPOSITORY_ROOT)/env-preparation/patches/

patch_all: patch_openpose_src

patch_openpose_src:
	cp -rT ${PATCHES_ROOT}/openpose ${NORMALIZED_REPOSITORY_ROOT}/openpose
