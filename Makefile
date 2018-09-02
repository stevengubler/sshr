
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

# CC
CC := clang

# Compiler Flags
CFLAGS := -c
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

# Gets the corresponding object file when a current target ($@) is an source file.
OBJECT_FROM_SOURCE = $(shell echo $@ | awk '{ print "build/" $$1}' | sed 's/.c$$/.o/')

# Gets a list of all the files a file uses from #include directives
C_INCLUDES = $(shell sed -n -r 's/\#include\s+"(.*)"/\1/p' $@ | awk '{print "$(shell dirname $@)/" $$1}')


# ----------------------------------------------
# Targets --------------------------------------

$(TARGET): $(OBJECTS)
	@if [ ! -d $(TARGETDIR) ]; then mkdir -p $(TARGETDIR); fi
	@echo "Linking $(TARGET)... " 
	@$(CC) $^ -o $(TARGET) $(LIB)
	@echo "Done." 

.SECONDEXPANSION:
$(OBJECTS): $$(SOURCE_FROM_OBJECT)
	@[ -d $(@D) ] || mkdir -p $(@D)
	@echo -e "Compiling $(COLOR_YELLOW)$<$(COLOR_DEFAULT)... "
	@$(CC) $(CFLAGS) $(INC) -c -o $@ $<
	@echo -e "Done." 

.SECONDEXPANSION:
$(SOURCES): $$(C_INCLUDES)
	@touch $@
	@echo -e "$(COLOR_BLUE)\`$@\`$(COLOR_DEFAULT) has been updated."

.SECONDEXPANSION:
$(HEADERS): $$(C_INCLUDES)
	@touch $@
	@echo -e "$(COLOR_BLUE)\`$@\`$(COLOR_DEFAULT) has been updated."

all: $(TARGET)

run: $(TARGET)
	@./$(TARGET)

clean:
	@printf "Cleaning targets... "
	@if [ -d $(TARGETDIR) ]; then rm -r $(TARGETDIR); fi
	@printf "Done.\n" 
	@printf "Cleaning objects... "
	@if [ -d $(BUILDDIR) ]; then rm -r $(BUILDDIR); fi
	@printf "Done.\n" 

info:
	@echo -e "$(COLOR_GREEN)CC            $(COLOR_YELLOW)| $(COLOR_DEFAULT)$(CC)"
	@echo -e "$(COLOR_GREEN)OBJECTS       $(COLOR_YELLOW)| $(COLOR_DEFAULT)$(OBJECTS)"
	@echo -e "$(COLOR_GREEN)SOURCES       $(COLOR_YELLOW)| $(COLOR_DEFAULT)$(SOURCES)"

.PHONY: all clean run

