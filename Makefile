# Guide to building Lua Modules: http://lua-users.org/wiki/BuildingModules

PKGS = harfbuzz

CFLAGS = -O2 -fpic -std=c99 `pkg-config --cflags $(PKGS)` `pkg-config --cflags lua`
LDFLAGS = -O2 -fpic `pkg-config --libs $(PKGS)`

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    LIBFLAGS = -shared
endif
ifeq ($(UNAME_S),Darwin)
    LIBFLAGS = -bundle -undefined dynamic_lookup -all_load
endif

INST_PREFIX = /usr/local
INST_LIBDIR = $(INST_PREFIX)/lib/lua/5.2
INST_LUADIR = $(INST_PREFIX)/share/lua/5.2

BUILD_DIR := build
C_SRC_ROOT := src/luaharfbuzz
FILES := luaharfbuzz.c
SOURCES := $(FILES:%.c=$(C_SRC_ROOT)/*.c)
OBJECTS := $(FILES:%.c=$(BUILD_DIR)/%.o)

all: luaharfbuzz.so

luaharfbuzz.so: dirs $(OBJECTS)
	$(CC) $(LDFLAGS) $(LIBFLAGS) $(OBJECTS) -o $@

$(BUILD_DIR)/%.o: $(C_SRC_ROOT)/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

test: all
	lua test/harfbuzz_test.lua fonts/notonastaliq.ttf "یہ"

clean:
	rm -rf build *.so

dirs:
	mkdir -p ${BUILD_DIR}

# For use with Luarocks
install: luaharfbuzz.so src/harfbuzz.lua
	cp luaharfbuzz.so $(INST_LIBDIR)
	cp src/harfbuzz.lua $(INST_LUADIR)

.PHONY: all clean test dirs install