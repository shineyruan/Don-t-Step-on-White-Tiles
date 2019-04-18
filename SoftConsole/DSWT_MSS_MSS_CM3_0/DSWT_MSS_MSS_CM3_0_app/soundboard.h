#ifndef __SOUNDBOARD_H__
#define __SOUNDBOARD_H__

#include <inttypes.h>
#include <stdio.h>

#define SOUNDBOARD_ADDR 0x40050100

static volatile uint8_t* soundboard_addr = (uint8_t*)(SOUNDBOARD_ADDR);

#endif
