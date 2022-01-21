CC ?= gcc
CXX ?= g++
C_API_HEADER ?= hello.h
SERVER_BIN ?= hello.cgi
CLIENT_BIN ?= client
GEN_DIR ?= gen
BUILD_DIR ?= build

BIN_DIR ?= $(BUILD_DIR)/bin
OBJ_DIR ?= $(BUILD_DIR)/obj
GSOAP_SRC_DIR ?= gsoap-2.8
SOAPCPP2 ?= soapcpp2 
SOAPCPP2_OPTIONS += -c++11

VPATH += $(GEN_DIR)
VPATH += $(GSOAP_SRC_DIR)/gsoap
CPPFLAGS += -I$(GEN_DIR)


CXX_SRCS += soapC.cpp \
	stdsoap2.cpp 
CXX_OBJS := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(CXX_SRCS))
$(info "CXX_OBJS:${CXX_OBJS}")

CLIENT_CXX_SRCS = \
	soapClient.cpp \
	myapp.cpp
CLIENT_CXX_OBJS := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(CLIENT_CXX_SRCS))
$(info "CLIENT_CXX_OBJS:${CLIENT_CXX_OBJS}")

SERVER_CXX_SRCS = \
	soapServer.cpp \
	hello.cpp
SERVER_CXX_OBJS := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(SERVER_CXX_SRCS))
$(info "SERVER_CXX_OBJS:${SERVER_CXX_OBJS}")

define CREATE_DIR
$(shell test ! -e $1 && mkdir -p $1)
endef

$(call CREATE_DIR,$(BUILD_DIR))
$(call CREATE_DIR,$(BIN_DIR))
$(call CREATE_DIR,$(OBJ_DIR))
$(call CREATE_DIR,$(GEN_DIR))

gen_from_api_header:$(C_API_HEADER)
	$(SOAPCPP2) $(SOAPCPP2_OPTIONS) -d $(GEN_DIR) $<

$(CXX_OBJS):$(OBJ_DIR)/%.o:%.cpp
	@echo ---------------------[build $<]----------------------------------
	$(CXX) $(CXXFLAGS) -c $(CPPFLAGS)  $< -o $@

$(CLIENT_CXX_OBJS):$(OBJ_DIR)/%.o:%.cpp
	@echo ---------------------[build $<]----------------------------------
	$(CXX) $(CXXFLAGS) -c $(CPPFLAGS)  $< -o $@

$(SERVER_CXX_OBJS):$(OBJ_DIR)/%.o:%.cpp
	@echo ---------------------[build $<]----------------------------------
	$(CXX) $(CXXFLAGS) -c $(CPPFLAGS)  $< -o $@	

$(BIN_DIR)/$(CLIENT_BIN):$(CXX_OBJS) $(CLIENT_CXX_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

$(BIN_DIR)/$(SERVER_BIN):$(CXX_OBJS) $(SERVER_CXX_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

client: $(BIN_DIR)/$(CLIENT_BIN)

server: $(BIN_DIR)/$(SERVER_BIN)

all: client server

clean:
	rm -rf $(GEN_DIR)
	rm -rf $(BIN_DIR)
	rm -rf $(OBJ_DIR)
	rm -rf $(BUILD_DIR)