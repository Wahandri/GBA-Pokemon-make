#ifndef GUARD_GBA_GBA_H
#define GUARD_GBA_GBA_H

// ======= GBA Wahandri Fix =======
// Agrega tipos y estructuras faltantes cuando se compila con GCC moderno
#include "gba/types.h"
#include "gba/defines.h"
#include "gba/io_reg.h"
#include "gba/memory.h"
#include "gba/oam.h"
#include "gba/syscall.h"
#include "gba/macro.h"
// ======= Fin del fix =======
#include "gba/multiboot.h"
#include "gba/isagbprint.h"

#endif // GUARD_GBA_GBA_H
