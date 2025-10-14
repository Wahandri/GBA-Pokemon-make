# ===============================
# Pokémon Wahandri Edition (Modern)
# Compilación rápida con devkitARM GCC moderno
# ===============================

TITLE       := POKEMON EMER
GAME_CODE   := BPEE
MAKER_CODE  := 01
REVISION    := 0

FILE_NAME := pokeemerald_modern
BUILD_DIR := build/modern
ROM := $(FILE_NAME).gba
ELF := $(FILE_NAME).elf
MAP := $(FILE_NAME).map

# Toolchain (devkitARM)
PREFIX := arm-none-eabi-
CC := $(PREFIX)gcc
LD := $(PREFIX)ld
AS := $(PREFIX)as
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
FIX := tools/gbafix/gbafix.exe

EXE :=
ifeq ($(OS),Windows_NT)
EXE := .exe
endif

PREPROC := tools/preproc/preproc$(EXE)
GFX := tools/gbagfx/gbagfx$(EXE)
CHARMAP := charmap.txt

INCBIN_SCRIPT := tools/list_incbin_files.py
INCBIN_FILES := $(shell python3 $(INCBIN_SCRIPT))

# Directorios
SRC := src
ASM := asm
DATA := data
INCLUDE := include
OBJ := $(BUILD_DIR)

# Archivos fuente
C_SRCS := $(shell find $(SRC) -name "*.c")
S_SRCS := $(shell find $(ASM) $(DATA) -name "*.s")

# Archivos objeto
C_OBJS := $(C_SRCS:$(SRC)/%.c=$(OBJ)/%.o)
S_OBJS := $(S_SRCS:%=$(OBJ)/%)
OBJS := $(C_OBJS) $(S_OBJS)

# Flags del compilador moderno
CFLAGS := -mthumb -mthumb-interwork -O2 -Wall -Wextra -Wno-unused-parameter \
          -fno-strict-aliasing -ffast-math -march=armv4t -mtune=arm7tdmi \
          -I$(INCLUDE) -I$(SRC) -std=c99 -DMODERN_BUILD=1

ASFLAGS := -mthumb -mthumb-interwork
LDFLAGS := -Map $(MAP) -T ld_script_modern.ld

# Librerías del sistema
LIBPATH := -L"$(dir $(shell $(CC) -mthumb -print-file-name=libgcc.a))"
LIBS := -lc -lgcc -lnosys

# ===============================
# Reglas principales
# ===============================

all: $(ROM)

$(ROM): $(ELF)
	$(OBJCOPY) -O binary $< $@
	$(FIX) $@ -p --silent
	@echo "✅ ROM generada correctamente: $(ROM)"

$(ELF): $(OBJS)
	@echo "🔧 Enlazando ELF..."
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBPATH) $(LIBS)
	@echo "💾 ELF compilado: $@"

$(OBJ)/%.o: $(OBJ)/%.c
	@mkdir -p $(dir $@)
	@echo "🧩 Compilando C: $<"
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/%.c: $(SRC)/%.c $(INCBIN_FILES) | $(PREPROC)
	@mkdir -p $(dir $@)
	@echo "🔄 Preprocesando: $<"
	$(PREPROC) $< $(CHARMAP) > $@

$(PREPROC):
	@$(MAKE) -C tools/preproc

$(GFX):
	@$(MAKE) -C tools/gbagfx

# Generic graphics conversion rules
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

include graphics_file_rules.mk

$(OBJ)/%.o: %.s
	@mkdir -p $(dir $@)
	@echo "🪄 Ensamblando ASM: $<"
	$(AS) $(ASFLAGS) $< -o $@

clean:
	@echo "🧹 Limpiando compilación..."
	rm -rf $(BUILD_DIR) $(ROM) $(ELF) $(MAP)
	@echo "✅ Limpieza completada"

# ===============================
# Info & Ayuda
# ===============================
help:
	@echo ""
	@echo "💡 Comandos disponibles:"
	@echo "  make            → Compila el juego (modern build)"
	@echo "  make clean      → Limpia los archivos de compilación"
	@echo "  make debug=1    → Compila con símbolos de depuración"
	@echo ""

# ===============================
# Opcional: debug build
# ===============================
ifdef debug
CFLAGS += -g -DDEBUG
endif
