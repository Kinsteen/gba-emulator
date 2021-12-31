CC = clang++
SRC_EXT = cpp

SRC_DIR = src
STATIC_DIRS = ARMature
INC_DIRS = inc $(addsuffix /inc,$(STATIC_DIRS)) # Can put multiple folder separated by spaces
OUT_DIR = out
BUILD_DIR = build

EXEC_NAME = gbemu

CFLAGS = -Wall -std=c++11 -O3
INCLUDES = $(addprefix -I,$(INC_DIRS))
LIBS = -lSDL2main -lSDL2
STATIC_LIBS = $(foreach LIB,$(STATIC_DIRS),$(LIB)/build/lib$(shell echo $(LIB) | tr '[:upper:]' '[:lower:]').a)

# Do not touch further

EXEC = $(BUILD_DIR)/$(EXEC_NAME)
SRCS = $(shell find $(SRC_DIR) -type f -name '*.$(SRC_EXT)' -not -name '_*') # Exclude sources files that starts with _
OBJS = $(SRCS:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%.o)
DEPS = $(OBJS:.o=.d)

$(EXEC): $(OBJS) $(STATIC_DIRS)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(OBJS) $(LIBS) $(STATIC_LIBS) -o $@

$(STATIC_DIRS):
	$(MAKE) -C $@

# Autobuild dependencies
$(OUT_DIR)/%.o: $(SRC_DIR)/%.$(SRC_EXT)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@

# This line will combine with the one just above, to include
# every dependencies
-include $(DEPS)

.PHONY: test clean mrproper re run bench $(STATIC_DIRS)

test: $(EXEC)
	mangohud --dlsym ./$(EXEC) roms/tests/cpu_instrs/individual/02-interrupts.gb

clean:
	$(foreach LIB,$(STATIC_DIRS),$(MAKE) -C $(LIB) clean)
	@rm -rf $(OUT_DIR)

mrproper: clean
	$(foreach LIB,$(STATIC_DIRS),$(MAKE) -C $(LIB) mrproper)
	@rm -rf $(EXEC)

re: mrproper $(EXEC)

run: $(EXEC)
	./$(EXEC) roms/Pokemon.gb

bench: $(EXEC)
	mangohud --dlsym make run
