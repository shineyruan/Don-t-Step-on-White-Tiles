#ifndef __MENU_H__
#define __MENU_H__

#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include "drivers/mss_uart/mss_uart.h"

#define CURSOR_POS_BASE 0x80

typedef struct LCD {
    /* data */
    uint8_t curr_line_num;
    uint8_t line_1[20];
    uint8_t line_2[20];
    uint8_t line_3[20];
    uint8_t line_4[20];
} LCD_Display;

typedef struct menu
{
    /* 1 for up, 0 for down. */
    int scroll_history;
    int curr_selection;
    uint8_t layer_1[6][20];
} Menu;


static uint8_t line_start[] = {0, 64, 20, 84};
static LCD_Display Display;
static Menu myMenu;

static uint8_t set_cursor_pos[] = {0xFE, CURSOR_POS_BASE};
static uint8_t reset[] = {0x12};
static uint8_t clear_display[] = {0xFE, 0x01};
static uint8_t backlight_off[] = {0x7C, 0x80};
static uint8_t clear_line[] = "                    ";


void Display_newline(mss_uart_instance_t *this_uart, const uint8_t *content);
void Display_frame(mss_uart_instance_t *this_uart);
void Display_newline_scroll(mss_uart_instance_t *this_uart, const uint8_t *content);
bool Display_lineEmpty(int line);
void Display_initializeMenu();
void Display_displayMenu();

#endif
