#ifndef __CONTROLLER_H__
#define __CONTROLLER_H__

#include <inttypes.h>
#include <stdbool.h>

typedef struct Controller {
    /* data */
    bool right;
    bool left;
    bool down;
    bool up;
    bool start;
    bool select;
    bool button_b;
    bool button_a;
} Command;

static volatile uint8_t* command_addr = (uint8_t*)(0x40050000);

void Controller_getCommand(Command* cmd_struct);

#endif