# Made by:      Steven Gubler <stevegubler@protonmail.com>
# Last updated: September 2018

# CC
CC := clang

# Compiler Flags CFLAGS := -c
LIB :=

# Folders
SRCDIR := src
BUILDDIR := build
TARGETDIR := bin

# Targets
EXECUTABLE := wren-test
TARGET := $(TARGETDIR)/$(EXECUTABLE)

# File Extenstions
SRCEXT := c
HEADEREXT := h
OBJECTEXT := o


# Code Lists
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
HEADERS := $(shell find $(SRCDIR) -type f -name *.$(HEADEREXT))
OBJECTS := $(shell echo $(SOURCES) | awk 'BEGIN { RS=" " } { print "build/" $$1 }' | sed 's/.c$$/.o/')

# ----------------------------------------------
# Macros ---------------------------------------

# Gets the corresponding source file when a current target ($@) is an object file.
SOURCE_FROM_OBJECT = $(shell echo $@ | sed 's/build\///' | sed 's/.o$$/.c/')

# Gets a list of all the files a file uses from #include directives
C_INCLUDES = $(shell sed -n -r 's/\#include\s+"(.*)"/\1/p' $@ | awk '{print "$(shell dirname $@)/" $$1}')

#-----------------------------
# Colors ---------------------

COLOR_DEFAULT      := \033[0m

COLOR_BLACK        := \033[0;30m
COLOR_RED          := \033[0;31m
COLOR_GREEN        := \033[0;32m
COLOR_BROWN        := \033[0;33m
COLOR_BLUE         := \033[0;34m
COLOR_PURPLE       := \033[0;35m
COLOR_CYAN         := \033[0;36m
COLOR_LIGHT_GRAY   := \033[0;37m
COLOR_DARK_GRAY    := \033[1;30m
COLOR_LIGHT_RED    := \033[1;31m
COLOR_LIGHT_GREEN  := \033[1;32m
COLOR_YELLOW       := \033[1;33m
COLOR_LIGHT_BLUE   := \033[1;34m
COLOR_LIGHT_PURPLE := \033[1;35m
COLOR_LIGHT_CYAN   := \033[1;36m
COLOR_WHITE        := \033[1;37m

# ----------------------------------------------
# Color Shortcuts ------------------------------

yel := $(COLOR_YELLOW)
def := $(COLOR_DEFAULT)
blu := $(COLOR_BLUE)
gre := $(COLOR_GREEN)

# ----------------------------------------------
# Targets --------------------------------------

$(TARGET): $(OBJECTS)
	@if [ ! -d $(TARGETDIR) ]; then mkdir -p $(TARGETDIR); fi
	@echo -e "$(gre)Linking$(def) $(yel)$(TARGET)$(def)... " 
	$(CC) $^ -o $(TARGET) $(LIB)
	@echo -e "$(blu)Done.$(def)"

.SECONDEXPANSION:
$(OBJECTS): $$(SOURCE_FROM_OBJECT)
	@[ -d $(@D) ] || mkdir -p $(@D)
	@echo -e "$(gre)Compiling$(def) $(yel)$<$(def)... "
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<
	@echo -e "$(blu)Done.$(def)"

.SECONDEXPANSION:
$(SOURCES): $$(C_INCLUDES)
	@touch $@
	@echo -e "$(yel)\`$@\`$(yel) has been updated."

.SECONDEXPANSION:
$(HEADERS): $$(C_INCLUDES)
	@touch $@
	@echo -e "$(yel)\`$@\`$(def) has been updated."

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

clean:
	@echo -e "$(gre)Cleaning$(def) targets... "
	@if [ -d $(TARGETDIR) ]; then rm -r $(TARGETDIR); fi
	@echo -e "$(blu)Done.$(def)"
	@echo -e "$(gre)Cleaning$(def) objects... "
	@if [ -d $(BUILDDIR) ]; then rm -r $(BUILDDIR); fi
	@echo -e "$(blu)Done.$(def)"

info:
	@echo -e "$(gre)CC            $(yel)|$(def) $(CC)"
	@echo -e "$(gre)LIB           $(yel)|$(def) $(LIB)"
	@echo -e "$(gre)SRCDIR        $(yel)|$(def) $(SRCDIR)"
	@echo -e "$(gre)BUILDDIR      $(yel)|$(def) $(BUILDDIR)"
	@echo -e "$(gre)TARGETDIR     $(yel)|$(def) $(TARGETDIR)"
	@echo -e "$(gre)EXECUTABLE    $(yel)|$(def) $(EXECUTABLE)"
	@echo -e "$(gre)TARGET        $(yel)|$(def) $(TARGET)"
	@echo -e "$(gre)SRCEXT        $(yel)|$(def) $(SRCEXT)"
	@echo -e "$(gre)HEADEREXT     $(yel)|$(def) $(HEADEREXT)"
	@echo -e "$(gre)OBJECTEXT     $(yel)|$(def) $(OBJECTEXT)"
	@echo -e "$(gre)SOURCES       $(yel)|$(def) $(SOURCES)"
	@echo -e "$(gre)HEADERS       $(yel)|$(def) $(HEADERS)"
	@echo -e "$(gre)OBJECTS       $(yel)|$(def) $(OBJECTS)"

.PHONY: all clean run info

