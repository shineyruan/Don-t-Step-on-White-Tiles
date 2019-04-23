#ifndef __SOUNDBOARD_H__
#define __SOUNDBOARD_H__

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#define SOUNDBOARD_ADDR 0x40050100

volatile uint8_t* soundboard_addr;

int random_song();

#endif