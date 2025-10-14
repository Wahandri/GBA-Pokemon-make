#ifndef GUARD_GBA_OAM_H
#define GUARD_GBA_OAM_H

#include "gba/types.h"

// Definición moderna de los datos de OAM (sprites)
struct OamData
{
    u16 attr0;
    u16 attr1;
    u16 attr2;
    s16 filler;
};

// Estructuras auxiliares para rotaciones/afines (usadas en syscall.h)
struct BgAffineSrcData
{
    s32 texX;
    s32 texY;
    s16 scrX;
    s16 scrY;
    s16 sx;
    s16 sy;
    u16 alpha;
};

struct BgAffineDstData
{
    s16 pa;
    s16 pb;
    s16 pc;
    s16 pd;
    s32 xRef;
    s32 yRef;
};

struct ObjAffineSrcData
{
    s16 sx;
    s16 sy;
    s16 alpha;
    s16 px;
    s16 py;
};

#endif // GUARD_GBA_OAM_H
