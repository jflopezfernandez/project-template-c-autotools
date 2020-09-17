
CP              := cp -f
RM              := rm -f
RMDIR           := rm -rf
MKDIR           := mkdir -p

CC              := gcc
CFLAGS          := -std=gnu18 -Wall -Wextra -O3 -march=native
CPPFLAGS        := -I./include -D_GNU_SOURCE
LDFLAGS         := -Wl,-O -Wl,--strip-all -Wl,--reduce-memory-overheads -Wl,--relax
TARGET_ARCH     := -Wl,--format=elf64-x86-64
LOADLIBES       := 
LDLIBS          := 

PROJECT_NAME    := project-name 
PROJECT_VERSION := 0.0.1

DIST_DIR        := $(strip $(PROJECT_NAME))-$(strip $(PROJECT_VERSION))

vpath %.c src

SRCS            := $(notdir $(wildcard src/*.c))
OBJS            := $(patsubst %.c,%.o,$(SRCS))

TARGET          := project-name

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $<

dist: $(DIST_DIR).tar.gz

$(DIST_DIR).tar.gz: $(DIST_DIR)
	tar chof - $(DIST_DIR) | gzip -9 -c > $@
	$(RMDIR) $(DIST_DIR)

$(DIST_DIR): $(SRCS)
	$(MKDIR) $(DIST_DIR)/src $(DIST_DIR)/include
	$(CP) Makefile $(DIST_DIR)
	$(CP) $(wildcard src/*.c) $(DIST_DIR)/src
	$(CP) $(wildcard include/*.h) $(DIST_DIR)/include

install: $(TARGET)
	@echo "This target has not been implemented yet, sorry!"

.PHONY: clean
clean:
	$(RM) $(OBJS) $(TARGET)

# Remove files created as a result of the autoconf and
# configure invocations.
#
# 	Autoconf Files and Directories:
#
# 		- configure
# 		- autom4te.cache
#
# 	Configure-created files and directories:
#
#		- config.log
# 		- config.status
#
.PHONY: distclean
distclean: clean
	$(RM) configure config.log config.status
	$(RMDIR) autom4te.cache
