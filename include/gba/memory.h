#ifndef GUARD_GBA_MEMORY_H
#define GUARD_GBA_MEMORY_H

#include "gba/types.h"

#ifndef EWRAM_START
#define EWRAM_START 0x02000000
#endif

#ifndef IWRAM_START
#define IWRAM_START 0x03000000
#endif

#ifndef VRAM
#define VRAM 0x06000000
#endif

#ifndef OAM
#define OAM 0x07000000
#endif

#ifndef PLTT
#define PLTT 0x05000000
#endif

#ifndef EWRAM_SIZE
#define EWRAM_SIZE 0x40000
#endif

#ifndef IWRAM_SIZE
#define IWRAM_SIZE 0x8000
#endif

#ifndef VRAM_SIZE
#define VRAM_SIZE 0x18000
#endif

#ifndef OAM_SIZE
#define OAM_SIZE 0x400
#endif

#ifndef PLTT_SIZE
#define PLTT_SIZE 0x400
#endif

#define EWRAM ((vu8 *)EWRAM_START)
#define IWRAM ((vu8 *)IWRAM_START)
#define VRAM_PTR ((vu8 *)VRAM)
#define OAM_PTR ((vu8 *)OAM)
#define PLTT_MEM ((vu16 *)PLTT)

#ifndef REG_DMA0SAD
#define REG_DMA0SAD (*(vu32 *)0x040000B0)
#endif
#ifndef REG_DMA0DAD
#define REG_DMA0DAD (*(vu32 *)0x040000B4)
#endif
#ifndef REG_DMA0CNT
#define REG_DMA0CNT (*(vu32 *)0x040000B8)
#endif
#ifndef REG_DMA1SAD
#define REG_DMA1SAD (*(vu32 *)0x040000BC)
#endif
#ifndef REG_DMA1DAD
#define REG_DMA1DAD (*(vu32 *)0x040000C0)
#endif
#ifndef REG_DMA1CNT
#define REG_DMA1CNT (*(vu32 *)0x040000C4)
#endif
#ifndef REG_DMA2SAD
#define REG_DMA2SAD (*(vu32 *)0x040000C8)
#endif
#ifndef REG_DMA2DAD
#define REG_DMA2DAD (*(vu32 *)0x040000CC)
#endif
#ifndef REG_DMA2CNT
#define REG_DMA2CNT (*(vu32 *)0x040000D0)
#endif
#ifndef REG_DMA3SAD
#define REG_DMA3SAD (*(vu32 *)0x040000D4)
#endif
#ifndef REG_DMA3DAD
#define REG_DMA3DAD (*(vu32 *)0x040000D8)
#endif
#ifndef REG_DMA3CNT
#define REG_DMA3CNT (*(vu32 *)0x040000DC)
#endif

#endif // GUARD_GBA_MEMORY_H
