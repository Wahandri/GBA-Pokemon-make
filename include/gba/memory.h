#ifndef GUARD_GBA_MEMORY_H
#define GUARD_GBA_MEMORY_H

#include "gba/types.h"

// Definiciones básicas de la memoria del GBA
#define EWRAM_START 0x02000000
#define IWRAM_START 0x03000000
#define VRAM_START  0x06000000
#define OAM_START   0x07000000
#define PLTT        0x05000000

#define EWRAM_SIZE  0x40000
#define IWRAM_SIZE  0x8000
#define VRAM_SIZE   0x18000
#define OAM_SIZE    0x400
#define PLTT_SIZE   0x400

#define EWRAM ((vu8 *)EWRAM_START)
#define IWRAM ((vu8 *)IWRAM_START)
#define VRAM  ((vu8 *)VRAM_START)
#define OAM   ((vu8 *)OAM_START)
#define PLTT_MEM ((vu16 *)PLTT)

// Registros DMA
#define REG_DMA0SAD (*(vu32*)0x040000B0)
#define REG_DMA0DAD (*(vu32*)0x040000B4)
#define REG_DMA0CNT (*(vu32*)0x040000B8)
#define REG_DMA1SAD (*(vu32*)0x040000BC)
#define REG_DMA1DAD (*(vu32*)0x040000C0)
#define REG_DMA1CNT (*(vu32*)0x040000C4)
#define REG_DMA2SAD (*(vu32*)0x040000C8)
#define REG_DMA2DAD (*(vu32*)0x040000CC)
#define REG_DMA2CNT (*(vu32*)0x040000D0)
#define REG_DMA3SAD (*(vu32*)0x040000D4)
#define REG_DMA3DAD (*(vu32*)0x040000D8)
#define REG_DMA3CNT (*(vu32*)0x040000DC)

#endif // GUARD_GBA_MEMORY_H
