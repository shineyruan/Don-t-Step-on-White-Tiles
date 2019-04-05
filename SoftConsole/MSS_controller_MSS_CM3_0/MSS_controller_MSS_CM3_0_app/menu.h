#ifndef __MENU_H__
#define __MENU_H__

#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "drivers/mss_uart/mss_uart.h"

#define CURSOR_POS_BASE 0x80

typedef enum ModeSelect {
    SLOW,
    MEDIUM,
    FAST
} Mode;

typedef enum SelectionLocation {
    ROOT,
    MODE,
    SONG,
    PRINT
} MenuLocation;

typedef struct LCD {
    /* data */
    uint8_t curr_line_num;
    uint8_t lines[4][20];
} LCD_Display;

typedef struct menu
{
    int start_line;
    int end_line;
    int curr_selection;
    int length;
    MenuLocation curr_location;
    uint8_t layer[6][20];
} Menu;

typedef struct Selections
{
    Mode selected_mode;
    int selected_song;
} Selected;

bool started;
LCD_Display Display;
Menu myMenu;
Selected selected_config;

static uint8_t line_start[] = {0, 64, 20, 84};
static uint8_t set_cursor_pos[] = {0xFE, CURSOR_POS_BASE};
static uint8_t reset[] = {0x12};
static uint8_t clear_display[] = {0xFE, 0x01};
static uint8_t backlight_off[] = {0x7C, 0x80};
static uint8_t clear_line[] = "                    ";

void Display_clearMenu();
void Display_frame(mss_uart_instance_t *this_uart);
bool Display_lineEmpty(int line);
void Display_initializeMenu();
void Display_displayMenu(mss_uart_instance_t *this_uart);
void Display_scrollDownMenu();
void Display_scrollUpMenu();
void Display_enterModeSelections();
void Display_enterSongSelections();
void Display_enterPrintConfig();
void Display_returnLastMenu();

#endif
