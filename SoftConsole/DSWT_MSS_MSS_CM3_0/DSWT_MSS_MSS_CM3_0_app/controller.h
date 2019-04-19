#ifndef __CONTROLLER_H__
#define __CONTROLLER_H__

#include <inttypes.h>
#include <stdbool.h>

#include "menu.h"
#include "vga.h"

#define CONTROLLER_ADDR 0x40050024

extern volatile uint8_t *soundboard_addr;
extern uint16_t receive_data[];

extern uint8_t line_start[];
extern uint8_t set_cursor_pos[];
extern uint8_t reset[];
extern uint8_t clear_display[];
//0..9: col_width 10..19: col1 20..29: col2
extern volatile int *col_addr1;
//0..9: col3 10..19: col4 20..29: col5
extern volatile int *col_addr2;
//0..9: length of column: 480
extern volatile int *col_addr3;

extern volatile int *num_addr0;
extern volatile int *num_addr1;
extern volatile int *num_addr2;
extern int number[];
extern sq_info sq[8];
extern health_info health[5];
extern int speed;

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

static volatile uint8_t* command_addr = (uint8_t*)(CONTROLLER_ADDR);
bool changed;

inline void Controller_getCommand(Command* cmd_struct);
void Controller_getAction(Command* cmd_struct, Command* prev_cmd_struct);

#endif
