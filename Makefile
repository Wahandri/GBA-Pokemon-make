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
CHARMAP := charmap.txt

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

$(OBJ)/%.c: $(SRC)/%.c | $(PREPROC)
	@mkdir -p $(dir $@)
	@echo "🔄 Preprocesando: $<"
	$(PREPROC) $< $(CHARMAP) > $@

$(PREPROC):
	@$(MAKE) -C tools/preproc

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
