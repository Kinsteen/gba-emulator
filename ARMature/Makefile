CC = clang++
SRC_EXT = cpp

SRC_DIR = src
INC_DIRS = inc # Can put multiple folder separated by spaces
OUT_DIR = out
BUILD_DIR = build

LIB_NAME = libarmature.a

CFLAGS = -Wall -std=c++11 -O3 -fpic
INCLUDES = $(addprefix -I,$(INC_DIRS))
LIBS =

# Do not touch further

LIB_OUT = $(BUILD_DIR)/$(LIB_NAME)
SRCS = $(shell find $(SRC_DIR) -type f -name '*.$(SRC_EXT)' -not -name '_*') # Exclude sources files that starts with _
OBJS = $(SRCS:$(SRC_DIR)/%.$(SRC_EXT)=$(OUT_DIR)/%.o)
DEPS = $(OBJS:.o=.d)

$(LIB_OUT): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	ar rcs $@ $(OBJS)

# Autobuild dependencies
$(OUT_DIR)/%.o: $(SRC_DIR)/%.$(SRC_EXT)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@

# This line will combine with the one just above, to include
# every dependencies
-include $(DEPS)

.PHONY: test clean mrproper re run bench

test: $(EXEC)
	mangohud --dlsym ./$(EXEC) roms/tests/cpu_instrs/individual/02-interrupts.gb

clean:
	@rm -rf $(OUT_DIR)

mrproper: clean
	@rm -rf $(LIB_OUT)

re: mrproper $(LIB_OUT)

run: $(EXEC)
	./$(EXEC) roms/Pokemon.gb

bench: $(EXEC)
	mangohud --dlsym make run
