DFT_ROOT_DIR = ThirdParty/DFT
DFT_SRC_DIR = ${DFT_ROOT_DIR}/src
DFT_INCLUDE_DIR = ${DFT_ROOT_DIR}/include
DFT_HEADER_DIR = ${DFT_INCLUDE_DIR}/mtf/${DFT_ROOT_DIR}
DFT_LIB_NAME = $(addsuffix ${LIB_POST_FIX}, dft)
DFT_LIB_SO =  $(addprefix lib, $(addsuffix .so, ${DFT_LIB_NAME}))
ISMAR_DEMO_DIR=${DFT_SRC_DIR}/ISMAR_Demo
DFT_BUILD_TARGET = libCppRelease

dft ?= 0
dft_exe ?= 0
ifeq ($(OS),Windows_NT)
THIRD_PARTY_RUNTIME_FLAGS += -D DISABLE_DFT
else
ifeq (${dft}, 0)
THIRD_PARTY_RUNTIME_FLAGS += -D DISABLE_DFT
else
THIRD_PARTY_TRACKERS += DFT
_THIRD_PARTY_TRACKERS_SO += ${DFT_LIB_NAME} 
THIRD_PARTY_TRACKERS_SO_LOCAL +=  ${DFT_ROOT_DIR}/${DFT_LIB_SO}
THIRD_PARTY_LIBS_DIRS += -L${DFT_ROOT_DIR}
THIRD_PARTY_HEADERS += ${DFT_HEADERS} ${DFT_LIB_HEADERS} 
THIRD_PARTY_INCLUDE_DIRS += ${DFT_INCLUDE_DIR}
endif
endif
ifeq (${dft_exe}, 1)
DFT_BUILD_TARGET = all
endif

DFT_HEADERS = $(addprefix  ${DFT_HEADER_DIR}/, DFT.h)
DFT_LIB_MODULES = Utilities Homography IterativeOptimization  
DFT_LIB_INCLUDES = HomographyEstimation Typedefs
DFT_LIB_HEADERS = $(addprefix ${DFT_HEADER_DIR}/,$(addsuffix .hpp, ${DFT_LIB_MODULES} ${DFT_LIB_INCLUDES}))
DFT_LIB_SRC = $(addprefix ${DFT_SRC_DIR}/,$(addsuffix .cpp, ${DFT_LIB_MODULES}))

${BUILD_DIR}/DFT.o: ${DFT_SRC_DIR}/DFT.cc ${DFT_HEADERS} ${UTILITIES_HEADER_DIR}/miscUtils.h ${MACROS_HEADER_DIR}/common.h ${ROOT_HEADER_DIR}/TrackerBase.h
	${CXX} -c ${MTF_PIC_FLAG} ${WARNING_FLAGS} ${OPT_FLAGS} ${MTF_COMPILETIME_FLAGS} $< ${OPENCV_FLAGS} -I${DFT_INCLUDE_DIR} -I${UTILITIES_INCLUDE_DIR} -I${MACROS_INCLUDE_DIR} -I${ROOT_INCLUDE_DIR} -o $@
	
${MTF_LIB_INSTALL_DIR}/${DFT_LIB_SO}: ${DFT_ROOT_DIR}/${DFT_LIB_SO}
	${MTF_LIB_INSTALL_CMD_PREFIX} cp -f $< $@
${DFT_ROOT_DIR}/${DFT_LIB_SO}: ${DFT_LIB_SRC} ${DFT_LIB_HEADERS} ${ISMAR_DEMO_DIR}/main.cpp
	$(MAKE) ${DFT_BUILD_TARGET} -C ${DFT_ROOT_DIR} --no-print-directory LIB_CPP=${DFT_LIB_SO}
