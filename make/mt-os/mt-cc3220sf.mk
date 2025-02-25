# Copyright (c) 2003-2018, Xively All rights reserved.
#
# This is part of the Xively C Client library,
# it is licensed under the BSD 3-Clause license.
#  GN:
#    s/XI_/IOTC_/g


include make/mt-os/mt-os-common.mk

CC32XX ?= 0

###
## COMPILER NAME
###
COMPILER ?= ti-cgt-arm_18.1.3.LTS

###
## MAC HOST OS
###
ifeq ($(IOTC_HOST_PLATFORM),Darwin)
	# osx cross-compilation downloads

	IOTC_CC3220SF_PATH_CCS_TOOLS ?= /Applications/ti/ccsv7/tools
	IOTC_CC3220SF_PATH_SDK ?= /Applications/ti/simplelink_cc32xx_sdk_1_50_00_06
	IOTC_CC3220SF_PATH_XDC_SDK ?= /Applications/ti/xdctools_3_50_04_43_core


	CC = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armcl
	AR = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armar

	IOTC_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/include

###
## WINDOWS HOST OS
###
else ifneq (,$(findstring Windows,$(IOTC_HOST_PLATFORM)))
	 # windows cross-compilation

    IOTC_CC3220SF_PATH_CCS_TOOLS ?= C:/ti/ccsv8/tools

	IOTC_CC3220SF_PATH_SDK ?= C:/ti/simplelink_cc32xx_sdk_2_10_00_04
	IOTC_CC3220SF_PATH_XDC_SDK ?= C:/ti/xdctools_3_50_05_12_core

	CC = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armcl
	AR = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armar

	IOTC_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/include

###
## LINUX HOST OS
###
else ifeq ($(IOTC_HOST_PLATFORM),Linux)
	# linux cross-compilation prerequisite downloads

#GN:	IOTC_CC3220SF_PATH_CCS_TOOLS ?= $(HOME)/Downloads/xi_artifactory/ti/ccsv6/tools
#GN:	IOTC_CC3220SF_PATH_SDK ?= $(HOME)/Downloads/xi_artifactory/ti/CC3220SDK_1.2.0/cc3220-sdk

	IOTC_CC3220SF_PATH_CCS_TOOLS ?= /opt/ti/ccsv8/tools
	IOTC_CC3220SF_PATH_SDK ?= /opt/ti/simplelink_cc32xx_sdk_2_10_00_04/
	IOTC_CC3220SF_PATH_XDC_SDK ?= /opt/ti/xdctools_3_50_04_43_core
	
	CC = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armcl
	AR = $(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/bin/armar

	IOTC_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/include

### TOOLCHAIN AUTODOWNLOAD SECTION --- BEGIN
	IOTC_BUILD_PRECONDITIONS := $(CC)

$(CC):
	git clone https://github.com/atigyi/xi_artifactory.git ~/Downloads/xi_artifactory
	git -C ~/Downloads/xi_artifactory checkout feature/cc3220_dependencies
	$@ --version
### TOOLCHAIN AUTODOWNLOAD SECTION --- END
endif

# removing these compiler flags since they are not parsed and emit warnings
IOTC_COMMON_COMPILER_FLAGS_TMP := $(filter-out -Wall -Werror -Wno-pointer-arith -Wno-format -Wextra -Os -g -O0, $(IOTC_COMMON_COMPILER_FLAGS))
IOTC_COMMON_COMPILER_FLAGS = $(IOTC_COMMON_COMPILER_FLAGS_TMP)

IOTC_COMMON_COMPILER_FLAGS += -mv7M4
IOTC_COMMON_COMPILER_FLAGS += -me
IOTC_COMMON_COMPILER_FLAGS += --define=css
IOTC_COMMON_COMPILER_FLAGS += --define=cc3200
IOTC_COMMON_COMPILER_FLAGS += --define=WOLFSSL_NOOS_XIVELY
IOTC_COMMON_COMPILER_FLAGS += --define=SL_OTA_ARCHIVE_STANDALONE
IOTC_COMMON_COMPILER_FLAGS += --display_error_number
IOTC_COMMON_COMPILER_FLAGS += --diag_warning=225
IOTC_COMMON_COMPILER_FLAGS += --diag_wrap=off
IOTC_COMMON_COMPILER_FLAGS += --abi=eabi
IOTC_COMMON_COMPILER_FLAGS += --opt_for_speed=0
IOTC_COMMON_COMPILER_FLAGS += --code_state=16
IOTC_COMMON_COMPILER_FLAGS += --float_support=vfplib
IOTC_COMMON_COMPILER_FLAGS += --preproc_with_compile
IOTC_COMMON_COMPILER_FLAGS += --preproc_dependency=$(@:.o=.d)
IOTC_COMMON_COMPILER_FLAGS += --obj_directory=$(dir $@)
IOTC_COMMON_COMPILER_FLAGS += --asm_directory=$(dir $@)
IOTC_COMPILER_OUTPUT += --output_file=$@

ifneq (,$(findstring release,$(TARGET)))
    IOTC_COMMON_COMPILER_FLAGS += -O4
endif

ifneq (,$(findstring debug,$(TARGET)))
    IOTC_COMMON_COMPILER_FLAGS += -O0 -g
endif

IOTC_COMMON_COMPILER_FLAGS += -DCC32XX_COMPAT=1
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/devices/cc32xx/driverlib
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/posix/ccs
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/drivers
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/drivers/net
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/drivers/net/wifi
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/net
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/net/bsd
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/net/bsd/sys
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/net/bsd/arpa
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/net/ota/source
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/source/ti/devices/cc32xx/inc

# GN: file "ti/sysbios/BIOS.h" .../simplelink_cc32xx_sdk_2_10_00_04/kernel/tirtos/packages/ti/sysbios/BIOS.h
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_SDK)/kernel/tirtos/packages

# GN: where the heck my flag .. (stdint.h)
IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_CCS_TOOLS)/compiler/$(COMPILER)/include

IOTC_COMMON_COMPILER_FLAGS += -I$(IOTC_CC3220SF_PATH_XDC_SDK)/packages


# Xively Client config flags
IOTC_CONFIG_FLAGS += -DIOTC_CROSS_TARGET
IOTC_CONFIG_FLAGS += -DIOTC_EMBEDDED_TESTS
IOTC_CONFIG_FLAGS += -DIOTC_DEBUG_PRINTF=Report
#IOTC_CONFIG_FLAGS += -DIOTC_CC3220SF_UNSAFELY_DISABLE_CERT_STORE #Will also disable the store's CRL

# wolfssl API
IOTC_CONFIG_FLAGS += -DNO_WRITEV
IOTC_CONFIG_FLAGS += -DSINGLE_THREADED
IOTC_CONFIG_FLAGS += -DNO_WOLFSSL_DIR 
IOTC_CONFIG_FLAGS += -DWOLFSSL_USER_IO 
IOTC_CONFIG_FLAGS += -DHAVE_OCSP
IOTC_CONFIG_FLAGS += -DTLSLIB_WOLFSSL


IOTC_ARFLAGS := r $(XI)
# GN: i don't think so ... IOTC_LIB_FLAGS := -llibxively.a

IOTC_POST_COMPILE_ACTION =
