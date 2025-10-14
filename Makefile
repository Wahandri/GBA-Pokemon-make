# ===============================
# Pokémon Emerald (Modern GCC build)
# ===============================

MODERN_BUILD ?= 1

FILE_NAME := pokeemerald_modern
BUILD_DIR := build/modern
ROM := $(FILE_NAME).gba
ELF := $(FILE_NAME).elf
MAP := $(FILE_NAME).map

PREFIX ?= arm-none-eabi-
CC := $(PREFIX)gcc
AS := $(PREFIX)as
AR := $(PREFIX)ar
OBJCOPY := $(PREFIX)objcopy

EXE :=
ifeq ($(OS),Windows_NT)
EXE := .exe
endif

PREPROC := tools/preproc/preproc$(EXE)
GFX := tools/gbagfx/gbagfx$(EXE)
FIX := tools/gbafix/gbafix$(EXE)
LIBAGB := libagbsyscall/libagbsyscall.a
CHARMAP := charmap.txt

INCBIN_SCRIPT := tools/list_incbin_files.py
INCBIN_FILES := $(shell python3 $(INCBIN_SCRIPT))

SRC := src
ASM := asm
DATA := data
INCLUDE := include
OBJ := $(BUILD_DIR)

C_SRCS := $(shell find $(SRC) -name "*.c")
S_SRCS := $(shell find $(ASM) $(DATA) -name "*.s")

C_OBJS := $(C_SRCS:$(SRC)/%.c=$(OBJ)/%.o)
S_OBJS := $(S_SRCS:%=$(OBJ)/%)
OBJS := $(C_OBJS) $(S_OBJS)

CFLAGS := -mthumb -mthumb-interwork -O2 -Wall -Wextra -Wno-unused-parameter \
          -fno-strict-aliasing -ffast-math -march=armv4t -mtune=arm7tdmi \
          -I$(INCLUDE) -I$(SRC) -std=c99 \
          -DMODERN=$(MODERN_BUILD) -DMODERN_BUILD=$(MODERN_BUILD)

ifeq ($(debug),1)
CFLAGS += -g -DDEBUG
endif

ASFLAGS := -mthumb -mthumb-interwork
LDFLAGS := -T ld_script_modern.ld -Wl,-Map=$(MAP)

LIBPATH := -L"$(dir $(shell $(CC) -mthumb -print-file-name=libgcc.a))" -Llibagbsyscall
LIBS := -lagbsyscall -lc -lgcc -lnosys

all: $(ROM)

$(ROM): $(ELF) | $(FIX)
	$(OBJCOPY) -O binary $< $@
	$(FIX) $@ -p --silent
	@echo "✅ ROM built successfully: $(ROM)"

$(ELF): $(OBJS) $(LIBAGB)
	@echo "Linking ELF..."
	$(CC) -mthumb -mthumb-interwork -march=armv4t -mtune=arm7tdmi $(LDFLAGS) -o $@ $^ $(LIBPATH) $(LIBS)
	@echo "💾 ELF compiled: $(ELF)"

$(OBJ)/%.o: $(OBJ)/%.c
	@mkdir -p $(dir $@)
	@echo "Compiling C: $<"
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/%.c: $(SRC)/%.c $(INCBIN_FILES) | $(PREPROC) $(BUILD_DIR)
	@mkdir -p $(dir $@)
	@echo "Preprocessing: $<"
	$(PREPROC) $< $(CHARMAP) > $@

$(OBJ)/%.o: %.s | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	@echo "Assembling: $<"
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR):
	@mkdir -p $@

$(PREPROC):
	@$(MAKE) -C tools/preproc

$(GFX):
	@$(MAKE) -C tools/gbagfx

$(FIX):
	@$(MAKE) -C tools/gbafix

$(LIBAGB):
	@$(MAKE) -C libagbsyscall

include graphics_file_rules.mk

%.4bpp: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.1bpp: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.8bpp: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.gbapal: %.pal | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.gbapal: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.latfont: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.hwjpnfont: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.fwjpnfont: %.png | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.4bpp.lz: %.4bpp | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.8bpp.lz: %.8bpp | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.gbapal.lz: %.gbapal | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.bin.lz: %.bin | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.4bpp.rl: %.4bpp | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

%.bin.rl: %.bin | $(GFX)
	@mkdir -p $(dir $@)
	$(GFX) $< $@

clean:
	rm -rf $(BUILD_DIR) $(ROM) $(ELF) $(MAP)
	@$(MAKE) -C tools/preproc clean >/dev/null 2>&1 || true
	@$(MAKE) -C tools/gbagfx clean >/dev/null 2>&1 || true
	@$(MAKE) -C tools/gbafix clean >/dev/null 2>&1 || true
	@$(MAKE) -C libagbsyscall clean >/dev/null 2>&1 || true
	@echo "Clean complete"

.PHONY: all clean
