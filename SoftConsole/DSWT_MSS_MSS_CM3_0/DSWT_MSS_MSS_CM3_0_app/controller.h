#ifndef __CONTROLLER_H__
#define __CONTROLLER_H__

#include <inttypes.h>
#include <stdbool.h>

#include "menu.h"
#include "vga.h"
#include "pixy.h"
#include "soundboard.h"

#define CONTROLLER_ADDR 0x40050024

/******************* EXTERNAL VARIABLES *******************/
// menu.h
extern bool started;
extern bool print_state;
extern LCD_Display Display;
extern Menu myMenu;
extern Menu_Essential prev_frame;
extern Selected selected_config;
extern uint8_t line_start[];
extern uint8_t set_cursor_pos[];
extern uint8_t reset[];
extern uint8_t clear_display[];
extern uint8_t backlight_off[];
extern uint8_t clear_line[];
// vga.h
extern volatile int *col_addr1;
extern volatile int *col_addr2;
extern volatile int *col_addr3;
extern volatile int *num_addr0;
extern volatile int *num_addr1;
extern volatile int *num_addr2;
extern int number[10];
extern sq_info sq[8];
extern health_info health[5];
extern int speed;
extern bool dead;
// pixy.h
extern BoundingBox range;
extern Position pos;
extern int score;
extern uint16_t receive_data[14];
// soundboard.h
extern volatile uint8_t* soundboard_addr;
/**********************************************************/

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

volatile uint8_t* command_addr = (uint8_t*)(CONTROLLER_ADDR);
bool changed;

inline void Controller_getCommand(Command* cmd_struct);
void Controller_getAction(Command* cmd_struct, Command* prev_cmd_struct);

#endif
